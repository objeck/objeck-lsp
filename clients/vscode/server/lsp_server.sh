OBJECK_INSTALL_DIR=$1

export OBJECK_LIB_PATH=$OBJECK_INSTALL_DIR/lib
export PATH=$PATH:$OBJECK_INSTALL_DIR/bin

current_dir=$(pwd)
echo "The current directory is: $current_dir"

obr $2/objeck_lsp.obe $2/objk_apis.json pipe debug
# obr ${pwd}/objeck_lsp.obe ${pwd}/objk_apis.json pipe