@echo off

SET PORT=6013
SET OBJECK_ROOT=..\..\..\objeck-lang

SET PATH=%PATH%;%OBJECK_ROOT%\core\release\deploy64\bin
SET OBJECK_LIB_PATH=%OBJECK_ROOT%\core\release\deploy64\lib

del /q *.obe

obc -src %OBJECK_ROOT%\core\compiler\lib_src\diags.obs -lib gen_collect -tar lib -dest %OBJECK_ROOT%\core\lib\diags.obl
copy %OBJECK_ROOT%\core\lib\diags.obl %OBJECK_ROOT%\core\release\deploy64\lib\diags.obl

echo ---

obc -src *.obs -lib diags,net,json,regex -dest objeck_lsp.obe

if [%1] NEQ [brun] goto end
echo ---
echo Running on port %PORT%...
obr objeck_lsp.obe %PORT%
:end