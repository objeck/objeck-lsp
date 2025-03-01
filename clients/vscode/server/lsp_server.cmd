set OBJECK_INSTALL_DIR=%~1

set OBJECK_LIB_PATH=%OBJECK_INSTALL_DIR%\lib
set PATH=%PATH%;%OBJECK_INSTALL_DIR%\bin

REM obr %~dp0objeck_lsp.obe %~dp0\objk_apis.json pipe debug
obr %~dp0objeck_lsp.obe %~dp0\objk_apis.json pipe