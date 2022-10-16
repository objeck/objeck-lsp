SETLOCAL

del *.obe
cls 
obc -src doc_json.obs,doc_parser.obs -lib gen_collect,json -dest doc_json.obe
obr doc_json.obe templates "0.0.0" ..\..\..\objeck-lang\core\compiler\lib_src\lang.obs ..\..\..\objeck-lang\core\compiler\lib_src\regex.obs ..\..\..\objeck-lang\core\compiler\lib_src\json.obs ..\..\..\objeck-lang\core\compiler\lib_src\xml.obs ..\..\..\objeck-lang\core\compiler\lib_src\encrypt.obs ..\..\..\objeck-lang\core\compiler\lib_src\odbc.obs ..\..\..\objeck-lang\core\compiler\lib_src\fcgi.obs ..\..\..\objeck-lang\core\compiler\lib_src\odbc.obs ..\..\..\objeck-lang\core\compiler\lib_src\csv.obs ..\..\..\objeck-lang\core\compiler\lib_src\query.obs ..\..\..\objeck-lang\core\compiler\lib_src\sdl2.obs ..\..\..\objeck-lang\core\compiler\lib_src\sdl_game.obs ..\..\..\objeck-lang\core\compiler\lib_src\gen_collect.obs ..\..\..\objeck-lang\core\compiler\lib_src\net.obs ..\..\..\objeck-lang\core\compiler\lib_src\rss.obs ..\..\..\objeck-lang\core\compiler\lib_src\misc.obs ..\..\..\objeck-lang\core\compiler\lib_src\diags.obs
move out.json ..\objk_apis.json