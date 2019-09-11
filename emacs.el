(setenv "GOPATH" "/go")

(menu-bar-mode -1)
(electric-pair-mode t)
(setq delete-selection-mode 1)
;enable melpa if it isn't enabled
(require 'package)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3") 
(when (not (assoc "melpa" package-archives))
  (setq package-archives (append '(("melpa" . "https://melpa.org/packages/")) package-archives)))
(package-initialize)

;; refresh package list if it is not already available
(when (not package-archive-contents) (package-refresh-contents))

;; install use-package if it isn't already installed
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Install and configure pacakges
;;

(setq dired-dwim-target t)
(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package ido
  :config
  (setq ido-enable-flex-matching t)
  (ido-everywhere t)
  (ido-mode 1))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-init))

;; git client for Emacs
(use-package magit
  :ensure t
  :bind (("C-c g" . magit-status)))

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

;; optional, provides snippets for method signature completion
(use-package yasnippet
  :ensure t)

(use-package lsp-mode
  :ensure t
  ;; uncomment to enable gopls http debug server
  ;; :custom (lsp-gopls-server-args '("-debug" "127.0.0.1:0"))
  :commands (lsp lsp-deferred))

;; optional - provides fancy overlay information
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config (progn
            ;; disable inline documentation
            (setq lsp-ui-sideline-enable nil)
            ;; enable showing docs on hover at the top of the window
            (setq lsp-ui-doc-enable t)
	    ;; enable imenu
	    (setq lsp-ui-imenu-enable t)
	    (setq lsp-ui-flycheck-enable t))
  )

(use-package company
  :ensure t
  :config (progn
            ;; don't add any dely before trying to complete thing being typed
            ;; the call/response to gopls is asynchronous so this should have little
            ;; to no affect on edit latency
            (setq company-idle-delay 0)
            ;; start completing after a single character instead of 3
            (setq company-minimum-prefix-length 1)
            ;; align fields in completions
            (setq company-tooltip-align-annotations t)
            )
  :bind (("C-c ;" . company-complete)
	 (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous)))
	      
  )

;; optional package to get the error squiggles as you edit
(use-package flycheck
  :ensure t)

;; if you use company-mode for completion (otherwise, complete-at-point works out of the box):
(use-package company-lsp
  :ensure t
  :commands company-lsp)

(use-package go-mode
  :ensure t
  :bind (
         ;; If you want to switch existing go-mode bindings to use lsp-mode/gopls instead
         ;; uncomment the following lines
         ;; ("C-c C-j" . lsp-find-definition)
         ;; ("C-c C-d" . lsp-describe-thing-at-point)
         )
  :hook ((go-mode . gopls-config/set-library-path)
         (go-mode . lsp-deferred)
	 (go-mode . flycheck-mode)
	 (go-mode . display-line-numbers-mode)
         (before-save . lsp-organize-imports)))

(defun gopls-config/set-library-path ()
  "Set lsp library directory for go modules"
  (setq lsp-clients-go-library-directories
        (list
         ;; /usr is the default value
         ;"/workspace/Workspace"
         ;; add $GOPATH/pkg/mod to the "library path"
         ;; this causes lsp-mode to try each of the active lsp sessions instead
         ;; of prompting for which project to use
         ;; see (lsp--try-open-in-library-workspace)
         (concat (string-trim-right (shell-command-to-string "go env GOPATH")) "/pkg/mod"))))

(provide 'gopls-config)

(use-package protobuf-mode
  :ensure t)

(global-prettify-symbols-mode +1)
(delete-selection-mode t)
