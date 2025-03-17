SET ZIP_BIN="\Program Files\7-Zip"

rmdir /s /q objeck-lsp
mkdir objeck-lsp

rmdir /s /q objeck-lsp-debug
mkdir objeck-lsp-debug

cd clients\vscode
call vsce package
copy /y *.vsix ..\..\objeck-lsp
move /y *.vsix ..\..\objeck-lsp-debug
cd ..\..\server\doc_json
call gen_json.cmd
cd ..

copy objk_apis.json ..\objeck-lsp-debug
call build_server.cmd
copy /y objeck_lsp.obe ..\objeck-lsp-debug
cd ..

copy README.txt objeck-lsp

REM finished
if [%1] NEQ [deploy] goto end
	del /f objeck-lsp-*.zip
	%ZIP_BIN%\7z.exe a -r -tzip "objeck-lsp-2025.3.0.zip" "objeck-lsp\*"
:end