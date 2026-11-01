#!/bin/bash
# Legend Code for Mac - one-step installer. Run:  bash install.sh   (or the one-line command from the guide)
set -e
PYVER=3.12.10
APP="Legend Code.app"; DEST="$HOME/Applications"; mkdir -p "$DEST"
have_py() { for P in /Library/Frameworks/Python.framework/Versions/3.*/bin/python3 /opt/homebrew/bin/python3 /usr/local/bin/python3; do
  [ -x "$P" ] && "$P" -c 'import sys,tkinter;sys.exit(0 if tkinter.TkVersion>=8.6 and sys.version_info>=(3,8) else 1)' 2>/dev/null && return 0; done; return 1; }
echo "==> Legend Code installer"
if ! have_py; then
  echo "==> Installing Python $PYVER from python.org (your Mac password will be asked once)..."
  TMP=$(mktemp -d); curl -fL --progress-bar -o "$TMP/python.pkg" "https://www.python.org/ftp/python/$PYVER/python-$PYVER-macos11.pkg"
  sudo installer -pkg "$TMP/python.pkg" -target /
  rm -rf "$TMP"
fi
SRC="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
if [ ! -d "$SRC/$APP" ]; then            # running from the one-line command: download the app first
  TMP=$(mktemp -d); echo "==> Downloading Legend Code..."
  curl -fL --progress-bar -o "$TMP/lc.zip" "https://github.com/MATRIX5578/legend-code/raw/main/mac/Legend-Code-Mac.zip"
  unzip -q "$TMP/lc.zip" -d "$TMP"; SRC="$TMP/Legend-Code-Mac"
fi
rm -rf "$DEST/$APP"; cp -R "$SRC/$APP" "$DEST/"
xattr -cr "$DEST/$APP" 2>/dev/null || true
chmod +x "$DEST/$APP/Contents/MacOS/LegendCode"
echo ""; echo "✅ Installed: $DEST/$APP"
open "$DEST/$APP"
