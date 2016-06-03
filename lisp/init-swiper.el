(ivy-mode 1)
(require 'subr-x)  ; swiper's string-trim-right need this package
(setq ivy-use-virtual-buffers t)
(setq ivy-height 10)
(setq ivy-count-format "(%d/%d) ")

(global-set-key (kbd "C-x b") 'ivy-switch-buffer)

(global-set-key (kbd "C-s") 'counsel-grep-or-swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)

(define-key ivy-minibuffer-map (kbd "C-w") 'ivy-yank-word)

(setq ivy-views
      '(("dutch + notes {}"
         (vert
          (file "dutch.org")
          (buffer "notes")))
        ("ivy {}"
         (horz
          (file "ivy.el")
          (buffer "*scratch*")))))

(provide 'init-swiper)
