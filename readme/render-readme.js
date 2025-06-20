import fs from "fs";
import ejs from "ejs";

const browserPlugins = JSON.parse(
  fs.readFileSync("./readme/data/browser_plugins.json", "utf-8")
);
const packages = JSON.parse(
  fs.readFileSync("./readme/data/packages.json", "utf-8")
);

ejs.renderFile(
  "./readme/README.ejs",
  { browserPlugins, packages },
  {},
  function (err, str) {
    if (err) {
      console.error(err);
      return;
    }
    fs.writeFileSync("README.md", str, "utf-8");
  }
);
