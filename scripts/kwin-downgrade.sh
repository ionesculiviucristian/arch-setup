#!/usr/bin/env bash
# Revine la KWin 6.7.4, dinainte de actualizarea din 10 sep 2026.
#
# Context: pe 10 sep s-au actualizat 264 de pachete, intre care kwin 6.7.4-7 ->
# 6.7.5-1 si tot Plasma 6.7.4 -> 6.7.5. Dupa reboot au aparut linii orizontale
# intermitente. Downgrade-ul de kernel (7.2.4 -> 7.2.3) NU a schimbat nimic, si
# nici KWIN_DRM_NO_DIRECT_SCANOUT=1 - deci nu e driverul, ci compozitorul.
# Mesa nu a fost atins in actualizare.
#
#   ./kwin-downgrade.sh          doar kwin (incearca asta intai)
#   ./kwin-downgrade.sh --tot    kwin + toate pachetele plasma 6.7.4 din cache
#   ./kwin-downgrade.sh --undo   revine la versiunile din depozite
#
# ATENTIE: dupa instalare trebuie sa te DECONECTEZI si sa te reconectezi.
# Nu rula "kwin_wayland --replace" - iti inchide toate ferestrele.
set -euo pipefail

CACHE=/var/cache/pacman/pkg
rosu()  { printf '\033[31m%s\033[0m\n' "$*"; }
verde() { printf '\033[32m%s\033[0m\n' "$*"; }
galben(){ printf '\033[33m%s\033[0m\n' "$*"; }

if [ "${1:-}" = "--undo" ]; then
  sudo sed -i '/^IgnorePkg *= *kwin.*$/d' /etc/pacman.conf
  sudo pacman -Syu
  verde "Gata. Deconecteaza-te si reconecteaza-te."
  exit 0
fi

if [ "${1:-}" = "--tot" ]; then
  mapfile -t PACHETE < <(ls -1 "${CACHE}"/*-6.7.4-*.pkg.tar.zst 2>/dev/null)
  galben "Downgrade COMPLET Plasma: ${#PACHETE[@]} pachete."
  galben "Mai riscant - Plasma prefera versiuni potrivite intre componente."
else
  PACHETE=(
    "${CACHE}/kwin-6.7.4-7-x86_64.pkg.tar.zst"
    "${CACHE}/kwin-x11-6.7.4-3-x86_64.pkg.tar.zst"
  )
  echo "Downgrade doar KWin (2 pachete)."
  echo "Daca Plasma se plange de dependente, reia cu: $0 --tot"
fi

for f in "${PACHETE[@]}"; do
  [ -f "${f}" ] || { rosu "LIPSESTE: ${f}"; exit 1; }
done
echo
printf '  %s\n' "${PACHETE[@]##*/}"
echo
read -rp "Continui? [d/N] " r
[ "${r}" = "d" ] || [ "${r}" = "D" ] || { echo "Anulat."; exit 0; }

sudo pacman -U --noconfirm "${PACHETE[@]}"

if ! grep -q '^IgnorePkg *= *kwin' /etc/pacman.conf; then
  sudo sed -i '/^\[options\]/a IgnorePkg = kwin kwin-x11' /etc/pacman.conf
  verde "Blocat din actualizari. Deblochezi cu: $0 --undo"
fi

echo
galben "DECONECTEAZA-TE si reconecteaza-te ca sa intre in vigoare."
galben "NU rula kwin_wayland --replace - iti inchide ferestrele."
echo
echo "Dupa relogare: pacman -Q kwin   # trebuie 6.7.4-7"
echo
echo "Daca liniile persista si pe 6.7.4, nu e nici compozitorul."
echo "Atunci raman: cablul DisplayPort, sau monitorul."
