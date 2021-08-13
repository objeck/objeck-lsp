@echo off

SET OBJECK_ROOT=..\..\..\objeck-lang

SET PATH=%PATH%;%OBJECK_ROOT%\core\release\deploy64\bin
SET OBJECK_LIB_PATH=%OBJECK_ROOT%\core\release\deploy64\lib

obc -src %OBJECK_ROOT%\core\compiler\lib_src\diags.obs -lib gen_collect -tar lib -opt s3 -dest %OBJECK_ROOT%\core\lib\diags.obl
echo ---
obc -src *.obs -lib diags,net,json,regex -dest objk_lang_server.obe