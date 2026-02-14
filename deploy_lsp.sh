#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# read version from package.json
VERSION=$(grep '"version"' clients/vscode/package.json | head -1 | sed 's/.*"\([0-9][0-9.]*\)".*/\1/')
RELEASE_DIR="objeck-lsp-${VERSION}"

echo ""
echo "========================================"
echo " Objeck LSP v${VERSION} - Release Build"
echo "========================================"
echo ""

# --- clean ---
echo "[1/6] Cleaning..."
rm -rf "$RELEASE_DIR"
mkdir "$RELEASE_DIR"

# --- generate API docs ---
echo "[2/6] Generating API documentation..."
cd server/doc_json
chmod +x gen_json.sh
./gen_json.sh "$VERSION"
cd ..

# --- build server ---
echo "[3/6] Building LSP server..."
chmod +x build_server.sh
./build_server.sh
cd ..

# --- package VS Code extension ---
echo "[4/6] Packaging VS Code extension..."
cd clients/vscode
vsce package
cd ../..

# --- assemble release ---
echo "[5/6] Assembling release package..."

# server binaries
mkdir -p "$RELEASE_DIR/server"
cp server/objeck_lsp.obe "$RELEASE_DIR/server/"
cp server/objk_apis.json "$RELEASE_DIR/server/"
cp server/lsp_server.cmd "$RELEASE_DIR/server/"
cp server/lsp_server.sh "$RELEASE_DIR/server/"
chmod +x "$RELEASE_DIR/server/lsp_server.sh"

# VS Code extension
mkdir -p "$RELEASE_DIR/clients/vscode"
cp clients/vscode/*.vsix "$RELEASE_DIR/clients/vscode/"

# editor configs
for dir in sublime neovim emacs helix; do
	mkdir -p "$RELEASE_DIR/clients/${dir}"
done
cp clients/sublime/LSP.sublime-settings "$RELEASE_DIR/clients/sublime/"
cp clients/neovim/objeck.lua "$RELEASE_DIR/clients/neovim/"
cp clients/emacs/objeck-mode.el "$RELEASE_DIR/clients/emacs/"
cp clients/helix/languages.toml "$RELEASE_DIR/clients/helix/"

# docs
cp README.txt "$RELEASE_DIR/"
cp docs/install_guide.html "$RELEASE_DIR/"
cp build.json.example "$RELEASE_DIR/"

# --- zip ---
echo "[6/6] Creating release archive..."
if [ "${1}" != "deploy" ]; then
	echo "Skipping zip (pass 'deploy' to create archive)"
else
	rm -f objeck-lsp-*.zip
	zip -r "${RELEASE_DIR}.zip" "$RELEASE_DIR"
fi

echo ""
echo "========================================"
echo " Build successful"
echo "========================================"
echo ""
echo " Version:      ${VERSION}"
echo " Release dir:  ${RELEASE_DIR}/"
if [ "${1}" = "deploy" ]; then
	echo " Archive:      ${RELEASE_DIR}.zip"
fi
echo ""
