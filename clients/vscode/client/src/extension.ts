import * as net from 'net';
import * as path from 'path';
import * as child_process from 'child_process';

import { workspace, ExtensionContext } from 'vscode';

import {
    LanguageClient,
    LanguageClientOptions,
    StreamInfo
} from 'vscode-languageclient/node';

let client: LanguageClient;
let serverProcess: child_process.ChildProcess;

export function activate(context: ExtensionContext) {
    // Start the external pipe server
    startExternalServer(context);

    const connectionInfo = {
        path: "\\\\.\\pipe\\objk-pipe"
    };

    const serverOptions = () => {
        return new Promise<StreamInfo>((resolve, reject) => {
            // Wait for the server to be ready
            setTimeout(() => {
                let pipe = net.connect(connectionInfo);
                let result: StreamInfo = {
                    writer: pipe,
                    reader: pipe
                };
                resolve(result);
            }, 1000); // Adjust this delay as needed
        });
    };

    const clientOptions: LanguageClientOptions = {
        documentSelector: [{ scheme: 'file', pattern: "**/*.{obs}" }],
        synchronize: {
            fileEvents: workspace.createFileSystemWatcher('**/*.clientrc')
        }
    };

    client = new LanguageClient('objeck_lsp', 'Objeck Language Server', serverOptions, clientOptions);
    client.start();
}

function startExternalServer(context: ExtensionContext) {
    const serverScript = context.asAbsolutePath(path.join('server', 'lsp_server.cmd'));
    serverProcess = child_process.spawn(serverScript, [], { shell: true });
    
    serverProcess.stdout.on('data', (data) => {
        console.log(`Server stdout: ${data}`);
    });

    serverProcess.stderr.on('data', (data) => {
        console.error(`Server stderr: ${data}`);
    });

    serverProcess.on('close', (code) => {
        console.log(`Server process exited with code ${code}`);
    });
}

export function deactivate(): Thenable<void> | undefined {
    if(serverProcess) {
        serverProcess.kill();
    }

    if(!client) {
        return undefined;
    }
    
    return client.stop();
}