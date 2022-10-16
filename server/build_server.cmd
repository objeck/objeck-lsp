@echo off
SETLOCAL

SET PORT=6013
SET OBJECK_ROOT=..\..\objeck-lang

SET PATH=%PATH%;%OBJECK_ROOT%\core\release\deploy64\bin
SET OBJECK_LIB_PATH=%OBJECK_ROOT%\core\release\deploy64\lib

del /q *.obe
del /q %TEMP%\objk-*

echo ---

obc -src %OBJECK_ROOT%\core\compiler\lib_src\diags.obs -lib gen_collect -tar lib -dest %OBJECK_ROOT%\core\lib\diags.obl
copy %OBJECK_ROOT%\core\lib\diags.obl %OBJECK_ROOT%\core\release\deploy64\lib\diags.obl

echo ---

obc -src frameworks.obs,proxy.obs,server.obs,format_code/scanner.obs,format_code/formatter.obs -lib diags,net,json,regex -dest objeck_lsp.obe

if [%1] NEQ [brun] goto end
	echo ---
	echo Running on port %PORT%...
	obr objeck_lsp.obe objk_apis.json %PORT% debug
:end