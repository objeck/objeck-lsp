#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# read version from package.json
VERSION=$(grep '"version"' clients/vscode/package.json | head -1 | sed 's/.*"\([0-9][0-9.]*\)".*/\1/')

echo ""
echo "========================================"
echo " Objeck LSP v${VERSION} - Release Build"
echo "========================================"
echo ""

# --- clean ---
echo "[1/6] Cleaning..."
rm -rf objeck-lsp
mkdir objeck-lsp

# --- generate API docs ---
echo "[2/6] Generating API documentation..."
cd server/doc_json
./gen_json.sh "$VERSION"
cd ..

# --- build server ---
echo "[3/6] Building LSP server..."
./build_server.sh
cd ..

# --- package VS Code extension ---
echo "[4/6] Packaging VS Code extension..."
cd clients/vscode
vsce package
mv *.vsix ../../objeck-lsp/
cd ../..

# --- assemble release ---
echo "[5/6] Assembling release package..."
cp README.txt objeck-lsp/
cp docs/install_guide.html objeck-lsp/

for dir in neovim emacs helix sublime; do
	mkdir -p "objeck-lsp/clients/${dir}"
done
cp clients/neovim/objeck.lua objeck-lsp/clients/neovim/
cp clients/emacs/objeck-mode.el objeck-lsp/clients/emacs/
cp clients/helix/languages.toml objeck-lsp/clients/helix/
cp clients/sublime/LSP.sublime-settings objeck-lsp/clients/sublime/

# --- zip ---
echo "[6/6] Creating release archive..."
if [ "${1}" != "deploy" ]; then
	echo "Skipping zip (pass 'deploy' to create archive)"
else
	rm -f objeck-lsp-*.zip
	zip -r "objeck-lsp-${VERSION}.zip" objeck-lsp
fi

echo ""
echo "========================================"
echo " Build successful"
echo "========================================"
echo ""
echo " Version:      ${VERSION}"
echo " Release dir:  objeck-lsp/"
if [ "${1}" = "deploy" ]; then
	echo " Archive:      objeck-lsp-${VERSION}.zip"
fi
echo ""
