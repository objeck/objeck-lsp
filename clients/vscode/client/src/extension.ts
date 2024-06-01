import * as net from 'net';

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
		port: 6013,
		host: "localhost"
    };
 
	let serverOptions = () => {
        let socket = net.connect(connectionInfo);
        let result: StreamInfo = {
            writer: socket,
            reader: socket
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