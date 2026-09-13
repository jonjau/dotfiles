;;; dev.el --- development extras -*- no-byte-compile: t; lexical-binding: t; -*-


(use-package emacs
  :config
  ;; Code folding config
  ;(setopt hs-show-indicators t)         ; Show collapse indicators in margin
  ;(setopt hs-display-lines-hidden t)    ; Show number of collapsed lines

  ;; Treesitter config

  ;; Enable tree-sitter in all available modes
  (setopt treesit-enabled-modes t)

  ;; TODO 3Q: when emacs 31 is available, below code is not needed,
  ;; just do (setopt treesit-enabled-modes t)
  (use-package treesit-auto
    :ensure t
    :custom
    (treesit-auto-install 'prompt)
    :config
    (treesit-auto-add-to-auto-mode-alist 'all)
    (global-treesit-auto-mode))

  ;; Amount to highlight: integer between 1-4; 4 is max highlighting
  (setopt treesit-font-lock-level 3)

  ;; What to do if language grammar not installed: default is `ask';
  ;; other options are `always', and `ask-dir'.
  (setopt treesit-auto-install-grammar 'ask)

  :hook
  ;; Auto parenthesis matching
  ((prog-mode . electric-pair-mode)))

(use-package project
  :custom
  (when (>= emacs-major-version 30)
    (project-mode-line t)))         ; show project name in modeline

;; Magit
(use-package magit
  :bind (("C-x g" . magit-status)))

;; Common file types
(use-package markdown-mode
  :hook ((markdown-mode . visual-line-mode)))

(use-package yaml-mode)

(use-package json-mode)

;; Emacs ships with a lot of popular programming language modes. If it's not
;; built in, you're almost certain to find a mode for the language you're
;; looking for with a quick Internet search.

;; Eglot
(use-package eglot
  ;; no :ensure t here because it's built-in

  ;; Configure hooks to automatically turn-on eglot for selected modes
  ; :hook
  ; (((python-mode ruby-mode elixir-mode) . eglot-ensure))

  :custom
  (eglot-send-changes-idle-time 0.1)
  (eglot-extend-to-xref t)              ; activate Eglot in referenced non-project files

  :config
  ;; Avoid changing line heights if your font is wonky. See
  ;; https://github.com/joaotavora/eglot/discussions/1492
  (setopt eglot-code-action-indicator "h")

  (fset #'jsonrpc--log-event #'ignore)  ; massive perf boost---don't log every event
  )

(provide 'dev)
