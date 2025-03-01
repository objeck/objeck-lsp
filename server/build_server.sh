#!/bin/bash

OBJECK_ROOT=../../objeck-lang

# export PATH=$PATH:$OBJECK_ROOT/core/release/deploy/bin
# export OBJECK_LIB_PATH=$OBJECK_ROOT/core/release/deploy/lib

rm *.obe
rm -f /tmp/objk-*

echo ---

obc -src $OBJECK_ROOT/core/compiler/lib_src/diags.obs -lib gen_collect -tar lib -dest $OBJECK_ROOT/core/lib/diags.obl
cp $OBJECK_ROOT/core/lib/diags.obl $OBJECK_ROOT/core/release/deploy/lib/diags.obl

obc -src frameworks.obs,proxy.obs,server.obs,format_code/scanner.obs,format_code/formatter.obs -lib diags,net,json,regex,cipher -dest objeck_lsp.obe

if [ "$1" = "brun" ]; then
	PORT=6013
	echo Running on...
	obr objeck_lsp.obe objk_apis.json pipe debug
#	obr objeck_lsp.obe objk_apis.json $PORT debug
fi;
