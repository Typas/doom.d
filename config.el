;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Typas Liao"
      user-mail-address "typascake@gmail.com")

(set-file-template! "\\.tex$" :trigger "__tex" :mode 'latex-mode)
(set-file-template! "/beamer\\.tex$" :trigger "__beamer.tex" :mode 'latex-mode)
(set-file-template! "\\.gitignore$" :trigger "__" :mode 'gitignore-mode)

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
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)
(setq doom-theme 'doom-one-light)

;; font settings
;; the order of hook matters
(defun push-font (fontfamily)
  "Add font if FONTFAMILY exists."
  (when (doom-font-exists-p fontfamily)
    (add-hook 'doom-init-ui-hook
              (lambda () (set-fontset-font t 'unicode
                                      (font-spec :family fontfamily)
                                      nil 'prepend)))))

(defun push-cjk-font (fontfamily scale)
  "Add cjk font if FONTFAMILY exists, and set the scale to SCALE."
  (when (doom-font-exists-p fontfamily)
    (add-hook 'doom-init-ui-hook
              (lambda ()
                (dolist (charset '(kana han cjk-misc bopomofo hangul))
                  (set-fontset-font t charset
                                    (font-spec :family fontfamily)
                                    nil 'prepend))
                (setq face-font-scale-alist '((fontname . scale)))))))

(push-cjk-font "Typas Mono CJK TC" 1.2)
(push-font "JuliaMono")

(setq doom-font (font-spec
                 :family "Typas Code"
                 :size 14.0))
(unless (doom-font-exists-p doom-font)
  (setq doom-font (font-spec
                   :family "Inconsolata"
                   :size 16.0))
  (unless (doom-font-exists-p doom-font)
    (setq doom-font nil)))

(setq doom-variable-pitch-font (font-spec :family "Noto Sans CJK TC" :size 20))
(unless (doom-font-exists-p doom-variable-pitch-font)
  (setq doom-variable-pitch-font nil))


;; native lazy compilation
(setq native-comp-deferred-compilation t)
;; i just don't want to see warning anymore
(setq native-comp-async-report-warnings-errors nil)

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
(when IS-MAC (setq dired-use-ls-dired nil))

(add-hook! 'prog-mode-hook #'rainbow-delimiters-mode)

(map! :map evil-normal-state-map
      "q" nil)
(map! :map evil-insert-state-map
      "C-p" nil
      "C-n" nil
      "C-v" nil)
(map! :leader
      "c c" nil
      "c C" nil)
(map! :leader
      :desc "Compile" "c C-c" #'compile
      :desc "Recompile" "c C-r" #'recompile
      :desc "Comment region" "c c" #'comment-region
      :desc "Uncomment region" "c u" #'uncomment-region)

(after! org
  (add-to-list 'org-src-lang-modes '("rust" . rustic))
  (add-to-list 'org-src-lang-modes '("toml" . conf-toml)))

(setq TeX-engine 'xetex)

(setq rustic-lsp-server 'rust-analyzer)
(after! rustic
  (setq lsp-rust-analyzer-cargo-load-out-dirs-from-check t)
  (setq lsp-rust-analyzer-proc-macro-enable t))

(after! projectile
  (add-to-list 'projectile-project-root-files-bottom-up "Cargo.toml"))

;; some annoying company settings

(after! company
  (add-to-list 'company-transformers #'delete-dups))

(add-hook 'org-mode-hook #'valign-mode)
(add-hook 'markdown-mode-hook #'valign-mode)
