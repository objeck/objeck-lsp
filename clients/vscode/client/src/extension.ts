import * as net from 'net';
import * as path from 'path';

import { workspace, ExtensionContext } from 'vscode';

import {
	LanguageClient,
	LanguageClientOptions,
	StreamInfo
} 
from 'vscode-languageclient/node';

let client: LanguageClient;

export function activate(context: ExtensionContext) {
	let connectionInfo = {
		path: "\\\\.\\pipe\\objk-pipe"
    };
 
	let serverOptions = () => {
	    let pipe = net.connect(connectionInfo);
        let result: StreamInfo = {
            writer: pipe,
            reader: pipe
        };
		
        return Promise.resolve(result);
    };

	let clientOptions: LanguageClientOptions = {
		documentSelector: [{ scheme: 'file', pattern: "**/*.{obs}"}],
		synchronize: {
            fileEvents: workspace.createFileSystemWatcher('**/*.clientrc')
        }
	};

	client = new LanguageClient('objeck_lsp', 'Objeck Language Server', serverOptions, clientOptions);
	client.start();
}

export function deactivate(): Thenable<void> | undefined {
	if(!client) {
		return undefined;
	}

	return client.stop();
}