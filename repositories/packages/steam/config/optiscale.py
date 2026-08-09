#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
import tempfile
import time
import urllib.request
from pathlib import Path

import vdf

ACCOUNT_ID_OFFSET = 76561197960265728
RELEASE_URL = "https://api.github.com/repos/optiscaler/OptiScaler/releases/latest"
STEAM_DIR = Path.home() / ".local/share/Steam"
STEAM_SHUTDOWN_SECONDS = 30


def fail(message):
    print(f"Error: {message}", file=sys.stderr)
    sys.exit(1)


def read_vdf(path):
    with open(path, encoding="utf-8", errors="surrogateescape") as stream:
        return vdf.load(stream, mapper=vdf.VDFDict)


def find_key(mapping, name):
    return next((key for key in mapping if key.lower() == name.lower()), None)


def find_game_dir():
    current = Path.cwd()

    for path in (current, *current.parents):
        if path.parent.name == "common" and path.parent.parent.name == "steamapps":
            return path

    fail("Run this from a game folder under steamapps/common")


def find_app_id(game_dir):
    steamapps_dir = game_dir.parent.parent

    for manifest in steamapps_dir.glob("appmanifest_*.acf"):
        state = read_vdf(manifest)["AppState"]

        if state["installdir"] == game_dir.name:
            return state["appid"]

    fail(f"No Steam manifest found for {game_dir.name}")


def find_local_config():
    users = read_vdf(STEAM_DIR / "config/loginusers.vdf")["users"]
    steam_id = max(
        users,
        key=lambda user: (
            users[user].get("MostRecent") == "1",
            int(users[user].get("timestamp", 0)),
        ),
    )
    account_id = int(steam_id) - ACCOUNT_ID_OFFSET
    path = STEAM_DIR / f"userdata/{account_id}/config/localconfig.vdf"

    if not path.is_file():
        fail(f"Steam config not found: {path}")

    return path


def is_steam_running():
    return subprocess.run(["pgrep", "-x", "steam"], capture_output=True).returncode == 0


def stop_steam():
    if not is_steam_running():
        return

    print("Closing Steam...")
    subprocess.run(["steam", "-shutdown"], capture_output=True)

    for _ in range(STEAM_SHUTDOWN_SECONDS):
        if not is_steam_running():
            return

        time.sleep(1)

    fail("Steam did not close, close it and run this again")


def download_release(target):
    with urllib.request.urlopen(RELEASE_URL, timeout=30) as response:
        release = json.load(response)

    asset = next(a for a in release["assets"] if a["name"].endswith(".7z"))
    print(f"Downloading {asset['name']}...")

    with urllib.request.urlopen(asset["browser_download_url"], timeout=120) as response:
        target.write_bytes(response.read())


def install_optiscaler(filename):
    with tempfile.TemporaryDirectory() as temp_dir:
        archive = Path(temp_dir) / "optiscaler.7z"
        download_release(archive)
        subprocess.run(
            ["7z", "x", "-y", str(archive)],
            check=True,
            stdout=subprocess.DEVNULL,
        )

    subprocess.run(
        [
            "bash",
            "setup_linux.sh",
            f"--filename={filename}",
            "--overwrite=y",
            "--using_nvidia=n",
            "--using_dlss=y",
        ],
        stdin=subprocess.DEVNULL,
    )

    if not Path(filename).is_file():
        fail(f"{filename} was not created by setup_linux.sh")


def merge_launch_options(current, override):
    if override in current:
        return current

    if "%command%" in current:
        return f"{override} {current}"

    return f"{override} {current} %command%".replace("  ", " ")


def set_launch_options(config_path, app_id, override):
    config = read_vdf(config_path)
    steam = config["UserLocalConfigStore"]["Software"]["Valve"]["Steam"]
    apps_key = find_key(steam, "apps")

    if apps_key is None:
        apps_key = "apps"
        steam[apps_key] = vdf.VDFDict()

    apps = steam[apps_key]

    if app_id not in apps:
        apps[app_id] = vdf.VDFDict()

    app = apps[app_id]
    options_key = find_key(app, "LaunchOptions") or "LaunchOptions"
    options = merge_launch_options(app.get(options_key, ""), override)

    if options_key in app:
        del app[options_key]

    app[options_key] = options
    temp_path = config_path.with_suffix(".vdf.part")

    with open(temp_path, "w", encoding="utf-8", errors="surrogateescape") as stream:
        vdf.dump(config, stream, pretty=True)

    os.chmod(temp_path, config_path.stat().st_mode)
    os.replace(temp_path, config_path)

    return options


def main():
    parser = argparse.ArgumentParser(
        description="Install OptiScaler for the Steam game in the current folder"
    )
    parser.add_argument(
        "--dx12",
        action="store_true",
        help="load OptiScaler as d3d12.dll instead of dxgi.dll",
    )
    filename = "d3d12.dll" if parser.parse_args().dx12 else "dxgi.dll"

    if not any(Path.cwd().glob("*.exe")):
        fail("Run this next to the game .exe")

    game_dir = find_game_dir()
    app_id = find_app_id(game_dir)
    config_path = find_local_config()

    stop_steam()
    install_optiscaler(filename)
    options = set_launch_options(
        config_path,
        app_id,
        f"WINEDLLOVERRIDES={filename}=n,b",
    )

    print(f"{game_dir.name} ({app_id}) launch options: {options}")


if __name__ == "__main__":
    main()
