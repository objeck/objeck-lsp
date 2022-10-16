
rm -rf objeck-lsp
mkdir objeck-lsp

cd clients/vscode
vsce package
mv *.vsix ../../objeck-lsp
cd ../../server/doc_json
./gen_json.sh
cd ..

cp objk_apis.json ../objeck-lsp
./build_server.sh
cp objeck_lsp.obe ../objeck-lsp
cd ..

cp README.txt objeck-lsp

# finished
if [ ! -z "$1" ] && [ "$1" = "deploy" ]; then
	del /f objeck-lsp-*.zip
	zip a -r -tzip "objeck-lsp-6.8.3.zip" "objeck-lsp/*"
fi;