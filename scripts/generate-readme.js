import fs from "fs";
import path from "path";
import ejs from "ejs";
import { load } from "js-yaml";

const readYaml = (filePath) => load(fs.readFileSync(filePath, "utf-8"));

const readDefinition = (filePath) => {
  const meta = readYaml(filePath);
  const url = meta.repository.url && new URL(meta.repository.url);
  const segments = url ? url.pathname.split("/").filter(Boolean) : [];
  const id =
    path.basename(filePath) === "package.yml"
      ? path.basename(path.dirname(filePath))
      : path.basename(filePath, ".yml");

  return {
    ...meta,
    name: segments.at(-1) ?? id,
    repositoryType: !url
      ? "external"
      : url.hostname === "aur.archlinux.org"
        ? "aur"
        : segments[1],
  };
};

const resolvePackageDir = (name) => {
  for (const base of ["./repositories/packages", "./repositories/drivers"]) {
    const dir = path.join(base, name);
    if (fs.existsSync(dir)) return dir;
  }
  return null;
};

const resolvePkgMeta = (name) => {
  const pkgDir = resolvePackageDir(name);
  if (!pkgDir) throw new Error(`No package or driver folder for profile entry ${name}`);
  const pkgYml = path.join(pkgDir, "package.yml");
  if (!fs.existsSync(pkgYml)) throw new Error(`Missing ${pkgYml}`);
  return { dir: pkgDir, meta: readDefinition(pkgYml) };
};

const readDefinitions = (dir) =>
  fs
    .readdirSync(dir)
    .filter((f) => f.endsWith(".yml"))
    .map((f) => readDefinition(path.join(dir, f)));

const fonts = readDefinitions("./repositories/fonts");
const requirements = readDefinitions("./repositories/requirements");

const packageDefinitions = ["./repositories/packages", "./repositories/drivers"]
  .flatMap((base) =>
    fs.readdirSync(base).map((dir) => path.join(base, dir, "package.yml"))
  )
  .filter((file) => fs.existsSync(file))
  .map(readDefinition);

// Group optional dependencies by the package that lists them
const optionalDependencies = {};

for (const meta of [...packageDefinitions, ...fonts, ...requirements]) {
  for (const { package: parent, reason } of meta.repository.optional_dependency_for || []) {
    optionalDependencies[parent] ??= [];
    optionalDependencies[parent].push({ ...meta, reason });
  }
}

// Load all profiles
const profileNames = fs
  .readdirSync("./profiles", { withFileTypes: true })
  .filter((entry) => entry.isDirectory())
  .map((entry) => entry.name)
  .sort(
    (a, b) => Number(b === "base") - Number(a === "base") || a.localeCompare(b),
  );

const profiles = profileNames.map((name) => {
  const profile = readYaml(`./profiles/${name}/profile.yml`);

  // Group packages by repository
  const byRepo = {};
  const plugins = [];

  for (const packageName of Object.keys(profile.packages || {})) {
    const { dir, meta } = resolvePkgMeta(packageName);
    const repo = meta.repositoryType;

    if (!byRepo[repo]) byRepo[repo] = [];
    byRepo[repo].push(meta);

    // Check for plugins.yml (browser plugins)
    const pluginsYml = path.join(dir, "plugins.yml");
    if (fs.existsSync(pluginsYml)) {
      plugins.push({ package: meta, ...readYaml(pluginsYml) });
    }
  }

  // Build groups: official (core+extra+multilib), external, aur
  const groups = [];
  const official = [
    ...(byRepo.core || []),
    ...(byRepo.extra || []),
    ...(byRepo.multilib || []),
  ];
  if (official.length > 0) {
    groups.push({ label: "Official Arch packages", packages: official });
  }
  if (byRepo.external) {
    groups.push({ label: "External packages", packages: byRepo.external });
  }
  if (byRepo.aur) {
    groups.push({ label: "AUR packages", packages: byRepo.aur });
  }

  // Drivers as a separate group
  const driverPkgs = Object.keys(profile.drivers || {})
    .map((driverName) => resolvePkgMeta(driverName).meta);

  if (driverPkgs.length > 0) {
    groups.push({ label: "Drivers", packages: driverPkgs });
  }

  if (name === "base") {
    groups.push({ label: "Fonts", packages: fonts });
    groups.push({ label: "Requirements", packages: requirements });
  }

  return {
    name,
    label: profile.name || name,
    groups,
    plugins,
  };
});

const sortByLabel = (a, b) =>
  a.label.toLowerCase().localeCompare(b.label.toLowerCase());
const sortByName = (a, b) =>
  a.name.toLowerCase().localeCompare(b.name.toLowerCase());

const base = profiles.find((profile) => profile.name === "base");
const helpers = { optionalDependencies, sortByLabel, sortByName };

const render = async (template, data, output) =>
  fs.writeFileSync(output, await ejs.renderFile(template, { ...helpers, ...data }), "utf-8");

await render("./docs/readme/README.ejs", { base, profiles }, "README.md");

for (const profile of profiles) {
  await render("./docs/readme/PROFILE_README.ejs", { profile }, `./profiles/${profile.name}/README.md`);
}
