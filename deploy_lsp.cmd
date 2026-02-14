@echo off
SETLOCAL EnableDelayedExpansion

REM ensure we're in the repo root
cd /d %~dp0

REM read version from package.json
for /f "tokens=2 delims=:, " %%A in ('findstr /C:"\"version\"" clients\vscode\package.json') do (
	SET VERSION=%%~A
)

SET ZIP_BIN="\Program Files\7-Zip"

echo.
echo ========================================
echo  Objeck LSP v%VERSION% - Release Build
echo ========================================
echo.

REM --- clean ---
echo [1/6] Cleaning...
rmdir /s /q objeck-lsp 2>nul
rmdir /s /q objeck-lsp-debug 2>nul
mkdir objeck-lsp
mkdir objeck-lsp-debug

REM --- generate API docs ---
echo [2/6] Generating API documentation...
cd server\doc_json
call gen_json.cmd %VERSION%
if %ERRORLEVEL% NEQ 0 (
	echo.
	echo ERROR: API doc generation failed
	cd ..\..
	goto fail
)
cd ..

REM --- build server ---
echo [3/6] Building LSP server...
call build_server.cmd
if %ERRORLEVEL% NEQ 0 (
	echo.
	echo ERROR: Server build failed
	cd ..
	goto fail
)
copy /y objk_apis.json ..\objeck-lsp-debug >nul
copy /y objeck_lsp.obe ..\objeck-lsp-debug >nul
cd ..

REM --- package VS Code extension ---
echo [4/6] Packaging VS Code extension...
cd clients\vscode
call vsce package
if %ERRORLEVEL% NEQ 0 (
	echo.
	echo ERROR: vsce package failed
	cd ..\..
	goto fail
)
copy /y *.vsix ..\..\objeck-lsp >nul
move /y *.vsix ..\..\objeck-lsp-debug >nul
cd ..\..

REM --- assemble release ---
echo [5/6] Assembling release package...
copy /y README.txt objeck-lsp >nul
copy /y docs\install_guide.html objeck-lsp >nul

for %%D in (neovim emacs helix sublime) do (
	mkdir objeck-lsp\clients\%%D 2>nul
)
copy /y clients\neovim\objeck.lua objeck-lsp\clients\neovim >nul
copy /y clients\emacs\objeck-mode.el objeck-lsp\clients\emacs >nul
copy /y clients\helix\languages.toml objeck-lsp\clients\helix >nul
copy /y clients\sublime\LSP.sublime-settings objeck-lsp\clients\sublime >nul

REM --- zip ---
echo [6/6] Creating release archive...
if [%1] NEQ [deploy] (
	echo Skipping zip ^(pass 'deploy' to create archive^)
	goto done
)
del /f objeck-lsp-*.zip 2>nul
%ZIP_BIN%\7z.exe a -r -tzip "objeck-lsp-%VERSION%.zip" "objeck-lsp\*" >nul
if %ERRORLEVEL% NEQ 0 (
	echo.
	echo ERROR: 7-Zip failed
	goto fail
)

:done
echo.
echo ========================================
echo  Build successful
echo ========================================
echo.
echo  Version:      %VERSION%
echo  Release dir:  objeck-lsp\
echo  Debug dir:    objeck-lsp-debug\
if [%1] == [deploy] echo  Archive:      objeck-lsp-%VERSION%.zip
echo.
goto end

:fail
echo.
echo ========================================
echo  BUILD FAILED
echo ========================================
echo.
exit /b 1

:end
