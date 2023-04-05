2023.4.1
---

What's new?
* Support for 'workspace/symbol' search
* Tested with Kate, Textadpt and ecode

[Installation]
===
Support and tested with Sublime, VSCode, Kate and ecode

Sublime
---
1. Download and install the latest version of Objeck (https://github.com/objeck/objeck-lang)
2. Follow the "how-to" to install VSC syntax highlighting (https://github.com/objeck/objeck-lang/blob/master/docs/syntax/howto.html)
3. Configure Sublime LSP support
4. Open Preferences > Package Settings > LSP > Settings and add the "objeck" client configuration to the "clients":
{
	"clients": {
		"objeck": {
			"enabled": false,
			"command": [
				"<objeck_path>/bin/obr.exe",
				"<objeck_server_path>/objeck_lsp.obe",
				"<objeck_server_path>/objk_apis.json",
				"stdio"
			],
			"env": {
				"OBJECK_LIB_PATH": "<objeck_path>/lib",
				"OBJECK_STDIO": "binary"
			},
			"selector": "source.objeck-obs"
		}
	}
}
4. Open Tools > LSP > "Enable Language Server Globally" and select "objeck"

VS Code
--
1. Download and install the latest version of Objeck (https://github.com/objeck/objeck-lang)
2. Follow the "how-to" to install VSC syntax highlighting (https://github.com/objeck/objeck-lang/blob/master/docs/syntax/howto.html)
3. Download the unzip the VSC LSP plugin-in (https://github.com/objeck/objeck-lang-server)
4. In VSC click the Extensions button (or Ctrl+Shift+X) and drag-and-drop "objeck-lsp-xxx.vsix" file
5. Restart VSC

Kate
---
Settings -> Configure Kate... -> LSP Client -> User Sever Settings
Create a new settings file with the content:

{
    "servers": {
        "objeck": {
            "command": [
                "<objeck_path>/obr.exe",
                "<objeck_server_path>/objeck_lsp.obe",
                "<objeck_server_path>/objk_apis.json",
                "stdio"
            ],
            "url": "https://github.com/objeck/objeck-lsp",
            "highlightingModeRegex": "^Objeck$"
        }
    }
}
Note: Kate doesn't support define environment variables like Sublime so the environment variables OBJECK_LIB_PATH and OBJECK_STDIO must be set on Windows.

ecode
---
1. Install the LSP plugin
2. Edit the "%userprofile%\AppData\Roaming\ecode\plugins\lspclient.json" file and add the block under "servers" below

{
  "config": {
    "hover_delay": "1s",
    "semantic_highlighting": false,
    "server_close_after_idle_time": "1m"
  },
  "keybindings": {
    "lsp-go-to-declaration": "",
    "lsp-go-to-definition": "f2",
    "lsp-go-to-implementation": "",
    "lsp-go-to-type-definition": "",
    "lsp-memory-usage": "",
    "lsp-rename-symbol-under-cursor": "ctrl+shift+r",
    "lsp-switch-header-source": "",
    "lsp-symbol-code-action": "alt+return",
    "lsp-symbol-info": "f1",
    "lsp-symbol-references": ""
  },
  "servers": [
    {
      "command": "obr <lsp_server_path>/objeck_lsp.obe <lsp_server_path>//objk_apis.json stdio",
      "file_patterns": [
        "%.obs"
      ],
      "language": "objeck",
      "name": "objeck",
      "url": "https://objeck.org/"
    }
  ]
}

[Workspaces]
===
Workspaces allow the LSP to build and scan all files within a project configuration. This feature supports solutions that span multiple files or require specific libraries to be built and inspected correctly.

1. To set up projects with multiple files, create a "build.json" file in the directory of the files you want to be scanned.
2. The structure of the "build.json" file is as follows:
{
	"files": [
		"file_1.obs",
		"file_2.obs"
	],
	"libs": [
		"gen_collect.obl",
		"regex.obl",
		"net.obl",
		"misc.obl",
		"odbc.obl"
	],
	"flags": ""
}
3. To enable the project file, Close all open files and open the directory that contains the "build.json" file in either VS Code or Sublime