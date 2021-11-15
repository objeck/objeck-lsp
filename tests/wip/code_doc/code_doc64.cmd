set ZIP_BIN="\Program Files\7-Zip"

rmdir /s /q ..\html 
mkdir ..\html
obc -src deploy64\examples\doc\doc_html.obs,deploy64\examples\doc\doc_parser.obs -lib gen_collect.obl -dest deploy64\code_doc.obe
obr deploy64\code_doc.obe deploy64\examples\doc\templates 6.0.6 "C:\Users\objec\Documents\Code\objeck-lang\core\compiler\lib_src\lang.obs"
mkdir deploy64\doc\api
copy deploy64\deploy64\programs\doc\templates\index.html deploy64\doc\api
xcopy /e ..\html\* deploy64\doc\api
rmdir /s /q ..\html
cd deploy64\doc
%ZIP_BIN%\7z.exe a -r -tzip api.zip api\*
move api.zip deploy64\deploy64\docs
cd ..\..
