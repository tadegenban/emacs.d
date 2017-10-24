(ivy-mode 1)
(require 'subr-x)  ; swiper's string-trim-right need this package
(setq ivy-use-virtual-buffers t)
(setq ivy-height 10)
(setq ivy-count-format "(%d/%d) ")

(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c C-r") 'ivy-resume)

(global-set-key (kbd "C-s") 'counsel-grep-or-swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)

(define-key ivy-minibuffer-map (kbd "C-w") 'ivy-yank-word)
(advice-add 'counsel-grep-or-swiper :before 'avy-push-mark)

(setq ivy-views
      '(("dutch + notes {}"
         (vert
          (file "dutch.org")
          (buffer "notes")))
        ("ivy {}"
         (horz
          (file "ivy.el")
          (buffer "*scratch*")))))

(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c V") 'ivy-pop-view)


(defun ivy-copy-to-buffer-action (x)
  (let ((str (read-string ":")))
    (with-ivy-window
      (insert str))))

(defun ivy-call-last-kbd-macro (x)
  (with-ivy-window
    (call-last-kbd-macro))
  )

(ivy-set-actions
 'counsel-grep-or-swiper
 '(
   ("q" ivy-call-last-kbd-macro "call-last-kbd-macro")
   ))


(setq ivy-switch-buffer-faces-alist
      '((emacs-lisp-mode . swiper-match-face-1)
        (dired-mode . ivy-subdir)
        (org-mode . org-level-4)))


(defun counsel-goto-recent-directory ()
  "Open recent directory with dired"
  (interactive)
  (unless recentf-mode (recentf-mode 1))
  (let ((collection
         (delete-dups
          (append (mapcar 'file-name-directory recentf-list)
                  ;; fasd history
                  (if (executable-find "fasd")
                      (split-string (shell-command-to-string "fasd -ld") "\n" t))))))
    (ivy-read "directories:" collection :action 'dired)))


(provide 'init-swiper)
