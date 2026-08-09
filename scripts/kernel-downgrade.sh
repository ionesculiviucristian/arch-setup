#!/usr/bin/env bash
# Revine la kernelul 7.2.3, care mergea inainte de actualizarea din 10 sep 2026.
#
# Context: linux 7.2.3.arch1-2 -> 7.2.4.arch1-2 s-a instalat pe 10 sep la 17:20,
# iar dupa reboot au aparut linii orizontale intermitente pe DP-1 (3440x1440@144).
# Simptomul persista cu GPU-ul idle, deci nu tine de incarcare, ci de driver.
#
#   ./kernel-downgrade.sh            downgrade + regenerare GRUB
#   ./kernel-downgrade.sh --ignore   in plus, blocheaza actualizarea kernelului
#   ./kernel-downgrade.sh --undo     revine la kernelul curent din depozite
set -euo pipefail

VERSIUNE=7.2.3.arch1-2
CACHE=/var/cache/pacman/pkg
PKG="${CACHE}/linux-${VERSIUNE}-x86_64.pkg.tar.zst"
HDR="${CACHE}/linux-headers-${VERSIUNE}-x86_64.pkg.tar.zst"

rosu()  { printf '\033[31m%s\033[0m\n' "$*"; }
verde() { printf '\033[32m%s\033[0m\n' "$*"; }

if [ "${1:-}" = "--undo" ]; then
  verde "Revin la kernelul din depozite si scot blocajul."
  sudo sed -i '/^IgnorePkg *= *linux linux-headers$/d' /etc/pacman.conf
  sudo pacman -Syu linux linux-headers
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  verde "Gata. Reporneste."
  exit 0
fi

echo "Kernel curent : $(uname -r)"
echo "Tinta         : ${VERSIUNE}"
echo

for f in "${PKG}" "${HDR}"; do
  [ -f "${f}" ] || { rosu "LIPSESTE din cache: ${f}"; exit 1; }
done
verde "Ambele pachete sunt in cache."

# Headers-ul e obligatoriu: it87-dkms si modulele ROCm se recompileaza la
# instalare. Fara headers potrivite pierzi senzorii de temperatura.
echo
echo "Se vor instala:"
echo "  linux         ${VERSIUNE}"
echo "  linux-headers ${VERSIUNE}"
echo
read -rp "Continui? [d/N] " raspuns
[ "${raspuns}" = "d" ] || [ "${raspuns}" = "D" ] || { echo "Anulat."; exit 0; }

sudo pacman -U --noconfirm "${PKG}" "${HDR}"

echo
verde "Regenerez configul GRUB..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

if [ "${1:-}" = "--ignore" ]; then
  if grep -q '^IgnorePkg *= *linux linux-headers$' /etc/pacman.conf; then
    echo "Blocajul exista deja."
  else
    sudo sed -i '/^\[options\]/a IgnorePkg = linux linux-headers' /etc/pacman.conf
    verde "Adaugat IgnorePkg - kernelul nu se mai actualizeaza."
    echo "Il scoti cu: $0 --undo"
  fi
fi

echo
verde "Gata. Reporneste ca sa intre in vigoare."
echo
echo "Verifici dupa reboot:"
echo "  uname -r                 # trebuie sa arate 7.2.3-arch1-2"
echo "  sensors | head           # confirma ca it87-dkms s-a recompilat"
echo
echo "Daca liniile persista si pe 7.2.3, kernelul e nevinovat - spune-mi."
