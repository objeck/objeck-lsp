SET ZIP_BIN="\Program Files\7-Zip"

rmdir /s /q objeck-lsp
mkdir objeck-lsp

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
	%ZIP_BIN%\7z.exe a -r -tzip "objeck-lsp-1.1.19.zip" "objeck-lsp\*"
:end