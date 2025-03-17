# Objeck LSP

Sublime TCP client shim.

## Installation
* Install syntax [highlighting](https://github.com/objeck/objeck-lang/tree/master/docs/syntax/sublime)
* Install the Sublime [LSP support](https://lsp.sublimetext.io/language_servers/)
* Open Preferences > Package Settings > LSP > Settings and add the "objeck" client configuration to the "clients":

Standard I/O
```
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
```

TCP sockets
```
{
	"clients": {
		"objeck": {
			"enabled": false,
			"command": [
				"<objeck_path>/bin/obr.exe",
				"<objeck_server_path>/objeck_lsp.obe",
				"<objeck_server_path>/objk_apis.json",
				"6013"
			],
			"env": {
				"OBJECK_LIB_PATH": "<objeck_path>/lib"
			},
			"selector": "source.objeck-obs",
			"tcp_port": 6013
		}
	}
}
```

## Running client

* Open Tools > LSP > Enable Language and select objeck