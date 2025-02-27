SET ZIP_BIN="\Program Files\7-Zip"

rmdir /s /q objeck-lsp
mkdir objeck-lsp

del /s /q clients\vscode\server
mkdir clients\vscode\server
copy /y server\objeck_lsp.obe clients\vscode\server
copy /y server\objk_apis.json clients\vscode\server
copy /y server\lsp_server.cmd clients\vscode\server

cd clients\vscode
call vsce package
move /y *.vsix ..\..\objeck-lsp
cd ..\..\server\doc_json
call gen_json.cmd
cd ..

copy objk_apis.json ..\objeck-lsp
call build_server.cmd
copy /y objeck_lsp.obe ..\objeck-lsp
cd ..

copy README.txt objeck-lsp

REM finished
if [%1] NEQ [deploy] goto end
	del /f objeck-lsp-*.zip
	%ZIP_BIN%\7z.exe a -r -tzip "objeck-lsp-2025.2.2.zip" "objeck-lsp\*"
:end