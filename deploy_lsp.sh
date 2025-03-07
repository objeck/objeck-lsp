rm -rf objeck-lsp
mkdir objeck-lsp

cd server
./build_server.sh

cd doc_json
./gen_json.sh
cd ../../clients/vscode
vsce package
mv *.vsix ../../objeck-lsp
cd ../..

cp README.txt objeck-lsp

# finished
if [ ! -z "$1" ] && [ "$1" = "deploy" ]; then
	rm -f objeck-lsp-*.zip
	zip -r objeck-lsp-2023.1.0.zip objeck-lsp
fi;
