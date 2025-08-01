import re
from collections import defaultdict

group_labels = {
    "docker_compose": "Docker compose",
    "docker": "Docker",
    "files": "File system",
    "git": "git",
    "misc": "Misc",
    "pkgmgr": "Packages manager",
    "poetry": "poetry",
    "projects": "Projects",
    "tmux": "tmux",
}


def get_aliases():
    aliases = []
    with open("./configs/.bash_aliases") as stream:
        alias = {}
        line_no = 1
        for line in stream:
            line = line.strip()
            if "# @info" in line:
                alias["info"] = line.replace("# @info", "").strip()
            elif "# @group" in line:
                alias["group"] = line.replace("# @group", "").strip()
            elif "# @param" in line:
                param = {}
                required_matches = re.search("<(.*?)>", line)
                optional_matches = re.search("\\[(.*?)\\]", line)
                if not required_matches and not optional_matches:
                    print(f"Invalid param in line {line_no}")
                    continue
                if required_matches:
                    param["name"] = required_matches[1]
                    param["required"] = True
                elif optional_matches:
                    param["name"] = optional_matches[1]
                    param["required"] = False
                    default_matches = re.search("{(.*?)}", line)
                    param["default"] = default_matches[1] if default_matches else None
                alias["params"] = [*alias["params"], param] if "params" in alias else [param]
            elif line.startswith("alias") or line.startswith("function"):
                # Skip undocumented aliases
                if len(alias.keys()) == 0:
                    continue
                if set({"info", "group"}).issubset(alias.keys()):
                    matches = re.search("alias (.*?)=", line) or re.search("function (.*?)\\(", line)
                    if matches:
                        alias["name"] = matches[1]
                        aliases.append(alias)
                    else:
                        print(f"No alias found in line {line_no}")
                else:
                    print(f"Alias in line {line_no} has incomplete metadata")
                alias = {}
            line_no += 1
    return aliases


def generate_bash_info(grouped_aliases):
    with open("./configs/.bash_aliases_help", "w") as stream:
        stream.write("GC='\\033[0;36m'\n")
        stream.write("AC='\\033[0;32m'\n")
        stream.write("NC='\\033[0m'\n\n")
        stream.write("function aliases() {\n")
        for group in grouped_aliases:
            label = group_labels[group] if group in group_labels else "Aliases group"
            stream.write(f'\techo -e "\\n${{GC}}{label}${{NC}}\\n"\n')
            for alias in grouped_aliases[group]:
                params = ""
                for param in alias["params"] if "params" in alias else []:
                    if param["required"]:
                        params += f" <{param['name']}>"
                    else:
                        params += f" [{param['name']}]"
                        if param["default"]:
                            params += f" {{{param['default']}}}"
                stream.write(f"\techo -e \"  ${{AC}}{alias['name']}${{NC}}{params}: {alias['info']}\"\n")
        stream.write("}\n")


def generate_md_info(grouped_aliases):
    with open("./ALIASES.md", "w") as stream:
        stream.write("# Aliases\n")
        for group in grouped_aliases:
            label = group_labels[group] if group in group_labels else "Aliases group"
            stream.write(f"\n## {label}\n\n")
            for alias in grouped_aliases[group]:
                params = ""
                for param in alias["params"] if "params" in alias else []:
                    if param["required"]:
                        params += f" <{param['name']}>"
                    else:
                        params += f" [{param['name']}]"
                        if param["default"]:
                            params += f" {{{param['default']}}}"
                info = alias["info"].replace(r"\`", "`")
                stream.write(f"- `{alias['name']}{params}`: {info}\n")


def generate_info():
    aliases = get_aliases()
    grouped_aliases = defaultdict(list)
    for alias in aliases:
        grouped_aliases[alias["group"]].append(alias)
    for key in grouped_aliases:
        grouped_aliases[key] = sorted(grouped_aliases[key], key=lambda x: x["name"])
    generate_bash_info(grouped_aliases)
    generate_md_info(grouped_aliases)


if __name__ == "__main__":
    generate_info()
