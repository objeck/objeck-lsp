;;; objeck-mode.el --- Major mode for Objeck with Eglot LSP support -*- lexical-binding: t; -*-

;; Author: Objeck Contributors
;; URL: https://github.com/objeck/objeck-lsp
;; Version: 2026.2.0
;; Package-Requires: ((emacs "29.1"))

;;; Commentary:
;;
;; Major mode for editing Objeck source files (.obs) with LSP support
;; via Eglot (built into Emacs 29+).
;;
;; Installation:
;;   1. Copy this file to your Emacs load-path (e.g. ~/.emacs.d/lisp/)
;;   2. Add to your init.el:
;;        (add-to-list 'load-path "~/.emacs.d/lisp")
;;        (require 'objeck-mode)
;;
;; Prerequisites:
;;   - Objeck installed with OBJECK_LIB_PATH set
;;   - OBJECK_STDIO=binary environment variable set
;;   - obr and objeck_lsp.obe available on PATH or configured below
;;
;; To start the LSP server, open a .obs file and run: M-x eglot

;;; Code:

(require 'eglot)

;;;###autoload
(define-derived-mode objeck-mode prog-mode "Objeck"
  "Major mode for editing Objeck source files."
  (setq-local comment-start "# ")
  (setq-local comment-end "")
  (setq-local comment-start-skip "#+ *")
  (setq-local block-comment-start "#~")
  (setq-local block-comment-end "~#"))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.obs\\'" . objeck-mode))

;; Eglot LSP integration
;; Update the paths below to match your Objeck installation
(add-to-list 'eglot-server-programs
             '(objeck-mode . ("obr"
                              "<objeck_server_path>/objeck_lsp.obe"
                              "<objeck_server_path>/objk_apis.json"
                              "stdio")))

(provide 'objeck-mode)
;;; objeck-mode.el ends here
