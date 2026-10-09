#!/usr/bin/env bash
set -Eeuo pipefail

# NixOS 26.05 + GNOME + Home Manager
# Configuration: https://github.com/rysepechizen/Nixos
# WARNING: Erases the entire selected disk.

REPO="https://github.com/rysepechizen/Nixos"
USERNAME="sanzay"

die() { echo "ERROR: $*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"; }

[[ $EUID -eq 0 ]] || die "Run this script as root."
[[ -d /sys/firmware/efi ]] || die "Boot the USB in UEFI mode."

for cmd in lsblk sgdisk partprobe udevadm mkfs.fat mkfs.btrfs \
  mount umount git nixos-generate-config nixos-install \
  nix-channel nixos-rebuild btrfs; do
  need "$cmd"
done

echo "Available disks:"
lsblk -dpno NAME,SIZE,MODEL,TYPE | awk '$4 == "disk"'
echo

read -r -p "Target disk (example /dev/sda): " DISK
[[ -b "$DISK" ]] || die "Not a block device."
[[ "$(lsblk -dn -o TYPE "$DISK" | xargs)" == "disk" ]] ||
  die "Select the whole disk, not a partition."

echo
lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINTS "$DISK"
echo
echo "ALL DATA on $DISK WILL BE DESTROYED."
echo "This includes Windows, recovery partitions, and existing NixOS."
read -r -p "Type exactly ERASE $DISK to continue: " CONFIRM
[[ "$CONFIRM" == "ERASE $DISK" ]] ||
  die "Confirmation mismatch. Nothing changed."

# Unmount target partitions and disable their swap, if any.
while read -r node; do
  swapoff "$node" 2>/dev/null || true
  umount "$node" 2>/dev/null || true
done < <(lsblk -lnpo NAME "$DISK" | tac)

# Handle SATA/SCSI and NVMe partition naming.
case "$DISK" in
  *nvme*n*|*mmcblk*) PART="${DISK}p" ;;
  *) PART="$DISK" ;;
esac

EFI="${PART}1"
ROOT="${PART}2"

# GPT: 1 GiB EFI + remaining space for Linux.
sgdisk --zap-all "$DISK"
sgdisk --clear \
  --new=1:1MiB:+1GiB --typecode=1:EF00 --change-name=1:EFI \
  --new=2:0:0 --typecode=2:8300 --change-name=2:NIXOS \
  "$DISK"

partprobe "$DISK"
udevadm settle
[[ -b "$EFI" && -b "$ROOT" ]] || die "Partitions not found."

mkfs.fat -F 32 -n EFI "$EFI"
mkfs.btrfs -f -L NIXOS "$ROOT"

# Create Btrfs subvolumes.
mkdir -p /mnt
mount "$ROOT" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
umount /mnt

# Mount the new filesystem.
mkdir -p /mnt/home /mnt/nix /mnt/boot /mnt/etc
mount -o subvol=@,compress=zstd,noatime "$ROOT" /mnt
mount -o subvol=@home,compress=zstd,noatime "$ROOT" /mnt/home
mount -o subvol=@nix,compress=zstd,noatime "$ROOT" /mnt/nix
mount "$EFI" /mnt/boot

# Generate hardware config separately, so the repository's
# configuration.nix is never overwritten by nixos-generate-config.
nixos-generate-config --root /mnt --show-hardware-config \
  > /tmp/hardware-configuration.nix

git clone --depth 1 "$REPO" /mnt/etc/nixos
cp /tmp/hardware-configuration.nix \
  /mnt/etc/nixos/hardware-configuration.nix

# Set the 26.05 channels used by the repository.
nix-channel --add \
  https://nixos.org/channels/nixos-26.05 nixos
nix-channel --add \
  https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz \
  home-manager
nix-channel --update

echo
echo "Configuration cloned. Checking the NixOS build..."
nixos-rebuild dry-build \
  -I nixos-config=/mnt/etc/nixos/configuration.nix

echo
echo "Dry build passed. Installing NixOS..."
nixos-install --root /mnt

echo
echo "Setting password for $USERNAME..."
nixos-enter --root /mnt -c "passwd $USERNAME"

echo
echo "Installation finished. Reboot and remove the USB."
