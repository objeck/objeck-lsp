OBJECK_INSTALL_DIR=$1

export OBJECK_LIB_PATH=$OBJECK_INSTALL_DIR/lib
export PATH=$PATH%;$OBJECK_INSTALL_DIR/bin

# obr %~dp0objeck_lsp.obe %~dp0/objk_apis.json pipe debug
obr ${pwd}/objeck_lsp.obe ${pwd}/objk_apis.json pipe