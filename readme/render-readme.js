import fs from "fs";
import ejs from "ejs";

const browserPlugins = JSON.parse(
  fs.readFileSync("./readme/data/browser_plugins.json", "utf-8")
);
const packages = JSON.parse(
  fs.readFileSync("./readme/data/packages.json", "utf-8")
);

const sortPackages = (a, b) => a.label.toLowerCase().localeCompare(b.label);
const sortBrowserPlugins = (a, b) => a.name.toLowerCase().localeCompare(b.name);

ejs.renderFile(
  "./readme/README.ejs",
  { browserPlugins, packages, sortPackages, sortBrowserPlugins },
  {},
  function (err, str) {
    if (err) {
      console.error(err);
      return;
    }
    fs.writeFileSync("README.md", str, "utf-8");
  }
);
