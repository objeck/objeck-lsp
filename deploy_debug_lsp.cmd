@echo off
SETLOCAL

cd /d %~dp0

REM read version from package.json
for /f "tokens=2 delims=:, " %%A in ('findstr /C:"\"version\"" clients\vscode\package.json') do (
	SET VERSION=%%~A
)

SET OUTPUT_DIR=%HOMEPATH%\.vscode\extensions\objeck-lsp.objeck-lsp-%VERSION%

call deploy_lsp.cmd
copy /y clients\vscode\client\out\* %OUTPUT_DIR%\client\out
xcopy /y /s clients\vscode\server %OUTPUT_DIR%\server\

echo.
echo Deployed to: %OUTPUT_DIR%
