(cua-mode)
(desktop-save-mode)

;;set the line-number to true
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;;disable the tool bar
(tool-bar-mode -1)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)


;; `custom-file' est le fichier dans lequel Emacs sauvegarde les
;; customizations faites avec l'interface graphiques.
(require 'custom)
(setq custom-file (concat user-emacs-directory "/emacs-custom.el"))
(when (file-exists-p custom-file) (load-file custom-file))


;; Nous nous appuyons sur use-package et quelpa (et quelpa-use-package) :
(unless (package-installed-p 'quelpa)
      (with-temp-buffer
        (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
        (eval-buffer)
        (quelpa-self-upgrade)))
(setq quelpa-update-melpa-p nil)
(advice-add 'quelpa-build--message
            :before-until #'(lambda (msg &rest ignore)
                              (string-match-p "Not upgrading" msg))
            '((name . quelpa-build--message--débavardage)))
(require 'quelpa)
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

;; activation of code completion ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)


(use-package corfu :quelpa
  :custom
  (corfu-auto t)
  :init
  (global-corfu-mode))

(use-package magit :quelpa)


(setq mac-option-key-is-meta t)
(setq mac-right-option-modifier nil)


(global-set-key [(control x) (v) (b)] 'magit-status)
(global-set-key [(control c) (.)] 'org-time-stamp)
(global-set-key [(control c) (control l)] 'org-store-link) 


(use-package treesit-auto
  :quelpa
  :config
  (setq treesit-auto-langs '(js-ts-mode)
        treesit-auto-install t
        global-treesit-auto-modes '(sh-mode))
  (global-treesit-auto-mode))



(use-package org
  :ensure
  :mode ("\\.org\\'" . org-mode)
  :custom
  (org-startup-truncated nil)
  (org-lowest-priority ?D)
  (org-src-fontify-natively t)
  (org-babel-load-languages
   ;; C-c C-c sur un bloc de code Perl pour l'exécuter ! Yow !!
   (cl-list* (cons 'perl t) (cons 'shell t) (cons 'R t)
             (eval (car (get 'org-babel-load-languages 'standard-value)))))
  :config
  (setq org-ctags-enabled-p nil)
  (use-package ox-md :quelpa)        ;; Traduction vers MarkDown
  (use-package org-re-reveal :quelpa
    :custom (org-re-reveal-revealjs-version "4"))
  (use-package org-mouse :quelpa)
  :hook
  (org-mode . (lambda () (electric-indent-mode -1))))

(use-package org-screen            ;; Liens vers des sessions "screen" ! Yow!
  :quelpa
  (org-screen
   :fetcher url
   :url "https://git.sr.ht/~bzg/org-contrib/blob/master/lisp/org-screen.el"))

;; enable a simple shorthand to quoting thing in org mode with <q + tab
(require 'org-tempo)

(setq org-startup-with-inline-images t)
(setq org-image-actual-width nil)
(use-package ox-reveal :quelpa)


(use-package doom-modeline
  :ensure t
  :custom (doom-modeline-highlight-modified-buffer-name nil)
  :custom-face
  (mode-line-active ((t (:background "grey35"))))
  (doom-modeline-warning ((t (:inherit doom-modeline :foreground "firebrick1"))))
  :init (doom-modeline-mode 1))
;; Va bien avec M-x nerd-icons-install-fonts


;; Fichiers de sauvegarde centralisés dans un répertoire
(custom-set-variables
 '(backup-directory-alist
   (list (cons "." (concat user-emacs-directory "/var/backups")))))


;; git-gutter (https://github.com/syohex/emacs-git-gutter)
(use-package git-gutter
  :ensure
  :delight git-gutter-mode   ;; Pas de marque dans la mode-line
  :config
  (setq git-gutter:update-hooks
        (cl-union git-gutter:update-hooks
                  '(vc-post-command-functions
                    magit-post-refresh-hook)))
  (global-git-gutter-mode t))


(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-monokai-pro t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


