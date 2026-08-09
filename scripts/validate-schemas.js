import fs from "fs";
import path from "path";
import { Ajv2020 } from "ajv/dist/2020.js";
import addFormats from "ajv-formats";
import { load } from "js-yaml";

const settings = JSON.parse(fs.readFileSync("./.vscode/settings.json", "utf-8"));

const mappings = [
  ...Object.entries(settings["yaml.schemas"]).map(([schema, patterns]) => ({
    schema,
    patterns: [patterns].flat(),
    parse: load,
  })),
  ...settings["json.schemas"].map(({ url, fileMatch }) => ({
    schema: url,
    patterns: fileMatch.map((pattern) => pattern.replace(/^\//, "")),
    parse: JSON.parse,
  })),
];

const ajv = new Ajv2020({ allErrors: true, strict: false });
addFormats(ajv);

let failed = false;

for (const { schema, patterns, parse } of mappings) {
  const validate = ajv.compile(JSON.parse(fs.readFileSync(schema, "utf-8")));

  for (const file of patterns.flatMap((pattern) => fs.globSync(pattern))) {
    if (!validate(parse(fs.readFileSync(file, "utf-8")))) {
      failed = true;
      for (const error of validate.errors) {
        console.error(`${path.normalize(file)}: ${error.instancePath || "/"} ${error.message}`);
      }
    }
  }
}

process.exit(failed ? 1 : 0);
