@echo off
del *.obe
obc -src formatter.obs,scanner.obs -lib gen_collect -dest code_formatter
if "%~1" == "" goto end
obr code_formatter %1
:end