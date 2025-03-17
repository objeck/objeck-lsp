@echo off
SETLOCAL

SET PORT=%1
SET OBJECK_ROOT=..\..\objeck-lang

SET PATH=%PATH%;%OBJECK_ROOT%\core\release\deploy-x64\bin
SET OBJECK_LIB_PATH=%OBJECK_ROOT%\core\release\deploy-x64\lib

del /q *.obe
del /q %TEMP%\objk-*

echo ---

obc -src %OBJECK_ROOT%\core\compiler\lib_src\diags.obs -lib gen_collect,net,cipher -tar lib -dest %OBJECK_ROOT%\core\lib\diags.obl
copy %OBJECK_ROOT%\core\lib\diags.obl %OBJECK_ROOT%\core\release\deploy-x64\lib\diags.obl

echo ---

obc -src frameworks.obs,proxy.obs,server.obs,format_code/scanner.obs,format_code/formatter.obs -lib diags,net,json,regex,cipher -dest objeck_lsp.obe
copy /y objeck_lsp.obe ..\clients\vscode\server

if "%PORT%" == "" goto end
	echo ---
	echo Running on: %PORT%...
	obr objeck_lsp.obe objk_apis.json pipe debug
REM	obr objeck_lsp.obe objk_apis.json %PORT% debug
REM	obr objeck_lsp.obe objk_apis.json stdio debug
	goto end
:end
