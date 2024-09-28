import fs from "fs";
import ejs from "ejs";

const packages = {};

packages["base"] = JSON.parse(
  fs.readFileSync("./data/packages/base.json", "utf-8")
);
packages["b450-i-aorus-pro-wifi"] = JSON.parse(
  fs.readFileSync("./data/packages/b450-i-aorus-pro-wifi.json", "utf-8")
);

const browserPlugins = JSON.parse(
  fs.readFileSync("./data/browser_plugins.json", "utf-8")
);

const sortPackages = (a, b) => a.label.toLowerCase().localeCompare(b.label);
const sortBrowserPlugins = (a, b) => a.name.toLowerCase().localeCompare(b.name);

ejs.renderFile(
  "./docs/readme/README.ejs",
  { packages, browserPlugins, sortPackages, sortBrowserPlugins },
  {},
  function (err, str) {
    if (err) {
      console.error(err);
      return;
    }
    fs.writeFileSync("README.md", str, "utf-8");
  }
);
