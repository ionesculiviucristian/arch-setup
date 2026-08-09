# Notes

## Python: no more `__pycache__` in project trees

`PYTHONPYCACHEPREFIX` redirects all Python bytecode caches to a central
directory instead of littering every project with `__pycache__/` folders.
Caching still works (no speed loss), it just lives in `~/.cache/python`.

Configured in two places (2026-06-05):

- `~/.config/environment.d/10-python.conf` — picked up by the systemd user
  session (KDE Wayland), so it applies to GUI apps like VS Code:

  ```
  PYTHONPYCACHEPREFIX=/home/liviu/.cache/python
  ```

- `~/.bash_profile` — for login shells / TTY:

  ```bash
  export PYTHONPYCACHEPREFIX="$HOME/.cache/python"
  ```

Requires relogin (or reboot) to take effect in the graphical session.

One-time cleanup of existing folders:

```bash
find ~/Projects -name __pycache__ -type d -prune -exec rm -rf {} +
```

## `zoom` (AUR) — drop the qt5-webengine optdeps to stop source rebuilds

`zoom` does **not** need `qt5-webengine`. The AUR package ships its own bundled
Qt; `qt5-webengine` + `qt5-remoteobjects` are listed only as **optional deps**
("fallback for bundled qt"). Nothing else requires them (`pactree -r
qt5-webengine` → only itself).

Why they were a problem: around mid-November 2025 Arch dropped the Qt5 webengine
stack from the official repos (Qt5 is EOL), so `qt5-webengine`, `qt5-location`,
`qt5-webchannel`, `qt5-remoteobjects` became **AUR-only** and now **compile from
source on every Qt 5.15.x bump** — `qt5-webengine` bundles Chromium, one of the
longest builds in AUR. Before that they came as binaries from `extra/`, which is
why the long compiles only started appearing recently.

Fix (keeps Zoom desktop working on its bundled Qt):

```bash
sudo pacman -Rs qt5-webengine qt5-remoteobjects
# removes qt5-webengine, qt5-webchannel, qt5-location, qt5-remoteobjects
```

These are optdepends, so yay won't auto-reinstall them → no more rebuilds.
(If desired, the Zoom web client in Brave/Chrome or the flatpak
`us.zoom.Zoom` avoid the AUR package entirely.)

## NordVPN breaks Docker bridge networking (allowlist the subnets)

When NordVPN connects with `Firewall: enabled`, its nftables rules block traffic
from the host into the Docker bridge subnets. Symptom (seen with the
`docker-dashboard` / `ddp-*` stack): `*.services.local` won't load in the browser,
even though every container is healthy and containers talk to each other fine.
Host→container fails — TCP connects (docker-proxy answers) but the TLS handshake
hangs, and even hitting a container IP directly (e.g. `172.25.0.10`) times out.

Diagnosis check:

```bash
nordvpn status                 # Connected?
ip -brief link | grep nordlynx # VPN iface up
docker inspect ddp-traefik-1 --format '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}'
curl -sk -o /dev/null -w '%{http_code}\n' https://172.25.0.10/ # times out (000) when broken
```

Fix — allowlist the whole Docker range (covers all default 172.16–172.31 bridges),
persists across reconnects:

```bash
nordvpn allowlist add subnet 172.16.0.0/12
```

Verify: `curl -sk -o /dev/null -w '%{http_code}\n' https://homepage.services.local/`
should return `302` (Authentik login redirect = working).

TODO for permanent setup: bake this allowlist entry into the arch-setup provisioning
so a fresh install / NordVPN reinstall applies it automatically (e.g. a
`scripts/nordvpn.sh` step running the `allowlist add` command). NordVPN stores the
setting per-user, so it needs to run once after the CLI is logged in.

## TODO: add `github-cli` (the `gh` CLI)

Add the official GitHub CLI to the setup. Arch package is **`github-cli`**
(repo `extra`), which provides the `gh` binary.

Two steps, matching the existing package layout:

- Create `repositories/packages/github-cli/package.yml` (same shape as the
  others — `name: "github-cli"`, `repository: "extra"`, description/urls).
- Add it under `packages:` in `profiles/base.yml`:

  ```yaml
  - github-cli:
      install: true
      priority: "normal"
  ```
