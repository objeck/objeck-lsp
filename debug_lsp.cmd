SET SRC_DIR=C:\Users\objec\Documents\Code\objeck-lsp
SET OUTPUT_DIR=C:\Users\objec\.vscode\extensions\objeck-lsp.objeck-lsp-2025.2.2

call deploy_lsp.cmd 

copy /y %SRC_DIR%\clients\vscode\client\out\* %OUTPUT_DIR%\client\out
copy /y %SRC_DIR%\server\objeck_lsp.obe %OUTPUT_DIR%\server
copy /y %SRC_DIR%\server\objk_apis.json %OUTPUT_DIR%\server
copy /y %SRC_DIR%\server\lsp_server.cmd %OUTPUT_DIR%\server