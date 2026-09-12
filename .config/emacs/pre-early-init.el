;;; pre-early-init.el --- Pre-early-init -*- no-byte-compile: t; lexical-binding: t; -*-

;;; Reducing clutter in ~/.config/emacs by redirecting files to ~/.config/emacs/var/
;; NOTE: This must be placed in 'pre-early-init.el'.
(setq user-emacs-directory (expand-file-name "var/" minimal-emacs-user-directory))
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

;;; Enable menu bar
(setq minimal-emacs-ui-features '(menu-bar))

