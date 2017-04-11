;; LETS START HERE!!!!!

;; Solidify knowledge of emacs

;; making sure emacs loads it's package manager
;; (THIS IS INCLUDED IN EMACS)
(require 'package)


;; adding repositories for better emacs packages
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; activate the emacs packages are are installed in the `elpa' directory
(package-initialize)

;; on a fresh install, the elpa diretory is not there.
;; So we need to run the package refresh contents.
(if (not (file-exists-p "~/.emacs.d/elpa"))
    (package-refresh-contents))


;; Alright, so what we are writing is called `emacs-lisp'.
;; anyfunction that you see is probably `documented'.
;; to look at the documentation type : `C-h f'. then type
;; the function name that you would like to see the docu-
;; menation for.

;; I want to change the default location of the
;; auto-generated custom file
(setq custom-file "~/.emacs.d/custom.el")

;; lets change the locations of the annoying temp files
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;; this package is used for nicer pluggin loading
(if (not (package-installed-p 'use-package))
    (package-install 'use-package))
(require 'use-package)

;; this package is used for better paren closing (LISP stuff)
(if (not (package-installed-p 'smartparens))
    (package-install 'smartparens))

;; setting up smart parens
(require 'smartparens-config)
(use-package smartparens
  :config
  (progn
    ;; THIS IS WHERE WE ADD THE SMART PAREN FUNCTIONALITY
    ;; TO THE DIFFERENT LANGUAGES WE WOULD LIKE TO USE IT FOR.
    (add-hook 'python-mode-hook #'smartparens-mode)
    (add-hook 'emacs-lisp-mode-hook #'smartparens-mode)
    ))


;; lets now add some color to those parens
(if (not (package-installed-p 'rainbow-delimiters))
    (package-install 'rainbow-delimiters))
(use-package rainbow-delimiters
  :config
  (progn
    (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
    (add-hook 'python-mode-hook 'rainbow-delimiters-mode) ; for capstone
    (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode) ; for alex awesome
    ))


;; AWESOME.
;; it's getting a little annoying having to rewrite that if
;; statement when I want to install a package...
;; lets write a little helper function
(defun ao-install-pkg (pkg-name)
  (if (not (package-installed-p pkg-name))
      (package-install pkg-name))) ; cool


;; alright, I like using git from emacs... so lets add some magit
(ao-install-pkg 'magit) ; ah much better with one line... still think
					; there is a better way tho...
(ao-install-pkg 'git-gutter)
(use-package magit
  :config
  (progn
    ;; magit is awesome; Omar, you should use this.
    (define-key global-map (kbd "M-g s") 'magit-status)
    ))
(use-package git-gutter
  :config
  (progn
    (global-git-gutter-mode 1)
    ))


(ao-install-pkg 'undo-tree) ; i actually use this

(use-package undo-tree
  :config
  (progn
    (global-undo-tree-mode 1) ; the default keymap for this is. `C-x u'
    ))


;; awesome project management
(ao-install-pkg 'projectile)
(use-package projectile
  :config
  (progn
    (projectile-mode 1)))


;; clojure :)
(mapcar #'ao-install-pkg
	(list 'clojure-mode
	      'cider))


;; rust
(mapcar #'ao-install-pkg
	(list 'rust-mode
	      'toml-mode
	      'racer))


;; autocomplete
(mapcar #'ao-install-pkg
	(list 'company
	      'company-racer))
(use-package company
  :config
  (progn
    (add-hook 'after-init-hook 'global-company-mode)
    (add-to-list 'company-backends 'company-racer)
    ))

(ao-install-pkg 'exec-path-from-shell)
(use-package exec-path-from-shell
  :config
  (progn
    (exec-path-from-shell-initialize)))


;; I like helm. Not sure if omar does
(if (equal "alex" (getenv "USER"))
    (progn
      (ao-install-pkg 'helm)
      (ao-install-pkg 'helm-projectile)
      (setq projectile-completion-system 'helm)
      (helm-projectile-on)
      (setenv "RUST_SRC_PATH" "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/")
      ))
