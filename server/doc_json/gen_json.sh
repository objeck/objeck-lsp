OBJECK_ROOT=../../../objeck-lang

export PATH=$PATH:$OBJECK_ROOT/core/release/deploy/bin
export OBJECK_LIB_PATH=$OBJECK_ROOT/core/release/deploy/lib

rm *.obe
clear 
obc -src doc_json.obs,doc_parser.obs -lib gen_collect,xml,json,cipher -dest doc_json.obe
obr doc_json.obe templates "2025.6.2" ../../../objeck-lang/core/compiler/lib_src/lang.obs ../../../objeck-lang/core/compiler/lib_src/regex.obs ../../../objeck-lang/core/compiler/lib_src/json_stream.obs ../../../objeck-lang/core/compiler/lib_src/json.obs ../../../objeck-lang/core/compiler/lib_src/xml.obs ../../../objeck-lang/core/compiler/lib_src/cipher.obs ../../../objeck-lang/core/compiler/lib_src/odbc.obs ../../../objeck-lang/core/compiler/lib_src/odbc.obs ../../../objeck-lang/core/compiler/lib_src/csv.obs ../../../objeck-lang/core/compiler/lib_src/query.obs ../../../objeck-lang/core/compiler/lib_src/sdl2.obs ../../../objeck-lang/core/compiler/lib_src/sdl_game.obs ../../../objeck-lang/core/compiler/lib_src/gen_collect.obs ../../../objeck-lang/core/compiler/lib_src/net_common.obs ../../../objeck-lang/core/compiler/lib_src/net.obs ../../../objeck-lang/core/compiler/lib_src/net_secure.obs ../../../objeck-lang/core/compiler/lib_src/rss.obs ../../../objeck-lang/core/compiler/lib_src/misc.obs ../../../objeck-lang/core/compiler/lib_src/diags.obs ../../../objeck-lang/core/compiler/lib_src/ml.obs ../../../objeck-lang/core/compiler/lib_src/openai.obs ../../../objeck-lang/core/compiler/lib_src/gemini.obs ../../../objeck-lang/core/compiler/lib_src/ollama.obs ../../../objeck-lang/core/compiler/lib_src/json_rpc.obs
mv out.json ../objk_apis.json
