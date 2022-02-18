;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Typas Liao"
      user-mail-address "typascake@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Treat underscores as word
(add-hook! 'python-mode-hook (modify-syntax-entry ?_ "w"))
(add-hook! 'rustic-mode-hook (modify-syntax-entry ?_ "w"))
(add-hook! 'c++-mode-hook (modify-syntax-entry ?_ "w"))
(add-hook! 'c-mode-hook (modify-syntax-entry ?_ "w"))
(add-hook! 'julia-mode-hook (modify-syntax-entry ?_ "w"))

(add-hook! 'prog-mode-hook #'rainbow-delimiters-mode)

(map! :leader
      :desc "comment region" "c C-c" #'comment-region
      :desc "uncomment region" "c u" #'uncomment-region)

(after! org
  (add-to-list 'org-src-lang-modes '("rust" . rustic))
  (add-to-list 'org-src-lang-modes '("toml" . conf-toml)))

(setq TeX-engine 'xetex)

(setq rustic-lsp-server 'rust-analyzer)
(after! rustic
  (setq lsp-rust-analyzer-cargo-load-out-dirs-from-check t)
  (setq lsp-rust-analyzer-proc-macro-enable t))

(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

(use-package! citre
  :defer t
  :init
  (require 'citre-config)
  (map! :leader
        (:prefix "c"
         :desc "Jump to definition"  "j"  #'citre-jump
         :desc "Back to reference" "J" #'citre-jump-back
         :desc "Peek definition" "p" #'citre-peek
         :desc "Update tags file" "U" #'citre-update-this-tags-file)
        )
  (setq citre-project-root-function #'projectile-project-root)
  (setq citre-default-create-tags-file-location 'package-cache)
  (setq citre-use-project-root-when-creating-tags t)
  (setq citre-prompt-language-for-ctags-command t)
  (setq citre-auto-enable-citre-mode-modes '(prog-mode)))

(after! company
  (company-ctags-auto-setup))

