;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Enes Tufekci"
      user-mail-address "enesxtufekci@gmail.com")

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
(setq doom-font (font-spec :family "Source Code Pro" :size 32 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

(setq light-theme 'doom-gruvbox-light)
(setq dark-theme  'doom-gruvbox)

(defun night-mode ()
  (interactive)
  (load-theme dark-theme t)
  (doom/reload-theme))

(defun day-mode ()
  (interactive)
  (load-theme light-theme t)
  (doom/reload-theme))


(defun auto-theme ()
  "Select the theme automatically based on the time of day."
  (require 'solar)
  (let* ((cur-hour (string-to-number (substring (current-time-string) 11 13)))
         (sun-events (solar-sunrise-sunset (calendar-current-date)))
         (sunrise (caar sun-events))
         (sunset  (caadr sun-events)))
    (if (and (> cur-hour sunrise) (< cur-hour sunset))
        (day-mode)
        (night-mode))))

(after! doom-theme
  (auto-theme))


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

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
(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; (def-package! graphql-mode
;;   :mode "\\.graphql$")

(if (featurep! :lang web)
    (progn
      (add-hook 'typescript-tsx-mode-hook #'emmet-mode)
      (define-key evil-insert-state-map (kbd "C-e") 'nil)
      (define-key emmet-mode-keymap (kbd "C-e") 'emmet-expand-line)

      (setq web-mode-markup-indent-offset 2)
      (setq web-mode-css-indent-offset 2)
      (setq web-mode-code-indent-offset 2)
      (setq web-mode-script-padding 2)
      (setq web-mode-block-padding 2)
      (setq web-mode-style-padding 2)
      (setq web-mode-enable-auto-pairing t)
      (setq web-mode-enable-auto-closing t)
      (setq web-mode-enable-current-element-highlight t)
      (setq-default typescript-indent-level 2)

      (after! flycheck
        (after! tide
          (push 'typescript-tslint flycheck-disabled-checkers)

             (flycheck-add-mode 'typescript-tide 'tepescript-mode)
             (flycheck-add-mode 'typescript-tide 'typescript-tsx-mode)
             (flycheck-add-next-checker 'typescript-tide 'javascript-eslint)
             (flycheck-add-next-checker 'typescript-tide 'javascript-eslint)
        )
       ))

  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
  (add-to-list 'auto-mode-alist '("\\.spec.tsx\\'" . typescript-mode)))



;; Eshell
(custom-set-variables
'(eshell-visual-commands
   (quote
    ("vim" "tail" "htop" "ssh" "vi" "screen" "top" "less" "more" "lynx" "ncftp" "pine" "tin" "trn" "elm" "bower" "jest" "ncdu" "npm" "pinentry-curses" "watch" "yarn")))
)

;; Search
(defun rerun-last-search (arg)
  (interactive "P")
  (+ivy/project-search arg (car counsel-git-grep-history)))
(map! :leader "s ." #'rerun-last-search)

;; Hello
