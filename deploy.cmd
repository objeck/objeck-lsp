rmdir /s /q objeck-lsp
mkdir objeck-lsp

cd clients\vscode
call vsce package
move /y *.vsix ..\..\objeck-lsp
cd ..\..\server\src
call build_server.cmd
move /y objeck_lsp.obe ..\..\objeck-lsp
cd ..\..

REM finished
if [%1] NEQ [deploy] goto end
	set ZIP_BIN="\Program Files\7-Zip"
	%ZIP_BIN%\7z.exe a -r -tzip "objeck-lsp.zip" "README.txt" "objeck-lsp\*"
:end