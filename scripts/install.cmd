@echo off
SETLOCAL EnableDelayedExpansion

REM ============================================================
REM  Objeck LSP - Install Script (Windows)
REM
REM  Usage: install.cmd <objeck_install_dir> <editor>
REM    editor: vscode | sublime | neovim | emacs | all
REM
REM  Run from the extracted release directory (objeck-lsp-VERSION/)
REM ============================================================

if "%~1"=="" goto usage
if "%~2"=="" goto usage

SET OBJECK_DIR=%~1
SET EDITOR=%~2
SET SCRIPT_DIR=%~dp0
SET RELEASE_DIR=%SCRIPT_DIR%..
SET LSP_HOME=%USERPROFILE%\.objeck-lsp

REM validate Objeck install
if not exist "%OBJECK_DIR%\bin\obr.exe" (
    echo ERROR: Cannot find obr.exe in %OBJECK_DIR%\bin\
    echo Make sure the Objeck install directory is correct.
    exit /b 1
)

REM validate release directory
if not exist "%RELEASE_DIR%\server\objeck_lsp.obe" (
    echo ERROR: Cannot find server\objeck_lsp.obe in release directory.
    echo Run this script from the extracted release directory.
    exit /b 1
)

echo.
echo ========================================
echo  Objeck LSP - Install
echo ========================================
echo.
echo  Objeck:     %OBJECK_DIR%
echo  LSP home:   %LSP_HOME%
echo  Editor:     %EDITOR%
echo.

REM --- create self-contained deployment ---
echo [1] Creating self-contained deployment at %LSP_HOME%...
mkdir "%LSP_HOME%" 2>nul
mkdir "%LSP_HOME%\bin" 2>nul
mkdir "%LSP_HOME%\lib" 2>nul
copy /y "%OBJECK_DIR%\bin\obr.exe" "%LSP_HOME%\bin\" >nul
if exist "%OBJECK_DIR%\bin\obd.exe" copy /y "%OBJECK_DIR%\bin\obd.exe" "%LSP_HOME%\bin\" >nul
xcopy /y /q /s "%OBJECK_DIR%\lib\*" "%LSP_HOME%\lib\" >nul
copy /y "%RELEASE_DIR%\server\objeck_lsp.obe" "%LSP_HOME%\" >nul
copy /y "%RELEASE_DIR%\server\objk_apis.json" "%LSP_HOME%\" >nul
copy /y "%RELEASE_DIR%\server\lsp_server.cmd" "%LSP_HOME%\" >nul
copy /y "%RELEASE_DIR%\server\lsp_server.sh" "%LSP_HOME%\" >nul
echo    Done: %LSP_HOME%

REM --- editor dispatch ---
if /i "%EDITOR%"=="vscode" goto install_vscode
if /i "%EDITOR%"=="sublime" goto install_sublime
if /i "%EDITOR%"=="neovim" goto install_neovim
if /i "%EDITOR%"=="emacs" goto install_emacs
if /i "%EDITOR%"=="all" goto install_all
echo ERROR: Unknown editor "%EDITOR%"
goto usage

REM ============================================================
:install_vscode
REM ============================================================
echo.
echo [VS Code] Installing extension...

SET VSIX_FILE=
for %%F in ("%RELEASE_DIR%\clients\vscode\*.vsix") do SET VSIX_FILE=%%F

if not defined VSIX_FILE (
    echo    WARNING: No .vsix file found in clients\vscode\
    goto done
)

where code >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo    WARNING: 'code' command not found. Install the extension manually:
    echo    Open VS Code, Extensions panel, drag-and-drop !VSIX_FILE!
    goto done
)

code --install-extension "!VSIX_FILE!" --force
echo    Extension installed.

REM Copy rebuilt server to the installed extension to avoid version mismatch
for /d %%D in ("%USERPROFILE%\.vscode\extensions\objeck-lsp.objeck-lsp-*") do (
    if exist "%%D\server" (
        copy /y "%LSP_HOME%\objeck_lsp.obe" "%%D\server\objeck_lsp.obe" >nul 2>nul
        copy /y "%LSP_HOME%\objk_apis.json" "%%D\server\objk_apis.json" >nul 2>nul
    )
)
echo    Server synchronized.

REM Auto-configure VS Code settings
SET VSCODE_SETTINGS=%APPDATA%\Code\User\settings.json
SET ESC_DIR=%LSP_HOME:\=\\%
if exist "%VSCODE_SETTINGS%" (
    REM Check if already configured
    findstr /C:"objk.win.install.dir" "%VSCODE_SETTINGS%" >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        echo    NOTE: Add to VS Code settings (%VSCODE_SETTINGS%):
        echo      "objk.win.install.dir": "%ESC_DIR%"
    ) else (
        echo    VS Code settings already configured.
    )
) else (
    echo { > "%VSCODE_SETTINGS%"
    echo   "objk.win.install.dir": "%ESC_DIR%" >> "%VSCODE_SETTINGS%"
    echo } >> "%VSCODE_SETTINGS%"
    echo    VS Code settings created.
)
goto done

REM ============================================================
:install_sublime
REM ============================================================
echo.
echo [Sublime Text] Installing...

SET SUBLIME_PKG=%APPDATA%\Sublime Text\Packages
SET SUBLIME_OBJECK=!SUBLIME_PKG!\Objeck

REM install syntax highlighting
if not exist "!SUBLIME_OBJECK!" mkdir "!SUBLIME_OBJECK!"
if exist "%RELEASE_DIR%\clients\sublime\objeck.sublime-syntax" (
    copy /y "%RELEASE_DIR%\clients\sublime\objeck.sublime-syntax" "!SUBLIME_OBJECK!\" >nul
    echo    Syntax file installed.
)

REM write LSP settings
SET LSP_SETTINGS=!SUBLIME_PKG!\User\LSP.sublime-settings
SET LSP_PATH=%LSP_HOME:\=/%
echo    Writing LSP settings...
(
    echo {
    echo 	"clients": {
    echo 		"objeck": {
    echo 			"enabled": true,
    echo 			"command": [
    echo 				"!LSP_PATH!/bin/obr.exe",
    echo 				"!LSP_PATH!/objeck_lsp.obe",
    echo 				"!LSP_PATH!/objk_apis.json",
    echo 				"stdio"
    echo 			],
    echo 			"env": {
    echo 				"OBJECK_LIB_PATH": "!LSP_PATH!/lib",
    echo 				"OBJECK_STDIO": "binary"
    echo 			},
    echo 			"selector": "source.objeck-obs"
    echo 		}
    echo 	}
    echo }
) > "!LSP_SETTINGS!"
echo    LSP settings written to !LSP_SETTINGS!
echo.
echo    Next: Open Sublime, go to Tools ^> LSP ^> Enable Language Server Globally ^> select "objeck"
goto done

REM ============================================================
:install_neovim
REM ============================================================
echo.
echo [Neovim] Installing...

REM Neovim on Windows uses %LOCALAPPDATA%\nvim\
SET NVIM_DIR=%LOCALAPPDATA%\nvim
SET NVIM_LSP=%NVIM_DIR%\lsp
SET NVIM_SYNTAX=%NVIM_DIR%\syntax
if not exist "%NVIM_LSP%" mkdir "%NVIM_LSP%" 2>nul
if not exist "%NVIM_SYNTAX%" mkdir "%NVIM_SYNTAX%" 2>nul

SET LSP_PATH=%LSP_HOME:\=/%
if exist "%RELEASE_DIR%\clients\neovim\objeck.lua" (
    powershell -NoProfile -Command "(Get-Content '%RELEASE_DIR%\clients\neovim\objeck.lua') -replace '<objeck_server_path>', '%LSP_PATH%' | Set-Content '%NVIM_LSP%\objeck.lua'"
    echo    Installed: %NVIM_LSP%\objeck.lua
) else (
    echo    WARNING: clients\neovim\objeck.lua not found in release.
)
if exist "%RELEASE_DIR%\clients\neovim\objeck.vim" (
    copy /y "%RELEASE_DIR%\clients\neovim\objeck.vim" "%NVIM_SYNTAX%\" >nul
    echo    Installed: %NVIM_SYNTAX%\objeck.vim
)

echo.
echo    Add to your init.lua:
echo      vim.filetype.add({ extension = { obs = 'objeck' } })
echo      vim.lsp.enable('objeck')
goto done

REM ============================================================
:install_emacs
REM ============================================================
echo.
echo [Emacs] Installing...

REM Emacs on Windows uses %APPDATA%/.emacs.d/ as user-emacs-directory
SET EMACS_DIR=%APPDATA%\.emacs.d
SET EMACS_LISP=%EMACS_DIR%\lisp
if not exist "%EMACS_LISP%" mkdir "%EMACS_LISP%" 2>nul

SET LSP_PATH=%LSP_HOME:\=/%
if exist "%RELEASE_DIR%\clients\emacs\objeck-mode.el" (
    powershell -NoProfile -Command "(Get-Content '%RELEASE_DIR%\clients\emacs\objeck-mode.el') -replace '<objeck_server_path>', '%LSP_PATH%' | Set-Content '%EMACS_LISP%\objeck-mode.el'"
    echo    Installed: %EMACS_LISP%\objeck-mode.el
) else (
    echo    WARNING: clients\emacs\objeck-mode.el not found in release.
)

REM create init.el if it doesn't exist
SET EMACS_INIT=%EMACS_DIR%\init.el
if not exist "%EMACS_INIT%" (
    echo (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory^)^)> "%EMACS_INIT%"
    echo (require 'objeck-mode^)>> "%EMACS_INIT%"
    echo    Created: %EMACS_INIT%
) else (
    echo    NOTE: %EMACS_INIT% already exists.
    echo    Ensure it contains:
    echo      (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory^)^)
    echo      (require 'objeck-mode^)
)
goto done

REM ============================================================
:install_all
REM ============================================================

REM VS Code
echo.
echo [VS Code] Installing extension...
SET VSIX_FILE=
for %%F in ("%RELEASE_DIR%\clients\vscode\*.vsix") do SET VSIX_FILE=%%F
if defined VSIX_FILE (
    where code >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        echo    WARNING: 'code' command not found. Install the extension manually.
    ) else (
        code --install-extension "!VSIX_FILE!" --force
        echo    Extension installed.
    )
) else (
    echo    WARNING: No .vsix file found in clients\vscode\
)

REM Sublime
echo.
echo [Sublime Text] Installing...
SET SUBLIME_PKG=%APPDATA%\Sublime Text\Packages
SET SUBLIME_OBJECK=!SUBLIME_PKG!\Objeck
if not exist "!SUBLIME_OBJECK!" mkdir "!SUBLIME_OBJECK!"
if exist "%RELEASE_DIR%\clients\sublime\objeck.sublime-syntax" (
    copy /y "%RELEASE_DIR%\clients\sublime\objeck.sublime-syntax" "!SUBLIME_OBJECK!\" >nul
    echo    Syntax file installed.
)
SET LSP_SETTINGS=!SUBLIME_PKG!\User\LSP.sublime-settings
SET LSP_PATH=%LSP_HOME:\=/%
echo    Writing LSP settings...
(
    echo {
    echo 	"clients": {
    echo 		"objeck": {
    echo 			"enabled": true,
    echo 			"command": [
    echo 				"!LSP_PATH!/bin/obr.exe",
    echo 				"!LSP_PATH!/objeck_lsp.obe",
    echo 				"!LSP_PATH!/objk_apis.json",
    echo 				"stdio"
    echo 			],
    echo 			"env": {
    echo 				"OBJECK_LIB_PATH": "!LSP_PATH!/lib",
    echo 				"OBJECK_STDIO": "binary"
    echo 			},
    echo 			"selector": "source.objeck-obs"
    echo 		}
    echo 	}
    echo }
) > "!LSP_SETTINGS!"
echo    LSP settings written.

REM Neovim (uses %LOCALAPPDATA%\nvim\ on Windows)
echo.
echo [Neovim] Installing...
SET NVIM_LSP=%LOCALAPPDATA%\nvim\lsp
SET NVIM_SYNTAX=%LOCALAPPDATA%\nvim\syntax
if not exist "%NVIM_LSP%" mkdir "%NVIM_LSP%" 2>nul
if not exist "%NVIM_SYNTAX%" mkdir "%NVIM_SYNTAX%" 2>nul
SET LSP_PATH=%LSP_HOME:\=/%
if exist "%RELEASE_DIR%\clients\neovim\objeck.lua" (
    powershell -NoProfile -Command "(Get-Content '%RELEASE_DIR%\clients\neovim\objeck.lua') -replace '<objeck_server_path>', '%LSP_PATH%' | Set-Content '%NVIM_LSP%\objeck.lua'"
    echo    Installed: %NVIM_LSP%\objeck.lua
)
if exist "%RELEASE_DIR%\clients\neovim\objeck.vim" (
    copy /y "%RELEASE_DIR%\clients\neovim\objeck.vim" "%NVIM_SYNTAX%\" >nul
)

REM Emacs (uses %APPDATA%/.emacs.d/ on Windows)
echo.
echo [Emacs] Installing...
SET EMACS_DIR=%APPDATA%\.emacs.d
SET EMACS_LISP=%EMACS_DIR%\lisp
if not exist "%EMACS_LISP%" mkdir "%EMACS_LISP%" 2>nul
SET LSP_PATH=%LSP_HOME:\=/%
if exist "%RELEASE_DIR%\clients\emacs\objeck-mode.el" (
    powershell -NoProfile -Command "(Get-Content '%RELEASE_DIR%\clients\emacs\objeck-mode.el') -replace '<objeck_server_path>', '%LSP_PATH%' | Set-Content '%EMACS_LISP%\objeck-mode.el'"
    echo    Installed: %EMACS_LISP%\objeck-mode.el
)
SET EMACS_INIT=%EMACS_DIR%\init.el
if not exist "%EMACS_INIT%" (
    echo (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory^)^)> "%EMACS_INIT%"
    echo (require 'objeck-mode^)>> "%EMACS_INIT%"
)

echo.
echo    NOTE: Set VS Code setting "objk.win.install.dir" to your Objeck path.
echo    NOTE: In Sublime, enable the "objeck" language server globally.
echo    NOTE: Add vim.lsp.enable('objeck') to your Neovim init.lua.
echo    NOTE: Add (require 'objeck-mode) to your Emacs init.el.
goto done

REM ============================================================
:done
REM ============================================================
echo.
echo ========================================
echo  Install complete
echo ========================================
echo.
goto end

:usage
echo.
echo  Usage: install.cmd ^<objeck_install_dir^> ^<editor^>
echo.
echo  Arguments:
echo    objeck_install_dir  Path to Objeck installation
echo    editor              One of: vscode, sublime, neovim, emacs, all
echo.
echo  Examples:
echo    User install:    install.cmd C:\Users\you\objeck vscode
echo    System install:  install.cmd "C:\Program Files\Objeck" all
echo.
exit /b 1

:end
