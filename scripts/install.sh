#!/bin/bash
set -e

# ============================================================
#  Objeck LSP - Install Script (Linux / macOS)
#
#  Usage: ./install.sh <objeck_install_dir> <editor>
#    editor: vscode | sublime | neovim | emacs | all
#
#  Run from the extracted release directory (objeck-lsp-VERSION/)
# ============================================================

usage() {
    echo ""
    echo "  Usage: ./install.sh <objeck_install_dir> <editor>"
    echo ""
    echo "  Arguments:"
    echo "    objeck_install_dir  Path to Objeck installation (e.g. /usr/local/objeck)"
    echo "    editor              One of: vscode, sublime, neovim, emacs, all"
    echo ""
    echo "  Examples:"
    echo "    User install:    ./install.sh ~/objeck vscode"
    echo "    System install:  ./install.sh /usr/local/objeck all"
    echo ""
    exit 1
}

if [ -z "$1" ] || [ -z "$2" ]; then
    usage
fi

OBJECK_DIR="$1"
EDITOR="$2"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RELEASE_DIR="$(dirname "$SCRIPT_DIR")"
LSP_HOME="$HOME/.objeck-lsp"

# validate Objeck install
if [ ! -f "$OBJECK_DIR/bin/obr" ]; then
    echo "ERROR: Cannot find obr in $OBJECK_DIR/bin/"
    echo "Make sure the Objeck install directory is correct."
    exit 1
fi

# validate release directory
if [ ! -f "$RELEASE_DIR/server/objeck_lsp.obe" ]; then
    echo "ERROR: Cannot find server/objeck_lsp.obe in release directory."
    echo "Run this script from the extracted release directory."
    exit 1
fi

echo ""
echo "========================================"
echo " Objeck LSP - Install"
echo "========================================"
echo ""
echo " Objeck:     $OBJECK_DIR"
echo " LSP home:   $LSP_HOME"
echo " Editor:     $EDITOR"
echo ""

# --- create self-contained deployment ---
setup_lsp_home() {
    echo "[1] Creating self-contained deployment at $LSP_HOME..."
    mkdir -p "$LSP_HOME/bin" "$LSP_HOME/lib"

    # copy runtime
    cp "$OBJECK_DIR/bin/obr" "$LSP_HOME/bin/"
    chmod +x "$LSP_HOME/bin/obr"
    cp "$OBJECK_DIR"/lib/* "$LSP_HOME/lib/"

    # copy LSP server files
    cp "$RELEASE_DIR/server/objeck_lsp.obe" "$LSP_HOME/"
    cp "$RELEASE_DIR/server/objk_apis.json" "$LSP_HOME/"

    echo "   Done: $LSP_HOME"
}

# --- VS Code ---
install_vscode() {
    echo ""
    echo "[VS Code] Installing extension..."

    VSIX_FILE=$(find "$RELEASE_DIR/clients/vscode" -name "*.vsix" 2>/dev/null | head -1)
    if [ -z "$VSIX_FILE" ]; then
        echo "   WARNING: No .vsix file found in clients/vscode/"
        return
    fi

    if ! command -v code &>/dev/null; then
        echo "   WARNING: 'code' command not found. Install the extension manually:"
        echo "   Open VS Code, Extensions panel, drag-and-drop $VSIX_FILE"
        return
    fi

    code --install-extension "$VSIX_FILE" --force
    echo "   Extension installed."

    echo ""
    echo "   NOTE: Set the Objeck install path in VS Code settings:"
    echo "     \"objk.posix.install.dir\": \"$OBJECK_DIR\""
}

# --- Sublime Text ---
install_sublime() {
    echo ""
    echo "[Sublime Text] Installing..."

    # detect platform-specific Sublime path
    if [ "$(uname)" = "Darwin" ]; then
        SUBLIME_PKG="$HOME/Library/Application Support/Sublime Text/Packages"
    else
        SUBLIME_PKG="$HOME/.config/sublime-text/Packages"
    fi
    SUBLIME_OBJECK="$SUBLIME_PKG/Objeck"

    # install syntax highlighting
    mkdir -p "$SUBLIME_OBJECK"
    if [ -f "$RELEASE_DIR/clients/sublime/objeck.sublime-syntax" ]; then
        cp "$RELEASE_DIR/clients/sublime/objeck.sublime-syntax" "$SUBLIME_OBJECK/"
        echo "   Syntax file installed."
    fi

    # install LSP package if not present
    SUBLIME_LSP="$SUBLIME_PKG/LSP"
    if [ ! -d "$SUBLIME_LSP" ]; then
        if command -v git &>/dev/null; then
            echo "   Cloning LSP package..."
            git clone --depth 1 https://github.com/sublimelsp/LSP.git "$SUBLIME_LSP" >/dev/null 2>&1
        else
            echo "   NOTE: Install the LSP package via Package Control."
        fi
    fi

    # write LSP settings
    LSP_SETTINGS="$SUBLIME_PKG/User/LSP.sublime-settings"
    mkdir -p "$(dirname "$LSP_SETTINGS")"
    echo "   Writing LSP settings..."
    cat > "$LSP_SETTINGS" << EOLSP
{
	"clients": {
		"objeck": {
			"enabled": true,
			"command": [
				"$LSP_HOME/bin/obr",
				"$LSP_HOME/objeck_lsp.obe",
				"$LSP_HOME/objk_apis.json",
				"stdio"
			],
			"env": {
				"OBJECK_LIB_PATH": "$LSP_HOME/lib",
				"OBJECK_STDIO": "binary"
			},
			"selector": "source.objeck-obs"
		}
	}
}
EOLSP
    echo "   LSP settings written to $LSP_SETTINGS"
    echo ""
    echo "   Next: Open Sublime, go to Tools > LSP > Enable Language Server Globally > select \"objeck\""
}

# --- Neovim ---
install_neovim() {
    echo ""
    echo "[Neovim] Installing..."

    NVIM_LSP="$HOME/.config/nvim/lsp"
    NVIM_SYNTAX="$HOME/.config/nvim/syntax"
    mkdir -p "$NVIM_LSP" "$NVIM_SYNTAX"

    if [ -f "$RELEASE_DIR/clients/neovim/objeck.lua" ]; then
        sed "s|<objeck_server_path>|$LSP_HOME|g" \
            "$RELEASE_DIR/clients/neovim/objeck.lua" > "$NVIM_LSP/objeck.lua"
        echo "   Installed: $NVIM_LSP/objeck.lua"
    else
        echo "   WARNING: clients/neovim/objeck.lua not found in release."
    fi

    if [ -f "$RELEASE_DIR/clients/neovim/objeck.vim" ]; then
        cp "$RELEASE_DIR/clients/neovim/objeck.vim" "$NVIM_SYNTAX/"
        echo "   Installed: $NVIM_SYNTAX/objeck.vim"
    fi

    echo ""
    echo "   Add to your init.lua:"
    echo "     vim.filetype.add({ extension = { obs = 'objeck' } })"
    echo "     vim.lsp.enable('objeck')"
}

# --- Emacs ---
install_emacs() {
    echo ""
    echo "[Emacs] Installing..."

    EMACS_LISP="$HOME/.emacs.d/lisp"
    mkdir -p "$EMACS_LISP"

    if [ -f "$RELEASE_DIR/clients/emacs/objeck-mode.el" ]; then
        sed "s|<objeck_server_path>|$LSP_HOME|g" \
            "$RELEASE_DIR/clients/emacs/objeck-mode.el" > "$EMACS_LISP/objeck-mode.el"
        echo "   Installed: $EMACS_LISP/objeck-mode.el"
    else
        echo "   WARNING: clients/emacs/objeck-mode.el not found in release."
    fi

    echo ""
    echo "   Add to your init.el:"
    echo "     (add-to-list 'load-path \"~/.emacs.d/lisp\")"
    echo "     (require 'objeck-mode)"
}

# --- main ---
setup_lsp_home

case "$EDITOR" in
    vscode)  install_vscode ;;
    sublime) install_sublime ;;
    neovim)  install_neovim ;;
    emacs)   install_emacs ;;
    all)
        install_vscode
        install_sublime
        install_neovim
        install_emacs
        ;;
    *)
        echo "ERROR: Unknown editor \"$EDITOR\""
        usage
        ;;
esac

echo ""
echo "========================================"
echo " Install complete"
echo "========================================"
echo ""
