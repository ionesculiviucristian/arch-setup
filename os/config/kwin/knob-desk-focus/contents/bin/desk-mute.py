#!/usr/bin/python3
# Mutes the audio streams of the given processes (and their child processes) and remembers them;
# "unmute" restores exactly the streams muted here, never ones muted by hand.
# Usage (systemd instance name): mute_<pid>_<pid>...  |  unmute
import json
import os
import subprocess
import sys

STATE = os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), "desk-mute.json")


def sink_inputs() -> list[dict]:
    out = subprocess.run(["pactl", "-f", "json", "list", "sink-inputs"], capture_output=True, text=True, check=True)
    return json.loads(out.stdout)


def ancestors(pid: int):
    while pid > 1:
        yield pid
        try:
            with open(f"/proc/{pid}/stat") as f:
                pid = int(f.read().rsplit(")", 1)[1].split()[1])
        except (OSError, ValueError, IndexError):
            return


def set_mute(index: int, mute: bool) -> None:
    subprocess.run(["pactl", "set-sink-input-mute", str(index), "1" if mute else "0"], check=False)


def mute(pids: set[int]) -> None:
    muted = []
    for s in sink_inputs():
        pid = int(s["properties"].get("application.process.id", 0) or 0)
        if s["mute"] or not pids.intersection(ancestors(pid)):
            continue
        set_mute(s["index"], True)
        muted.append(s["index"])
    with open(STATE, "w") as f:
        json.dump(muted, f)


def unmute() -> None:
    try:
        with open(STATE) as f:
            muted = set(json.load(f))
    except (OSError, ValueError):
        return
    for s in sink_inputs():
        if s["index"] in muted:
            set_mute(s["index"], False)
    os.remove(STATE)


action, *pids = sys.argv[1].split("_")
if action == "mute":
    mute({int(p) for p in pids if p.isdigit()})
elif action == "unmute":
    unmute()
