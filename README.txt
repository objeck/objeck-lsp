v1.0.2
===

What's new
* Fixed bug with find definition for standalone function/method calls
* Improved stability

Install
===
Basic LSP support for Objeck in VSCode and Sublime.

Visual Studio Code
1. Download and install Objeck >= 6.0.0 (https://github.com/objeck/objeck-lang)
2. Download and install VSC (https://github.com/objeck/objeck-lang-server)
3. Download the objeck-lsp extension and unzip
4. Copy all files in <objeck_install_dir>/doc/syntax/vscode to <user_home>/.vscode/extensions/objeck-syntax
5. Launch vscode
6. Click on the extension button (bottom left hand side); drag and drop objeck-lsp-xxx.vsix to "installed"
7. Goto the objeck-lsp directory and run "obr objeck_lsp.obe 6013 debug" (remove "debug" once working)
8. Open a *.obs file

Sublime
1. Install syntax highlighting (https://github.com/objeck/objeck-lang/tree/master/docs/syntax/sublime)
2. Install the Sublime LSP support
3. Open Preferences > Package Settings > LSP > Settings and add the "objeck" client configuration to the "clients":
{
	"clients": {
		"objeck": {
			"enabled": false,
			"command": [
				"<objeck_path>/bin/obr.exe",
				"<objeck_server_path>/objk_lang_server.obe",
				"6013",
				"debug"
			],
			"env": {
				"OBJECK_LIB_PATH": "<objeck_path>/lib"
			},
			"selector": "source.objeck-obs",
			"tcp_port": 6013
		}
	}
}
4. Open Tools > LSP > Enable Language and select objeck