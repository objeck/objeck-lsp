del *.obe
obc -src formatter.obs,scanner.obs -lib gen_collect -dest code_formatter.obe
if "%~1" == "" goto end
obr code_formatter.obe %1
:end