SET OUTPUT_DIR=C:\Users\objec\.vscode\extensions\objeck-lsp.objeck-lsp-2025.2.2

call deploy_lsp.cmd 
copy /y clients\vscode\client\out\* %OUTPUT_DIR%\client\out
copy /y clients\vscode\server %OUTPUT_DIR%\server