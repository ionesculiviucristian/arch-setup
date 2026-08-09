import re
import sys
from collections import defaultdict

ALIASES_FILE = "./repositories/packages/bash/config/.bash_aliases"
ARG_PATTERN = re.compile(r"\$(\d+|@) \S+ (\S+)(?: \(optional(?:, default: (.+))?\))?")


def parse_arg(text):
    matches = ARG_PATTERN.fullmatch(text)
    if not matches:
        return None
    position, name, default = matches.groups()
    return {
        "name": name,
        "variadic": position == "@",
        "optional": "(optional" in text,
        "default": default,
    }


def get_aliases():
    aliases = []
    errors = []
    section = None
    alias = {}
    with open(ALIASES_FILE) as stream:
        for line_no, line in enumerate(stream, start=1):
            line = line.strip()
            if line.startswith("# @section "):
                section = line.removeprefix("# @section ").strip()
            elif line.startswith("# @description "):
                alias["description"] = line.removeprefix("# @description ").strip()
            elif line.startswith("# @arg "):
                arg = parse_arg(line.removeprefix("# @arg ").strip())
                if not arg:
                    errors.append(f"Invalid @arg in line {line_no}")
                    continue
                alias.setdefault("args", []).append(arg)
            elif line.startswith(("alias", "function")):
                if "description" not in alias:
                    alias = {}
                    continue
                matches = re.search("alias (.*?)=", line) or re.search(r"function (.*?)\(", line)
                if not matches:
                    errors.append(f"No alias found in line {line_no}")
                elif not section:
                    errors.append(f"Alias in line {line_no} has no @section")
                else:
                    aliases.append({**alias, "name": matches[1], "section": section})
                alias = {}
    if errors:
        sys.exit("\n".join(errors))
    return aliases


def format_usage(alias):
    usage = alias["name"]
    for arg in alias.get("args", []):
        name = f"{arg['name']}..." if arg["variadic"] else arg["name"]
        usage += f" [{name}]" if arg["optional"] else f" <{name}>"
    return usage


def format_description(alias):
    defaults = [f"{arg['name']}: {arg['default']}" for arg in alias.get("args", []) if arg["default"]]
    if not defaults:
        return alias["description"]
    return f"{alias['description']} (default {', '.join(defaults)})"


def generate_bash_info(grouped_aliases):
    with open("./repositories/packages/bash/config/.bash_aliases_help", "w") as stream:
        stream.write("# shellcheck shell=bash\n")
        stream.write("GC='\\033[0;36m'\n")
        stream.write("AC='\\033[0;32m'\n")
        stream.write("NC='\\033[0m'\n\n")
        stream.write("function aliases() {\n")
        for section, aliases in grouped_aliases.items():
            stream.write(f'\techo -e "\\n${{GC}}{section}${{NC}}\\n"\n')
            for alias in aliases:
                name, _, params = format_usage(alias).partition(" ")
                params = f" {params}" if params else ""
                stream.write(f"\techo -e \"  ${{AC}}{name}${{NC}}{params}: {format_description(alias)}\"\n")
        stream.write("}\n")


def generate_info():
    grouped_aliases = defaultdict(list)
    for alias in get_aliases():
        grouped_aliases[alias["section"]].append(alias)
    for section in grouped_aliases:
        grouped_aliases[section].sort(key=lambda alias: alias["name"])
    generate_bash_info(grouped_aliases)


if __name__ == "__main__":
    generate_info()
