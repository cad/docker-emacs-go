(setenv "GOPATH" "/go")


(require 'package)
(setq package-enable-at-startup nil)

;; https://emacs.stackexchange.com/a/2989
(setq package-archives
      '(("elpa"     . "https://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("melpa"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("melpa-stable" . 10)
        ("elpa"     . 5)
        ("melpa"        . 0)))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(unless (package-installed-p 'go-mode)
  (package-refresh-contents)
  (package-install 'go-mode))
(require 'go-mode)

(unless (package-installed-p 'go-guru)
  (package-refresh-contents)
  (package-install 'go-guru))
(require 'go-guru)

(unless (package-installed-p 'lsp-mode)
  (package-refresh-contents)
  (package-install 'lsp-mode))
(require 'lsp-mode)

(unless (package-installed-p 'lsp-ui)
  (package-refresh-contents)
  (package-install 'lsp-ui))
(require 'lsp-ui)

(unless (package-installed-p 'company-lsp)
  (package-refresh-contents)
  (package-install 'company-lsp))
(require 'company-lsp)


(require 'package)
(add-to-list 'package-archives
             '("MELPA Stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)


;(let ((govet (flycheck-checker-get 'go-vet 'command)))
;  (when (equal (cadr govet) "tool")
;    (setf (cdr govet) (cddr govet))))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)
(use-package diminish)

; ;; golang language server
(use-package lsp-mode
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package company-lsp
  :commands company-lsp)

  (with-eval-after-load 'company
    (push 'company-lsp company-backends))
  (with-eval-after-load 'lsp-mode
    (lsp-register-client
     (make-lsp--client :new-connection (lsp-stdio-connection "gopls")
                       :major-modes '(go-mode)
                       :server-id 'gopls))
    (setf lsp-ui-sideline-enable nil))

(add-hook 'go-mode-hook #'lsp)
