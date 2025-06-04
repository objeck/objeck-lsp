SET OUTPUT_DIR=%HOMEPATH%\.vscode\extensions\objeck-lsp.objeck-lsp-2025.6.2

call deploy_lsp.cmd 
copy /y clients\vscode\client\out\* %OUTPUT_DIR%\client\out
copy /y clients\vscode\server %OUTPUT_DIR%\server