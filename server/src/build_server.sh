export PATH=$PATH:/home/objeck/Documents/Code/objeck-lang/core/release/deploy/bin
export OBJECK_LIB_PATH=/home/objeck/Documents/Code/objeck-lang/core/release/deploy/lib

obc -src frameworks.obs,parser.obs,server.obs -lib diags,net,json,regex -dest objk_lang_server.obe
obr objk_lang_server.obe 6013
