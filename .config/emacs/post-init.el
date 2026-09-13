;;; post-init.el --- Post-init.el -*- no-byte-compile: t; lexical-binding: t; -*-

;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(use-package autorevert
  :ensure nil
  :init
  ;; (setq auto-revert-verbose t)
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil)
  (global-auto-revert-mode 1))

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(use-package recentf
  :ensure nil
  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))
  ;; Enable `recentf-mode'
  (recentf-mode 1)

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package savehist
  :ensure nil
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600)
  (savehist-mode 1))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :init
  (setq save-place-limit 400)
  (save-place-mode 1))

;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)

;; Trigger an auto-save after 300 keystrokes
(setq auto-save-interval 300)

;; Trigger an auto-save 30 seconds of idle time.
(setq auto-save-timeout 30)

;; Corfu enhances in-buffer completion by displaying a compact popup with
;; current candidates, positioned either below or above the point. Candidates
;; can be selected by navigating up or down.
(use-package corfu
  :init
  (setq text-mode-ispell-word-completion nil)
  ;; Hide commands in M-x which do not apply to the current mode.
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (setq tab-always-indent 'complete)

  (global-corfu-mode 1))

;; Cape, or Completion At Point Extensions, extends the capabilities of
;; in-buffer completion. It integrates with Corfu or the default completion UI,
;; by providing additional backends through completion-at-point-functions.
(use-package cape
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

;; Vertico provides a vertical completion interface, making it easier to
;; navigate and select from completion candidates (e.g., when `M-x` is pressed).
(use-package vertico
  :init
  ;; (setq vertico-scroll-margin 0) ;; Different scroll margin
  ;; (setq vertico-count 20) ;; Show more candidates
  ;; (setq vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  (vertico-mode 1))

;; Vertico leverages Orderless' flexible matching capabilities, allowing users
;; to input multiple patterns separated by spaces, which Orderless then
;; matches in any order against the candidates.
(use-package orderless
  :init
  (setq completion-styles '(orderless basic))
  (setq completion-category-overrides '((file (styles partial-completion))))
  ;; Emacs 31: partial-completion behaves like substring
  (setq completion-pcm-leading-wildcard t))

;; Marginalia allows Embark to offer you preconfigured actions in more contexts.
;; In addition to that, Marginalia also enhances Vertico by adding rich
;; annotations to the completion candidates displayed in Vertico's interface.
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode 1))

;; Embark integrates with Consult and Vertico to provide context-sensitive
;; actions and quick access to commands based on the current selection, further
;; improving user efficiency and workflow within Emacs. Together, they create a
;; cohesive environment for managing completions and interactions.
(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult)

;; Consult offers a suite of commands for efficient searching, previewing, and
;; interacting with buffers, file contents, and more, improving various tasks.

(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ("C-c r" . consult-recent-file)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )

;; The undo-fu package is a lightweight wrapper around Emacs' built-in undo
;; system, providing more convenient undo/redo functionality.
(use-package undo-fu
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :init
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

;; The undo-fu-session package complements undo-fu by enabling the saving
;; and restoration of undo history across Emacs sessions, even after restarting.
(use-package undo-fu-session
  :init
  (undo-fu-session-global-mode 1))

;; Uncomment the following if you are using undo-fu
(setq evil-undo-system 'undo-fu)

(let ((inhibit-redisplay t))
  ;; Disable all active themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load the built-in theme
  (load-theme 'noctalia t))

;; Vim emulation
(use-package evil
  :init
  ;; It has to be defined before evil
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)

  ;; Make :s in visual mode operate only on the actual visual selection
  ;; (character or block), instead of the full lines covered by the selection
  (setq evil-ex-visual-char-range t)
  ;; Use Vim-style regular expressions in search and substitute commands,
  ;; allowing features like \v (very magic), \zs, and \ze for precise matches
  (setq evil-ex-search-vim-style-regexp t)
  ;; Enable automatic horizontal split below
  (setq evil-split-window-below t)
  ;; Enable automatic vertical split to the right
  (setq evil-vsplit-window-right t)
  ;; Disable echoing Evil state to avoid replacing eldoc
  (setq evil-echo-state nil)
  ;; Do not move cursor back when exiting insert state
  (setq evil-move-cursor-back nil)
  ;; Make `v$` exclude the final newline
  (setq evil-v$-excludes-newline t)
  ;; Enable fine-grained undo behavior
  (setq evil-want-fine-undo t)
  ;; Disable wrapping of search around buffer
  (setq evil-search-wrap nil)
  ;; Allow C-h to delete in insert state
  (setq evil-want-C-h-delete t)
  ;; Enable C-u to delete back to indentation in insert state
  (setq evil-want-C-u-delete t)
  ;; Whether Y yanks to the end of the line
  (setq evil-want-Y-yank-to-eol t)

  ;; Start `evil-mode'
  (evil-mode 1)

  :config
  ;; Occasionally, `evil' fails to respect `evil-search-module' when it is
  ;; defined inside the :custom block. This fix ensures the search module
  ;; is correctly set to `evil-search'.
  (setq evil-search-module 'evil-search)
  (evil-select-search-module 'evil-search-module 'evil-search))

(use-package evil-collection
  :after evil
  :init
  ;; It has to be defined before evil-collection
  (setq evil-collection-setup-minibuffer t)
  (evil-collection-init))

;; The goto-chg package is useful with Evil to jump directly to the most recent
;; edit location. This mirrors Vim's change navigation, allowing fast return to
;; where text was last modified without relying on the jump list or search.
;;
;; The goto-chg commands are bound to g; and g,
(use-package goto-chg
  :commands (goto-last-change
             goto-last-change-reverse))

;;; avy
(use-package avy
  :commands (avy-goto-char
             avy-goto-char-2
             avy-next)
  :bind (("C-c j" . avy-goto-line)
         ("C-c k"   . avy-goto-char-timer)
         :map isearch-mode-map
         ("C-c k" . avy-isearch)))

;;; Enable automatic insertion and management of matching pairs of characters
;;; (e.g., (), {}, "") globally using `electric-pair-mode'.
(use-package elec-pair
  :ensure nil
  :init
  (electric-pair-mode 1))

;; Set the fringes to match the pixel height of a character. This ensures the
;; fringe is wide enough, scaling dynamically with the current font size.
(fringe-mode (frame-char-width))

;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.
(delete-selection-mode 1)

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Display of line numbers in the buffer:
(setq-default display-line-numbers-type 'relative)
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Highlight current line when in programming buffers
(add-hook 'prog-mode-hook #'hl-line-mode)

;; Set the maximum level of syntax highlighting for Tree-sitter modes
(setq treesit-font-lock-level 4)

(use-package which-key
  :ensure nil
  :init
  (setq which-key-idle-delay 1.5)
  (setq which-key-idle-secondary-delay 0.25)
  (setq which-key-add-column-padding 1)
  (setq which-key-max-description-length 40)
  (which-key-mode 1))

;; Smooth scrolling
(setq pixel-scroll-precision-use-momentum nil) ; Precise/smoother scrolling
(pixel-scroll-precision-mode 1)

;; Show trailing whitespace
(setq-default show-trailing-whitespace t)

;; Paren match highlighting
(show-paren-mode 1)

;;; Use common keystrokes by default
;; ctrl+c ctrl+v etc.
(cua-mode)

;;; Enable horizontal scrolling
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-flip-direction t)

(defun my/set-face-font (face)
  (set-face-attribute face nil
                       :height 110 :weight 'normal :family "IosevkaTerm NFM"))

;; Customise the default font with specific size and weight
(mapc #'my/set-face-font
      '(default fixed-pitch
        tab-bar tab-bar-tab tab-bar-tab-inactive
        line-number line-number-current-line))

;; Window dividers separate windows visually. Window dividers are bars that can
;; be dragged with the mouse, thus allowing you to easily resize adjacent
;; windows.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Window-Dividers.html
(window-divider-mode 1)

;; Constrain vertical cursor movement to lines within the buffer
(setq dired-movement-style 'bounded-files)

;; Dired buffers: Automatically hide file details (permissions, size,
;; modification date, etc.) and all the files in the `dired-omit-files' regular
;; expression for a cleaner display.
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Hide files from dired
(setq dired-omit-files (concat "\\`[.]\\'"
                               "\\|\\(?:\\.js\\)?\\.meta\\'"
                               "\\|\\.\\(?:elc\\|a\\|o\\|pyc\\|pyo\\|swp\\|class\\)\\'"
                               "\\|^\\.DS_Store\\'"
                               "\\|^\\.\\(?:svn\\|git\\)\\'"
                               "\\|^\\.ccls-cache\\'"
                               "\\|^__pycache__\\'"
                               "\\|^\\.project\\(?:ile\\)?\\'"
                               "\\|^flycheck_.*"
                               "\\|^flymake_.*"))
(add-hook 'dired-mode-hook #'dired-omit-mode)

;; dired: Group directories first
(with-eval-after-load 'dired
  (let ((args "--group-directories-first -ahlv"))
    (when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
      (if-let* ((gls (executable-find "gls")))
          (setq insert-directory-program gls)
        (setq args nil)))
    (when args
      (setq dired-listing-switches args))))

;; Enables visual indication of minibuffer recursion depth after initialization.
(minibuffer-depth-indicate-mode 1)

;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)

;; like oil.nvim
(with-eval-after-load 'evil
  (evil-define-key 'normal 'global
    "-" #'dired-jump))

;; Inside Dired itself, the same two keys instead go UP one directory
;; level — matching oil's in-buffer "go to parent" behavior once you're
;; already browsing.
(with-eval-after-load 'dired
  (evil-collection-define-key 'normal 'dired-mode-map
    "-" #'dired-up-directory
    (kbd "C-h") #'dired-up-directory
    (kbd "C-j") #'dired-next-line
    (kbd "C-k") #'dired-previous-line
    (kbd "C-l") #'dired-find-file))

