@echo off

SET PATH=%PATH%;..\..\..\objeck-lang\core\release\deploy64\bin
SET OBJECK_LIB_PATH=..\..\..\objeck-lang\core\release\deploy64\lib
obc -src *.obs -lib diags,net,json,regex -dest objk_lang_server.obe