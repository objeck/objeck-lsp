SETLOCAL
set ZIP_BIN="\Program Files\7-Zip"

rmdir /s /q ..\html 
mkdir ..\html
obc -src deploy64\examples\doc\doc_json.obs,deploy64\examples\doc\doc_parser.obs -lib gen_collect,json -dest deploy64\code_doc.obe
obr deploy64\code_doc.obe deploy64\examples\doc\templates 6.0.6 ..\..\..\..\objeck-lang\core\compiler\lib_src\lang.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\regex.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\json.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\xml.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\encrypt.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\odbc.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\fcgi.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\odbc.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\csv.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\query.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\sdl2.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\sdl_game.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\gen_collect.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\net.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\rss.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\misc.obs ..\..\..\..\objeck-lang\core\compiler\lib_src\diags.obs
mkdir deploy64\doc\api
copy deploy64\deploy64\programs\doc\templates\index.html deploy64\doc\api
xcopy /e ..\html\* deploy64\doc\api
rmdir /s /q ..\html
cd deploy64\doc
%ZIP_BIN%\7z.exe a -r -tzip api.zip api\*
move api.zip deploy64\deploy64\docs
cd ..\..
