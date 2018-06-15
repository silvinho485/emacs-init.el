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
 '(package-selected-packages (quote (jedi w3m))))
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

(setq python-shell-interpreter "/Users/silvio/.pyenv/shims/python")
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
