# Objeck LSP

Sublime TCP client shim.

## Installation
* Install syntax [highlighting](https://github.com/objeck/objeck-lang/tree/master/docs/syntax/sublime)
* Install the Sublime [LSP support](https://lsp.sublimetext.io/language_servers/)
* Open Preferences > Package Settings > LSP > Settings and add the "objeck" client configuration to the "clients":
````
"clients": {
		"objeck": {
			"enabled": false,
			"command": [
				"d:/code/objeck-lang/core/release/deploy64/bin/obr.exe",
				"d:/code/objeck-lang-server/server/src/objk_lang_server.obe",
				"6013",
				"debug"
			],
			"env": {
				"OBJECK_LIB_PATH": "d:/code/objeck-lang/core/release/deploy64/lib"
			},
			"selector": "source.objeck-obs",
			"tcp_port": 6013
		}
	}

```

## Running client

* Open Tools > LSP > Enable Language and select objeck