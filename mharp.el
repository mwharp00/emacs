(setq user-full-name "Mark W Harpster"
      user-mail-address "mwharp@gmail.com")

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/elisp")
;;(add-to-list 'load-path "~/elisp/artbollocks-mode")
(require 'use-package)

;;(load-file "~/.emacs.secrets")

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(defun sacha/byte-recompile ()
  (interactive)
  (byte-recompile-directory "~/.emacs.d" 0)
  (byte-recompile-directory "~/elisp" 0))

(defun sacha/package-install (package &optional repository)
  "Install PACKAGE if it has not yet been installed.
If REPOSITORY is specified, use that."
  (unless (package-installed-p package)
    (let ((package-archives (if repository
                                (list (assoc repository package-archives))
                              package-archives)))
    (package-install package))))

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(set-background-color "blue")

(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list" t)))

(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

(when window-system
  (tooltip-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode t)
  (scroll-bar-mode t))

;;  (use-package winner
;;    :config (winner-mode 1))

(setq sentence-end-double-space nil)

(use-package helm
  :init
  (progn 
    (require 'helm-config) 
    (setq helm-candidate-number-limit 10)
    ;; From https://gist.github.com/antifuchs/9238468
    (setq helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
          helm-input-idle-delay 0.01  ; this actually updates things
                                        ; reeeelatively quickly.
          helm-quick-update t
          helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t)
    (helm-mode))
  :config
  (progn
    ;; I don't like the way switch-to-buffer uses history, since
    ;; that confuses me when it comes to buffers I've already
    ;; killed. Let's use ido instead.
    (add-to-list 'helm-completing-read-handlers-alist '(switch-to-buffer . ido)))
  :bind (("C-c h" . helm-mini)))
(ido-mode -1) ;; Turn off ido mode in case I enabled it accidentally

;;(use-package smart-mode-line
;;  :init
;;  (progn
;;  (setq-default
;;   mode-line-format 
;;   '("%e"
;;     mode-line-front-space
;;     mode-line-mule-info
;;     mode-line-client
;;     mode-line-modified
;;     mode-line-remote
;;     mode-line-frame-identification
;;     mode-line-buffer-identification
;;     "   "
;;     mode-line-position
;;     (vc-mode vc-mode)
;;     "  "
;;     mode-line-modes
;;     mode-line-misc-info
;;     mode-line-end-spaces))))

;;(require 'diminish)
;;(eval-after-load "yasnippet" '(diminish 'yas-minor-mode))
;;(eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
;;(eval-after-load "guide-key" '(diminish 'guide-key-mode))
;;(eval-after-load "smartparens" '(diminish 'smartparens-mode))
;;(eval-after-load "guide-key" '(diminish 'guide-key-mode))
;;(eval-after-load "eldoc" '(diminish 'eldoc-mode))
;;(diminish 'visual-line-mode)

(fset 'yes-or-no-p 'y-or-n-p)

(setq debug-on-error t)

;;  (defadvice color-theme-alist (around sacha activate)
;;    (if (ad-get-arg 0)
;;        ad-do-it
;;      nil))
;;  (sacha/package-install 'color-theme)
;;  (defun sacha/setup-color-theme ()
;;    (interactive)
;;    (color-theme-solarized 'dark)
;;    (set-face-foreground 'secondary-selection "darkblue")
;;    (set-face-background 'secondary-selection "lightblue")
;;    (set-face-background 'font-lock-doc-face "black")
;;    (set-face-foreground 'font-lock-doc-face "wheat")
;;    (set-face-background 'font-lock-string-face "black")
;;    (set-face-foreground 'org-todo "green")
;;    (set-face-background 'org-todo "black"))
;;
;;  (use-package color-theme
;;    :init
;;    (sacha/setup-color-theme))

;;  (custom-set-faces
;;   '(erc-input-face ((t (:foreground "antique white"))))
;;   '(helm-selection ((t (:background "ForestGreen" :foreground "black"))))
;;   '(org-agenda-clocking ((t (:inherit secondary-selection :foreground "black"))) t)
;;   '(org-agenda-done ((t (:foreground "dim gray" :strike-through nil))))
;;   '(org-done ((t (:foreground "PaleGreen" :weight normal :strike-through t))))
;;   '(org-clock-overlay ((t (:background "SkyBlue4" :foreground "black"))))
;;   '(org-headline-done ((((class color) (min-colors 16) (background dark)) (:foreground "LightSalmon" :strike-through t))))
;;   '(outline-1 ((t (:inherit font-lock-function-name-face :foreground "cornflower blue")))))

(use-package undo-tree
  :init
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

;;(use-package guide-key
;;  :init
;;  (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-c"))
;;  (guide-key-mode 1))  ; Enable guide-key-mode

(prefer-coding-system 'utf-8)
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (list (line-beginning-position)
        (line-beginning-position 2)))))

(bind-key "C-x p" 'pop-to-mark-command)
(setq set-mark-command-repeat-pop t)
(set-background-color "pink")

(set-face-attribute 'default nil :font "Lucida Console-12") 
(bind-key "C-+" 'text-scale-increase)
(bind-key "C--" 'text-scale-decrease)

(use-package helm-swoop
 :bind (("C-S-s" . helm-swoop)))

(use-package windmove
  :bind
  (("<f2> <right>" . windmove-right)
   ("<f2> <left>" . windmove-left)
   ("<f2> <up>" . windmove-up)
  ("<f2> <down>" . windmove-down)))

(defun sacha/search-word-backward ()
  "Find the previous occurrence of the current word."
  (interactive)
  (let ((cur (point)))
    (skip-syntax-backward "w_")
    (goto-char
     (if (re-search-backward (concat "\\_<" (current-word) "\\_>") nil t)
         (match-beginning 0)
       cur))))

(defun sacha/search-word-forward ()
  "Find the next occurrence of the current word."
  (interactive)
  (let ((cur (point)))
    (skip-syntax-forward "w_")
    (goto-char
     (if (re-search-forward (concat "\\_<" (current-word) "\\_>") nil t)
         (match-beginning 0)
       cur))))
(defadvice search-for-keyword (around sacha activate)
  "Match in a case-insensitive way."
  (let ((case-fold-search t))
    ad-do-it))
(global-set-key '[M-up] 'sacha/search-word-backward)
(global-set-key '[M-down] 'sacha/search-word-forward)

(let* ((cygwin-root "c:/cygwin")
       (cygwin-bin (concat cygwin-root "/bin")))
  (when (and (eq 'windows-nt system-type)
             (file-readable-p cygwin-root))
    
    (setq exec-path (cons cygwin-bin exec-path))
    (setenv "PATH" (concat cygwin-bin ";" (getenv "PATH")))
    
    ;; By default use the Windows HOME.
    ;; Otherwise, uncomment below to set a HOME
    ;;      (setenv "HOME" (concat cygwin-root "/home/eric"))
    
    ;; NT-emacs assumes a Windows shell. Change to bash.
    (setq shell-file-name "bash")
    (setenv "SHELL" shell-file-name) 
    (setq explicit-shell-file-name shell-file-name) 
    
    ;; This removes unsightly ^M characters that would otherwise
    ;; appear in the output of java applications.
    (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)))

(server-start)

;;(if (not (fboundp 'orig-require))
;;    (fset 'orig-require (symbol-function 'require))
;;  (message "The code to redefine `require' should not be loaded twice"))
;;
;;(defvar my/require-depth 0)
;;
;;(defun require (feature &optional filename noerror)
;;  "Leave a trace of packages being loaded."
;;  (cond ((member feature features)
;;       (message "%sRequiring `%s' (already loaded)"
;;                (concat (make-string (* 2 my/require-depth) ? ) "+-> ")
;;                feature))))
;;      (t
;;       (message "%sRequiring `%s'"
;;                (concat (make-string (* 2 my/require-depth) ? )
;;                        "+-> ")
;;                feature)
;;       (let ((my/require-depth (+ 1 my/require-depth)))
;;         (orig-require feature filename noerror))
;;       (message "%sRequiring `%s'...done")
;;                (concat (make-string (* 2 my/require-depth) ? )
;;                        "+-> "))

(setq cua-enable-cua-keys nil) ;; only rectangles
(cua-mode t)

;; Use a bar cursor when mark is active and a region exists.
(defun th-activate-mark-init ()
  (setq cursor-type 'bar))
(add-hook 'activate-mark-hook 'th-activate-mark-init)

(defun th-deactivate-mark-init ()
  (setq cursor-type 'box))
(add-hook 'deactivate-mark-hook 'th-deactivate-mark-init)
 
;; Use a red cursor in overwrite-mode
;;(defvar th--default-cursor-color "black")
(defadvice overwrite-mode (after th-overwrite-mode-change-cursor activate)
  "Change cursor color in override-mode."
  (if overwrite-mode
      (progn
        (setq th--default-cursor-color
              (let ((f (face-attribute 'cursor :background)))
                (if (stringp f)
                    f
                  th--default-cursor-color)))
        (set-cursor-color "red"))
    (set-cursor-color th--default-cursor-color)))

(mapcar
 (lambda (r)
   (set-register (car r) (cons 'file (cdr r))))
 '((?i . "~/.emacs.d/Sacha.org")
   (?o . "~/personal/organizer.org")
   (?b . "~/personal/business.org")
   (?e . "~/code/emacs-notes/tasks.org")
   (?w . "~/Dropbox/public/sharing/index.org")
   (?W . "~/Dropbox/public/sharing/blog.org")
   (?g . "~/sachac.github.io/evil-plans/index.org")
   (?l . "~/dropbox/public/sharing/learning.org")))

;; (sacha/package-install 'browse-kill-ring)
  (use-package browse-kill-ring
    :init 
    (progn 
      (browse-kill-ring-default-keybindings) ;; M-y
      (setq browse-kill-ring-quit-action 'save-and-restore)))

;;  (use-package key-chord
;;    :init
;;    (progn 
;;      (key-chord-mode 1)
;;      (key-chord-define-global "cg"     'undo)
;;      (key-chord-define-global "yp"     'other-window)))

(defalias 'list-buffers 'ibuffer)
(setq visible-bell t)
(desktop-save-mode 1)
(tooltip-mode 1)
(setq tooltip-use-echo-area t)
(setq delete-by-moving-to-trash t)

;;(use-package smartscan
;;  :init (global-smartscan-mode t))

(load "escreen")
(escreen-install)

(setq w3m-command "c:/cygwin/bin/w3m.exe")

(when (require 'deft nil 'noerror) 
  (setq
   deft-extension "org"
   deft-directory "~/Dropbox/deft/"
   deft-text-mode 'org-mode)
  (global-set-key (kbd "<f8>") 'deft))
(setq deft-use-filename-as-title t)
(require 'deft)
(setq deft-use-filename-as-title t)

(require 'auto-install)
(require 'iy-go-to-char)
(require 'ace-jump-mode)
(require 'xml-rpc)
(require 'dired+)
(require 'calfw)
(require 'calfw-org)

(add-to-list 'load-path "~/elisp/planner-3.42")
(add-to-list 'load-path "~/elisp/planner-3.42/contrib")
(require 'muse)
(require 'muse-mode)
(require 'muse-colors)
(require 'muse-wiki)
(setq muse-wiki-allow-nonexistent-wikiword t)
(require 'muse-publish)
(require 'muse-html) ;;; allow derive style from "html" and "xhtml"
(require 'muse-xml)  ;;; allow derive style from "xml"
(require 'muse-latex)
(require 'muse-journal)
(require 'muse-project)  ;; publish files in projects
(setq muse-project-alist
      '(("WikiPlanner"
         ("~/Plans/"           ;; where your Planner pages are located
          :default "TaskPool" ;; use value of `planner-default-page'
          :major-mode planner-mode
          :visit-link planner-visit-link)
         
         ;; This next part is for specifying where Planner pages
         ;; should be published and what Muse publishing style to
         ;; use.  In this example, we will use the XHTML publishing
         ;; style.
         
         (:base "planner-xhtml"
                ;; where files are published to
                ;; (the value of `planner-publishing-directory', if
                ;;  you have a configuration for an older version
                ;;  of Planner)
                :path "~/public_html/Plans"))))


(require 'planner)

;;  (require 'planner)
;;  (require 'remember)
;;  (require 'remind)
;;  (require 'planner-id)
(require 'planner-diary)
(planner-diary-insinuate)
;;  (setq mark-diary-entries-in-calendar t)
;;  (add-hook 'diary-display-hook 'fancy-diary-display)
;;  (planner-insinuate-calendar)
;;  (setq remember-handler-functions '(remember-planner-append))
;;   (setq remember-annotation-functions planner-annotation-functions)
(setq planner-carry-tasks-forward 0)

(require 'org-journal)

(require 'find-dired)
(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))

(defun xah-toggle-margin-right ()
  "Toggle the right margin between `fill-column' or window width.
This command is convenient when reading novel, documentation."
  (interactive)
  (if (eq (cdr (window-margins)) nil)
      (set-window-margins nil 0 (- (window-body-width) fill-column))
    (set-window-margins nil 0 0)))
(set-background-color "yellow")

;;      (use-package artbollocks-mode
;;        :init
;;        (progn
;;          (setq artbollocks-weasel-words-regex
;;                (concat "\\b" (regexp-opt
;;                               '("one of the"
;;                                 "should"
;;                                 "just"
;;                                 "sort of"
;;                                 "a lot"
;;                                 "probably"
;;                                 "maybe"
;;                                 "perhaps"
;;                                 "I think"
;;                                 "really"
;;                                 "pretty"
;;                                 "nice"
;;                                 "action"
;;                                 "utilize"
;;                                 "leverage") t) "\\b"))
          ;; Don't show the art critic words, or at least until I figure
          ;; out my own jargon
;;          (setq artbollocks-jargon nil)))

(defun sacha/unfill-paragraph (&optional region)
    "Takes a multi-line paragraph and makes it into a single line of text."
    (interactive (progn
                   (barf-if-buffer-read-only)
                   (list t)))
    (let ((fill-column (point-max)))
      (fill-paragraph nil region)))
(bind-key "M-Q" 'sacha/unfill-paragraph)

(defun sacha/fill-or-unfill-paragraph (&optional unfill region)
    "Fill paragraph (or REGION).
  With the prefix argument UNFILL, unfill it instead."
    (interactive (progn
                   (barf-if-buffer-read-only)
                   (list (if current-prefix-arg 'unfill) t)))
    (let ((fill-column (if unfill (point-max) fill-column)))
      (fill-paragraph nil region)))
(bind-key "M-q" 'sacha/fill-or-unfill-paragraph)

(remove-hook 'text-mode-hook #'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; Transpose stuff with M-t
(bind-key "M-t" nil) ;; which used to be transpose-words
(bind-key "M-t l" 'transpose-lines)
(bind-key "M-t w" 'transpose-words)
(bind-key "M-t t" 'transpose-words)
(bind-key "M-t M-t" 'transpose-words)
(bind-key "M-t s" 'transpose-sexps)

(setq org-modules '(org-bbdb 
                      org-gnus
                      org-drill
                      org-info
                      org-habit
                      org-irc
                      org-mouse
                      org-annotate-file
                      org-eval
                      org-expiry
                      org-interactive-query
                      org-man
                      org-panel
                      org-screen
                      org-toc))
(org-load-modules-maybe t)
(setq org-expiry-inactive-timestamps t)

(defun reindent-whole-buffer ()
  "Reindent the whole buffer."
  (interactive)
  (indent-region (point-min)
                 (point-max)))

(setq w32-pass-apps-to-system nil
      w32-apps-modifier 'super)
(setq <apps> 'super) ;; Menu key
(defun insert-date-stamp()
  (interactive)
  (insert (org-read-date)))
(set-background-color "white")
(global-set-key (kbd "<f5> b") 'shell-command)
(global-set-key (kbd "<f5> s") 'replace-string)
(global-set-key (kbd "<f5> c") 'org-w3m-copy-for-org-mode)
(global-set-key (kbd "<f5> l") 'getskd)
(global-set-key (kbd "<f9>") 'escreen-prefix)
(global-set-key (kbd "s-c") 'calendar)
(global-set-key (kbd "s-d") 'insert-date-stamp)
(global-set-key (kbd "s-i") 'imenu-anywhere)
(global-set-key (kbd "s-t") 'orgtbl-mode)
(global-set-key (kbd "s-r") 'revert-buffer)
(global-set-key (kbd "s-s") 'mwh-create-set)
(global-set-key (kbd "s-q") 'reindent-whole-buffer)

(global-set-key (kbd "C-c f") 'iy-go-to-char)
(global-set-key (kbd "C-c b") 'iy-go-to-char-backward)
(global-set-key (kbd "C-c ;") 'iy-go-to-char-continue)
(global-set-key (kbd "C-c ,") 'iy-go-to-char-continue-backward)
(global-set-key (kbd "C-c j") 'ace-jump-mode)

(global-set-key (kbd "<f7> t") 'planner-create-task-from-buffer)
(global-set-key (kbd "<f7> r") 'remember)
(global-set-key (kbd "<f7> c") 'remember-region)
(global-set-key (kbd "<f7> n") 'planner-create-note-from-task)

      (bind-key "C-c r" 'org-capture)
      (bind-key "C-c a" 'org-agenda)
      (bind-key "C-c l" 'org-store-link)
      (bind-key "C-c L" 'org-insert-link-global)
      (bind-key "C-c O" 'org-open-at-point-global)
;;      (bind-key "<f9> <f9>" 'org-agenda-list)
;;      (bind-key "<f9> <f8>" (lambda () (interactive) (org-capture nil "r")))
      (bind-key "C-TAB" 'org-cycle org-mode-map)
      (bind-key "C-c v" 'org-show-todo-tree org-mode-map)
      (bind-key "C-c C-r" 'org-refile org-mode-map)
;;      (bind-key "C-c R" 'org-reveal org-mode-map)
(set-background-color "green")

(eval-after-load 'org
  '(progn
     (bind-key "s-k" 'append-next-kill org-mode-map)))

(use-package org-agenda
  :init (bind-key "i" 'org-agenda-clock-in org-agenda-mode-map))

(column-number-mode 1)
(set-background-color "red")

(setq vc-diff-switches '("-b" "-B" "-u"))
(load-theme 'wombat t)
