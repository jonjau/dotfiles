;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;; 3Q modifications

;;; set font
(add-to-list 'custom-theme-load-path (concat doom-user-dir "themes/"))
(setq doom-theme 'forester)

(setq doom-font (font-spec :family "IosevkaTerm Nerd Font Mono" :size 16 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Liberation Sans" :size 13))

(defun doom-dashboard-draw-ascii-emacs-banner-fn ()
  (propertize
   (string-join
    '("⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠀⠀⠀⠀⢀⣠⠔⠊⠀⠀⠀⠀⠀⠀⠀⠀"
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠞⠀⠀⠀⣀⣤⠖⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠃⣀⣠⡴⠞⠋⠀⠀⠀⠀⠀⠀⠀⠀⣠⠀⢀⠔⠀⠀"
      "⠀⠀⠀⠀⠀⠀⠀⣀⠄⠻⠛⠋⠉⠀⠀⠀⠀⠀⠀⠰⠚⣿⣆⣾⠁⠠⠿⠶⣶⣦"
      "⠀⠀⠀⠀⠀⡠⠚⠁⠀⠀⠀⠀⠀⠀⠀⣠⠶⢿⣷⠀⢀⡿⠻⣿⠶⠂⠀⠀⠈⡿"
      "⠀⠀⢀⡤⠊⠀⠀⠀⠀⠀⠀⣠⢾⣧⠎⠁⢀⡴⠋⠰⠋⢀⣀⣠⣤⡤⠶⠖⠉⠀"
      "⠀⣠⠟⠁⠀⣠⡴⣃⠀⢀⡜⠁⠞⠁⠀⠀⢁⣠⠴⠚⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀"
      "⣿⣃⣤⡶⠟⣩⡾⠋⣠⠋⠀⠀⠀⢀⡠⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
      "⠙⠋⠁⢀⣼⠟⢁⡴⠁⠀⠀⠀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
      "⠀⠀⠀⠈⠁⢠⠞⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
      "⠀⠀⠀⠀⡰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀")
    "\n")
   'face 'doom-dashboard-banner))
(setq +dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn)

;;; dired like oil.nvim
(map! :n "-" #'dired-jump
      (:leader
       (:prefix-map ("o" . "open")
        :desc "Open path in dired" "o"
        (cmd! (dired (read-directory-name "Path: "))))))
(map! :map dired-mode-map
      :n "C-h" #'dired-up-directory
      :n "C-j" #'evil-next-line
      :n "C-k" #'evil-previous-line
      :n "C-l" #'dired-find-file)

;;; avy
;; Use home-row keys for avy's selection overlay (faster to type)
(setq avy-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(setq avy-timeout-seconds 0.3)
(map! :leader "j" #'avy-goto-char-timer)
(map! :leader "k" #'avy-goto-line)

(setq display-line-numbers-type 'relative)

;;; move between windows with Alt hjkl
(map! "M-h" #'evil-window-left
      "M-j" #'evil-window-down
      "M-k" #'evil-window-up
      "M-l" #'evil-window-right)

(after! evil
  (defun my-evil-skip-buffers-advice (orig-fun &rest args)
    "Force evil last buffer toggle to skip dired buffers."
    (let ((prev-buffers (window-prev-buffers)))
      (set-window-prev-buffers
       nil
       (cl-remove-if
        (lambda (entry)
          (let* ((buf (car entry))
                 (name (buffer-name buf)))
            (or (string-prefix-p " " name)
                (with-current-buffer buf (derived-mode-p 'dired-mode)))))
        prev-buffers))
      (apply orig-fun args)))
  (advice-add 'evil-switch-to-windows-last-buffer :around #'my-evil-skip-buffers-advice))

;; keep this many screen lines above/below the cursor.
(setq scroll-margin 4)

;; add some spacing
(add-to-list 'default-frame-alist '(internal-border-width . 10))

;; custom project finder for typescript projects inside monorepo
(with-eval-after-load 'project
  (cl-defmethod project-root ((project (head eglot-project)))
    (cdr project))
  (defun +project-try-tsconfig (dir)
    "Find the nearest ancestor directory containing tsconfig.json."
    (when-let* ((found (locate-dominating-file dir "tsconfig.json")))
      (cons 'eglot-project found)))
  (add-hook 'project-find-functions #'+project-try-tsconfig -100))

;; copy line(s) as relative file-path and line-numbers
(defun +copy-file-line-ref ()
  "Copy \"path:line\" (normal) or \"path:start-end\" (visual) to kill ring and clipboard."
  (interactive)
  (let* ((path (if (buffer-file-name)
                    (file-relative-name (buffer-file-name) (doom-project-root))
                  (buffer-name)))
         (value
          (if (evil-visual-state-p)
              (let ((start (line-number-at-pos (region-beginning)))
                    (end (line-number-at-pos (region-end))))
                (format "%s:%d-%d" path (min start end) (max start end)))
            (format "%s:%d" path (line-number-at-pos)))))
    (kill-new value)
    (when (fboundp 'gui-set-selection) (gui-set-selection 'CLIPBOARD value))
    (message "Copied: %s" value)))

(map! :n "SPC f x" #'+copy-file-line-ref
      :v "SPC f x" #'+copy-file-line-ref)


;;; config ends here
