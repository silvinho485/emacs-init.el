;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives
  ;; choose either the stable or the latest git version:
  ;; '("melpa-stable" . "http://melpa-stable.org/packages/")
  '("melpa-unstable" . "http://melpa.org/packages/"))
(package-initialize)

(setq default-frame-alist
      '((foreground-color . "white")
        (background-color . "black")))

(setq history-length 500)
(savehist-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (fill-column-indicator emmet-mode python-django jedi w3m)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(ido-mode 'buffers)
(add-hook 'prog-mode-hook
	  (lambda ()
	    (linum-mode 1)))
(global-set-key (kbd "C-M-<backspace>") 'backward-kill-sexp)
(setq neo-vc-integration nil)
;;;; Search.

;; Automatically wrapping I-search.
;; https://stackoverflow.com/questions/285660/automatically-wrapping-i-search
;; TODO: Still not perfect: does not distinguish overwrapped I-search anymore.
(defadvice isearch-search (after isearch-no-fail activate)
  (unless isearch-success
    ;; Avoid recursive loop
    (ad-disable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search) ;; ad-activate to reflect the above change
    ;; Repeat the search (in the appropriate direction)
    (isearch-repeat (if isearch-forward 'forward))
    ;; Restore advice
    (ad-enable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)))

;; The above solution has a serious problem: it creates a spurious "input event"
;; when it implicitly repeats the search. This means you have to type DEL
;; *twice* to undo the last command. I should find a proper solution to this,
;; but the fact is that I don't generally want DEL to undo last event anyway, I
;; want it to remove the last characher from the search (what C-M-w does (yeah,
;; really). So instead I'll redefine DEL (which apparently has to be called
;; <backspace> for the graphical Emacs) to remove last character from search
;; query, and the undo key to undo the last search event. This leaves the undo
;; key with the aforementioned bug, but whatever.

(define-key isearch-mode-map (kbd "<backspace>") 'isearch-del-char)
(define-key isearch-mode-map (kbd "DEL") 'isearch-del-char)
(define-key isearch-mode-map (kbd "C-/") 'isearch-delete-char)
(define-key isearch-mode-map (kbd "C-_") 'isearch-delete-char)

(setq-default indent-tabs-mode nil)

(delete-selection-mode 1)

(if (equal system-type 'darwin)  
    (setq python-shell-interpreter "/Users/silvio/.pyenv/shims/python")
  (setq python-shell-interpreter "/bin/python3.5"))

(setq tab-always-indent 'complete)

(defvar elmord/c-style
  '("java"    ;; Inherit from this style
    (c-offsets-alist
     (case-label . 4)
     (statement-case-intro . 4)
     (statement-case-open . 4)
     (label . 2))))

(c-add-style "elmord" elmord/c-style)(setq c-default-style "elmord")

(electric-pair-mode 1)

(show-paren-mode 1)
;; Changing window focus.
(global-set-key (kbd "M-S-<up>") 'windmove-up)
(global-set-key (kbd "M-S-<down>") 'windmove-down)
(global-set-key (kbd "M-S-<left>") 'windmove-left)
(global-set-key (kbd "M-S-<right>") 'windmove-right)

;; Run python and pop-up its shell.
;; Kill process to solve the reload modules problem.
(defun my-python-shell-run ()
  (interactive)
  (when (get-buffer-process "*Python*")
     (set-process-query-on-exit-flag (get-buffer-process "*Python*") nil)
     (kill-process (get-buffer-process "*Python*"))
     ;; If you want to clean the buffer too.
     ;;(kill-buffer "*Python*")
     ;; Not so fast!
     (sleep-for 0.5))
  (run-python (python-shell-parse-command) nil nil)
  (python-shell-send-buffer)
  ;; Pop new window only if shell isnt visible
  ;; in any frame.
  (unless (get-buffer-window "*Python*" t) 
    (python-shell-switch-to-shell)))

(defun my-python-shell-run-region ()
  (interactive)
  (python-shell-send-region (region-beginning) (region-end))
  (python-shell-switch-to-shell))

(eval-after-load "python"
  '(progn
     (define-key python-mode-map (kbd "C-c C-c") 'my-python-shell-run)
     (define-key python-mode-map (kbd "C-c C-r") 'my-python-shell-run-region)
     (define-key python-mode-map (kbd "C-h f") 'python-eldoc-at-point)))

(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; Auto-refresh dired on file change
(add-hook 'dired-mode-hook 'auto-revert-mode)

;; auto on fci-mode
(define-globalized-minor-mode my-global-fci-mode fci-mode turn-on-fci-mode)
(my-global-fci-mode 1)

;; set fill collumn default to 80
(setq-default fill-column 80)

;; set_trace() macro
(fset 'python-strace
   [C-home return up ?i ?m ?p ?o ?r ?t ?  ?p ?d ?b ?\C-u ?\C-  ?i ?f ?  ?c ?o ?n ?d ?i ?t ?i ?o ?n ?: return ?p ?d ?b ?. ?s ?e ?t ?_ ?t ?r ?a ?c ?e ?\(])
