export OBJECK_INSTALL_DIR=$1

export OBJECK_LIB_PATH=$OBJECK_INSTALL_DIR/lib
export PATH=$PATH:$OBJECK_INSTALL_DIR/bin

$OBJECK_INSTALL_DIR/bin/obr $2/server/objeck_lsp.obe $2/server/objk_apis.json pipe
