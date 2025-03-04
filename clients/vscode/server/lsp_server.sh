export OBJECK_INSTALL_DIR=$1

export OBJECK_LIB_PATH=$OBJECK_INSTALL_DIR/lib
export PATH=$PATH:$OBJECK_INSTALL_DIR/bin

# echo $OBJECK_LIB_PATH
# echo $PATH

# obr $2/objeck_lsp.obe $2/objk_apis.json pipe debug
obr $2/objeck_lsp.obe $2/objk_apis.json pipe
