import fs from "fs";
import path from "path";
import ejs from "ejs";
import yaml from "js-yaml";

const readYaml = (filePath) =>
  yaml.load(fs.readFileSync(filePath, "utf-8"));

const resolvePackageDir = (name) => {
  for (const base of ["./repositories/packages", "./repositories/drivers"]) {
    const dir = path.join(base, name);
    if (fs.existsSync(dir)) return dir;
  }
  return null;
};

const pkgName = (entry) => Object.keys(entry)[0];

const resolvePkgMeta = (entry) => {
  const pkgDir = resolvePackageDir(pkgName(entry));
  if (!pkgDir) return null;
  const pkgYml = path.join(pkgDir, "package.yml");
  if (!fs.existsSync(pkgYml)) return null;
  return { dir: pkgDir, meta: readYaml(pkgYml) };
};

// Load all profiles
const profileFiles = fs
  .readdirSync("./profiles")
  .filter((f) => f.endsWith(".yml"));

const profiles = profileFiles.map((file) => {
  const name = path.basename(file, ".yml");
  const profile = readYaml(`./profiles/${file}`);

  // Group packages by repository
  const byRepo = {};
  const plugins = [];

  for (const entry of profile.packages || []) {
    const resolved = resolvePkgMeta(entry);
    if (!resolved) continue;

    const { dir, meta } = resolved;
    const repo = meta.repository;

    if (!byRepo[repo]) byRepo[repo] = [];
    byRepo[repo].push(meta);

    // Check for plugins.yml (browser plugins)
    const pluginsYml = path.join(dir, "plugins.yml");
    if (fs.existsSync(pluginsYml)) {
      plugins.push({ package: meta, ...readYaml(pluginsYml) });
    }
  }

  // Build groups: official (core+extra), external, aur
  const groups = [];
  const official = [...(byRepo.core || []), ...(byRepo.extra || [])];
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
  const driverPkgs = (profile.drivers || [])
    .map((entry) => resolvePkgMeta(entry))
    .filter(Boolean)
    .map(({ meta }) => meta);

  if (driverPkgs.length > 0) {
    groups.push({ label: "Drivers", packages: driverPkgs });
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

ejs.renderFile(
  "./docs/readme/README.ejs",
  { profiles, sortByLabel, sortByName },
  {},
  function (err, str) {
    if (err) {
      console.error(err);
      return;
    }
    fs.writeFileSync("README.md", str, "utf-8");
  }
);
