#!/usr/bin/env bash
set -e

# ---- CONFIG ----
PKHEX_EXE="$HOME/Games/PKHeX.exe"
PKHAX_EXE="$HOME/Games/PKHaX.exe"
# Update these when the upstream version or download link changes.
PKHEX_ZIP_NAME="PKHeX (25.12.21).zip"
PKHEX_URL="https://projectpokemon.org/home/files/file/1-pkhex/?do=download&csrfKey=bb277e616ab4e06e383ef1f4d1987306"
WINEPREFIX="$HOME/Games/wine-pkhex"
DPI=196

# ---- ENV ----
export WINEPREFIX
export WINEARCH=win64

# ----Check for PKHEX ARGS ----
usage() {
  cat >&2 <<'EOF'
Usage: pkhex.sh [hax]

Options:
  hax  Launch PKHaX mode.
EOF
}

if [ "$#" -gt 1 ] || { [ "$#" -eq 1 ] && [ "$1" != "hax" ]; }; then
  echo "Warning: invalid argument(s)." >&2
  usage
  exit 2
fi

# ---- DOWNLOAD PKHEX IF MISSING ----
if [ ! -f "$PKHEX_EXE" ]; then
  # Prompt before downloading external binaries.
  read -r -p "PKHeX.exe not found at $PKHEX_EXE. Download now? [y/N] " reply
  case "$reply" in
    [yY]|[yY][eE][sS])
      tmpdir="$(mktemp -d)"
      zip="$tmpdir/$PKHEX_ZIP_NAME"
      # Prefer curl, fallback to wget.
      if command -v curl >/dev/null 2>&1; then
        curl -L -o "$zip" "$PKHEX_URL"
      elif command -v wget >/dev/null 2>&1; then
        wget -O "$zip" "$PKHEX_URL"
      else
        echo "Neither curl nor wget is available for download." >&2
        exit 1
      fi
      # Extract and move the EXE into place.
      unzip -q "$zip" -d "$tmpdir"
      exe_path="$(find "$tmpdir" -name PKHeX.exe -print -quit)"
      if [ -z "$exe_path" ]; then
        echo "PKHeX.exe not found in downloaded archive." >&2
        exit 1
      fi
      mkdir -p "$(dirname "$PKHEX_EXE")"
      mv "$exe_path" "$PKHEX_EXE"
      rm -rf "$tmpdir"
      ;;
    *)
      echo "PKHeX.exe not found at $PKHEX_EXE" >&2
      exit 1
      ;;
  esac
fi

if [ ! -f "$PKHAX_EXE" ]; then
  echo "PKHaX.exe not found at $PKHAX_EXE" >&2
  echo "Creating a copy of PKHeX.exe as PKHaX.exe for homebrew compatibility."
  cp "$PKHEX_EXE" "$PKHAX_EXE"
fi

# ---- PREPARE WINEPREFIX ----
if [ ! -d "$WINEPREFIX" ]; then
  mkdir -p "$WINEPREFIX"
fi

# ---- SELECT EXE ----

EXE_TO_RUN="$PKHEX_EXE"
if [[ "$1" == "hax" ]]; then
  EXE_TO_RUN="$PKHAX_EXE"
  shift
fi

# ---- RUN ----
exec nix-shell -p wineWowPackages.full winetricks --command \
  "winetricks -q msaa oleaut32 comctl32 msxml6 dotnetdesktop9 && wine reg add \"HKCU\\Control Panel\\Desktop\" /v LogPixels /t REG_DWORD /d $DPI /f && wine \"$EXE_TO_RUN\""
