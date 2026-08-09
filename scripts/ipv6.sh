#!/usr/bin/env bash
# Reactiveaza IPv6 (scos ipv6.disable=1 din GRUB) si testeaza daca merge.
#
# Context: IPv6 a fost oprit pentru ca site-urile se incarcau greu, dar asa nu se
# deschid deloc site-urile doar pe IPv6 (ex. cgit.git.savannah.gnu.org).
#
#   ./ipv6.sh --enable       scoate ipv6.disable=1 + regenerare GRUB (apoi reboot)
#   ./ipv6.sh --test         dupa reboot: adresa, ruta, viteza -6 vs -4, site doar IPv6
#   ./ipv6.sh --prefer-ipv4  IPv6 ramane pornit, dar sistemul prefera IPv4 (/etc/gai.conf)
#   ./ipv6.sh --disable      pune la loc ipv6.disable=1 + regenerare GRUB
set -euo pipefail

GRUB=/etc/default/grub
GAI=/etc/gai.conf
GAI_LINE='precedence ::ffff:0:0/96 100'
# un singur host dual-stack pentru comparatie si unul doar IPv6; o cerere pe fiecare
DUAL=https://www.kernel.org/
ONLY6=https://cgit.git.savannah.gnu.org/cgit/grub.git/

rosu()  { printf '\033[31m%s\033[0m\n' "$*"; }
verde() { printf '\033[32m%s\033[0m\n' "$*"; }

regen_grub() {
  grep '^GRUB_CMDLINE_LINUX_DEFAULT=' "${GRUB}"
  sudo grub-mkconfig -o /boot/grub/grub.cfg >/dev/null
  verde "GRUB regenerat. Reporneste calculatorul."
}

timp() {
  curl "$1" -s -o /dev/null -m 20 -w '%{http_code} %{time_total}s' "$2" || echo "esuat"
}

case "${1:-}" in
  --enable)
    sudo sed -i -E -e 's/ipv6\.disable=1 //' -e 's/ ?ipv6\.disable=1//' "${GRUB}"
    regen_grub
    ;;
  --disable)
    grep -q 'ipv6\.disable=1' "${GRUB}" ||
      sudo sed -i -E 's/^(GRUB_CMDLINE_LINUX_DEFAULT=")/\1ipv6.disable=1 /' "${GRUB}"
    regen_grub
    ;;
  --prefer-ipv4)
    grep -qxF "${GAI_LINE}" "${GAI}" 2>/dev/null || echo "${GAI_LINE}" | sudo tee -a "${GAI}" >/dev/null
    verde "Sistemul prefera acum IPv4 pentru site-urile care au ambele adrese."
    ;;
  --test)
    if [[ -e /proc/sys/net/ipv6 ]]; then verde "IPv6 activ in kernel"; else rosu "IPv6 dezactivat in kernel (ai dat reboot?)"; exit 1; fi
    echo "Adrese globale:"; ip -6 addr show scope global | grep inet6 || rosu "  niciuna - ISP/routerul nu ofera IPv6"
    echo "Ruta implicita:"; ip -6 route show default || true
    echo "IPv4 ${DUAL}: $(timp -4 "${DUAL}")"; sleep 2
    echo "IPv6 ${DUAL}: $(timp -6 "${DUAL}")"; sleep 2
    echo "Doar IPv6 ${ONLY6}: $(timp -6 "${ONLY6}")"
    ;;
  *)
    sed -n '2,10p' "$0"
    exit 1
    ;;
esac
