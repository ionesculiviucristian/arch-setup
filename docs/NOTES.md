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

## NordVPN 5.3.0 leaves its nftables table behind on disconnect (no network at all)

Regression introduced by `nordvpn-bin 5.2.0-1 → 5.3.0-1` (upgraded 2026-08-13).
After `nordvpn disconnect` the machine has **no network whatsoever** until reboot.
Diagnosed 2026-08-15.

This is **not** the Kill Switch (`Kill Switch: disabled` here) and **not** a DNS
problem, even though it first looks like one — the first few seconds after
disconnect still work, so a quick test gives a false "only DNS is broken"
reading. Wait ~4 seconds for the daemon to re-apply its ruleset and everything
fails:

```
ping 192.168.1.1 (gateway)  : FAIL
ping 1.1.1.1                : FAIL
curl http://1.1.1.1         : timeout (000)
```

Everything else is torn down correctly — `ip rule`, routing table `205`, the
default route, `/etc/resolv.conf`, `/etc/NetworkManager/conf.d/zz-nordvpn-dns.conf`,
and even the sysctls (`arp_ignore` and `rp_filter` go back to `0`). The **only**
thing left behind is `table inet nordvpn`, and that is enough.

The cause is visible in a diff of `nft list ruleset` between the connected and
disconnected states. On disconnect the daemon removes the rules that accept
tunnel traffic:

```
- oifname "nordlynx" accept   comment "local to VPN"
- iifname "nordlynx" accept   comment "traffic from the tunnel"
```

but it leaves the table in place with `policy drop` intact:

```
chain output {
    type route hook output priority mangle; policy drop;   <- stays
    oifname "lo" accept
    ct mark 0x0000e1f1 accept
    meta mark 0x0000e1f1 ct mark set meta mark accept
    ip daddr @lan_ranges tcp dport 53 drop
    ip daddr @lan_ranges udp dport 53 drop
    ip daddr @allowlist_subnets meta mark set 0x0000e1f1 accept
}
```

So after disconnect the host is a blackhole. Only three things still pass:

- `lo`
- sockets carrying `SO_MARK 0xe1f1` — these belong to `nordvpnd` itself, which is
  why `nordvpn connect` keeps working while nothing else does
- `172.16.0.0/12` — the Docker allowlist from the section above, which is why the
  `ddp-*` containers keep running normally through the outage

A reboot fixes it only because nftables is not persisted across boots.

Fix, without waiting for a reboot:

```bash
sudo nft delete table inet nordvpn
```

Diagnosis commands (run the snapshot twice, connected and ~4s after disconnect,
then diff the two rulesets):

```bash
sudo nft list ruleset | sed -n '/table inet nordvpn/,/^}/p'
ip rule show; ip route show table 205
sysctl net.ipv4.conf.all.{arp_ignore,rp_filter}
ping -c1 -W2 1.1.1.1
```

5.3.0 also added `nordvpn diagnostics`, which collects system/network/firewall
state into a single file — the right artifact to attach to a bug report.

### Do not "fix" this with `nordvpn set firewall disable`

It works (the table is never created), but on this machine it is a bad trade.
`ufw`, `firewalld` and `nftables.service` are all inactive, so **`table inet
nordvpn` is the only host firewall present**. Disabling it costs two things:

1. **Leak protection.** `output policy drop` + `oifname "nordlynx" accept` is what
   guarantees that if the tunnel drops while the client still believes it is
   connected, packets are dropped instead of falling back out through `enp9s0`
   with the real IP. Not theoretical — upstream
   [#1375](https://github.com/NordSecurity/nordvpn-linux/issues/1375) documents a
   ~10s `ENETUNREACHABLE` window during periodic NordLynx key rotation.
2. **Inbound host filtering.** `input policy drop` is currently what keeps the LAN
   out. Without it, `192.168.1.0/24` reaches `sshd` on `:22` and **proftpd on
   `:21`** (plaintext credentials).

Docker's published ports are unaffected either way: they are DNAT'd and traverse
the `forward` chain, not `input`, and `forward` already accepts
`@allowlist_subnets` (`172.16.0.0/12`), so they are LAN-reachable today regardless.

If the firewall is ever disabled, enable a real host firewall first.

### Upstream status

Unreported as of 2026-08-15 — no matching issue in `NordSecurity/nordvpn-linux`.
Related, and confirmation that 5.3.0 touched this code path: the 5.3.0 changelog
entry *"allowing mDNS traffic by default when LAN discovery is on"* is a change to
firewall rule generation, and
[#1699](https://github.com/NordSecurity/nordvpn-linux/issues/1699) (filed on the
5.3.0 release day) reports a second firewall regression in the same area.

Also relevant to the Docker allowlist above:
[#1374](https://github.com/NordSecurity/nordvpn-linux/issues/1374) — `allowlist add
subnet` does not exempt port 53, because the `ip daddr @lan_ranges ... dport 53 drop`
rules sit *before* the allowlist accept in the `output` chain.

## Boot drops to emergency mode: `unknown filesystem type 'vfat'` on `/boot`

Intermittent boot failure (seen 2026-08-11, three boots in a row, ~1 second each):

```
mount: /boot: unknown filesystem type 'vfat'
boot.mount: Mount process exited, code=exited, status=32/n/a
Dependency failed for Local File Systems
Reached target Emergency Mode
```

`/boot` (the EFI system partition, vfat) is `pass 2` in `/etc/fstab`, so it is
required by `local-fs.target`. When it fails, the whole target fails and systemd
drops to the emergency shell.

**The cause is not fstab and not the partition** — it is the kernel's on-demand
module autoload (`request_module`) failing. The giveaway is that in one of those
boots _two different_ filesystems failed in the same boot:

```
mount: /boot:    unknown filesystem type 'vfat'
mount: /mnt/hdd: unknown filesystem type 'ntfs3'
```

Everything else checked out: the modules exist on disk
(`/usr/lib/modules/$(uname -r)/kernel/fs/{fat,ntfs3}/`), `modules.dep.bin` was
current, the running kernel matched its module directory, `/etc/modprobe.d/` was
empty (no blacklists), and there was no pacman activity around the failures.

**The trigger is not identified.** Kernel, cmdline and initramfs were
byte-identical between the failing and the working boots, so it is timing- or
state-dependent, but a suspected race with the udev coldplug modprobe storm did
**not** hold up: counting kernel module-init messages in the 300ms window around
`mount /boot` shows no correlation with the outcome.

```
boot -4 | kernel-msgs in window:  19 | FAIL
boot -3 | kernel-msgs in window:   0 | FAIL   <- quiet window, still failed
boot -2 | kernel-msgs in window:  19 | FAIL
boot -1 | kernel-msgs in window:  16 | OK     <- busy window, still worked
boot  0 | kernel-msgs in window:   4 | OK
```

Do not read a single good boot as a fix. The three failures were followed by a
working boot with **zero** changes applied, and a `pacman -Syu` the same day
(`linux` 7.1.6 → 7.1.7) did not touch the module-loading stack — `kmod` and
`systemd` were not upgraded, and `vfat`/`ntfs3` are still modules rather than
built-ins in the new kernel, so autoload is still exercised on every boot. It
can recur.

Diagnosis commands:

```bash
journalctl --list-boots                       # failed boots last ~1 second
journalctl -b -1 -o short-precise | grep -B5 -A10 'unknown filesystem type'
ls /usr/lib/modules/"$(uname -r)"/kernel/fs/fat/   # modules present?
ls /etc/modprobe.d/                                # blacklists?
```

Fix — preload the filesystem modules so they are in the kernel before
`local-fs.target` runs (`systemd-modules-load` runs long before it). This makes
the failure mode impossible without needing to know the trigger, which is the
point: the modules are loaded unconditionally instead of on demand:

```
# /etc/modules-load.d/filesystems.conf
vfat
ntfs3
```

Provisioned by `os/scripts/setup_kernel_modules.sh`, wired into `os/setup.sh`
(the `pre` phase), so a fresh install gets it automatically.

`nls_cp437` and `nls_ascii` (needed by the `codepage=437,iocharset=ascii` mount
options on `/boot`) are **built into** the Arch kernel — check with
`grep nls_ /usr/lib/modules/$(uname -r)/modules.builtin` — so they never
autoload and must not be listed here.

Optional belt-and-braces: add `x-systemd.automount` to the `/boot` fstab entry.
It then mounts on first access (i.e. when `pacman -Syu` regenerates the
initramfs) and a mount hiccup can never take down `local-fs.target` again. Not
applied by default — the modules-load fix already removes the autoload step that
failed, and this only adds a second, independent safety net.

## `btrfsmaintenance` does nothing until the timers are enabled

Installed 2026-08-12 after `/` (btrfs, single 250 GB SSD, subvolumes `@`,
`@home`, `@pkg`, `@log`) ran out of space. Installing the package is **not**
enough — on Arch it ships every unit `disabled`:

```bash
systemctl list-timers 'btrfs*' --all   # 0 timers listed
```

Two separate things have to happen, and the second one is easy to miss.

**1. Enable the units.** `btrfsmaintenance-refresh.path` matters as much as the
timers: it watches `/etc/default/btrfsmaintenance` and re-applies the schedule
whenever the config changes.

```bash
sudo systemctl enable --now \
  btrfsmaintenance-refresh.path btrfs-balance.timer btrfs-scrub.timer btrfs-trim.timer
```

**2. Apply the schedule.** The timers ship with `OnCalendar=monthly` hardcoded;
the periods in the config are translated into drop-ins under
`/etc/systemd/system/btrfs-*.timer.d/` by `btrfsmaintenance-refresh.service`.
The `.path` unit only fires on config changes made _after_ it is active, so a
config edited before enabling it leaves every timer on the stock monthly
schedule — enabled, but silently running on the wrong cadence:

```bash
sudo systemctl start btrfsmaintenance-refresh.service
systemctl show btrfs-balance.timer -p TimersCalendar   # verify, don't assume
```

Config changes from the defaults (`/etc/default/btrfsmaintenance`):

- `BTRFS_TRIM_PERIOD="weekly"` — was `none`. It is off by default so it does not
  collide with `fstrim.timer`, but `fstrim.timer` is disabled here, so nothing
  was trimming the SSD at all.
- `BTRFS_BALANCE_DUSAGE="5 10 20"` — was `5 10`. The defaults are deliberately
  gentle and reclaim too few block groups on an almost full filesystem; the `20`
  pass costs more IO but actually frees space.

Left at their defaults: balance weekly, scrub monthly (`idle` IO priority),
defrag `none` (pointless here, and it breaks reflinks between snapshots).

Provisioned by `repositories/packages/btrfsmaintenance/setup.sh`, so a fresh
install gets all of this without the manual dance.

Note that balance is not a cure for a _full_ filesystem — it needs some free
space to work with. If `btrfs balance` itself fails with `ENOSPC`, delete
something (or drop old snapshots) first, then re-run.

### The actual cause was never btrfs

Worth writing down, because the filesystem got the blame: one year after the
install (2025-08-07 → 2026-08-12) nothing on this machine had ever cleaned up
after itself. At 183 GB used out of 232 GB:

| What               | Size                                            |
| ------------------ | ----------------------------------------------- |
| Docker volumes     | 88 GB (72 GB of it in 74 dangling volumes)      |
| Docker images      | 25.5 GB                                         |
| Docker build cache | 7.9 GB                                          |
| `~/Projects`       | 45 GB                                           |
| `~/.cache`         | 18 GB (yay 4.1, huggingface 2.9, puppeteer 1.9) |
| Pacman cache       | 13 GB                                           |
| Journal            | 3.5 GB                                          |

A one-off cleanup (`paccache -rk1`, `journalctl --vacuum-size=500M`,
`docker builder prune`, dropping the yay and puppeteer caches) took it back to
167 GB. Two of those had no business growing in the first place and are now
capped automatically:

- **`paccache.timer` ships disabled** — that alone is why the pacman cache
  reached 13 GB. Enabled in `repositories/packages/pacman-contrib/setup.sh`,
  with `PACCACHE_ARGS="-k1"` in `/etc/conf.d/pacman-contrib` because a bare
  `paccache -r` still keeps 3 versions of every package.
- **journald had no `SystemMaxUse`**, so its limit was the default 10% of the
  filesystem — about 23 GB, i.e. effectively "until the disk is full". Capped at
  500M by `os/scripts/setup_journald.sh`. The
  `/etc/systemd/journald.conf.d/` directory does not exist on a stock Arch
  install, so it has to be created before writing the drop-in.

Docker is deliberately left alone: `docker volume prune` would happily delete
the data volumes of any stack that happens to be stopped. Only
`docker builder prune` (build cache) is safe to automate, and even that is left
manual.

What btrfs did contribute, for the record: after the cleanup `btrfs filesystem
df /` showed `Data total=175.01GiB, used=156.80GiB` — 18 GB sitting in
half-empty block groups. `df` counts that as free, but it is allocated to data
and cannot be handed to metadata, which is how btrfs manages to return `ENOSPC`
while `df` still shows free space. That is what the weekly balance is for.

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
