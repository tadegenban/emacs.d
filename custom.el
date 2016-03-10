;;custom setting

;;
(global-set-key (kbd "<end>") 'end-of-buffer)
(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-;") 'dired-jump)


;;
;;dired use 'a' open in current buffer
(put 'dired-find-alternate-file 'disabled nil)
;; rebind '^' to use the same buffer
(add-hook 'dired-mode-hook
 (lambda ()
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file "..")))
  ; was dired-up-directory
 ))

;; Setting English Font
(set-face-attribute 'default nil :font "-adobe-Source Code Pro-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
;; Chinese Font
;;(set-default-font "Monaco-10")
;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;     (set-fontset-font (frame-parameter nil 'font)
;;                       charset
;;                       (font-spec :family "Microsoft Yahei"
;; 				 :size 12)))
;;指定窗口打开文件
(global-set-key (kbd "<f8>")
    (lambda () (interactive)
               (progn (message "Current windows is assigned.")
                      (setq assigned-window (selected-window))
               )
    )
)

(eval-after-load 'dired
    '(define-key dired-mode-map (kbd "\C-o")
        (lambda () (interactive)
                   (let ((target-window assigned-window))
                        (set-window-buffer target-window
                            (find-file-noselect (dired-get-file-for-visit))
                        )
                        (select-window target-window)
                   )
        )
     )
)
(eval-after-load 'dired
  '(define-key dired-mode-map "Y" 'ora-dired-rsync)
  )

;;quick-jump mode
;; (require 'quick-jump)
;; (global-set-key (kbd "C-\\") 'quick-jump-push-marker)
;; (global-set-key (kbd "C-\'") 'quick-jump-go-forward)
;; (global-set-key (kbd "C-;") 'quick-jump-go-back)
;; (global-set-key (kbd "C-|") 'quick-jump-clear-all-marker)

;;auto split windows
(add-hook 'window-setup-hook (lambda () (split-window-horizontally)
                               (select-window-2)
                               (split-window-vertically) )
          )

;;
;(require 'nyan-mode)



;; smarter-move-of-beginning-of-line
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

;; smex
(defun my-smex ()
   (interactive)
   (flx-ido-mode -1) ;; turn off flx-ido temporarily
   (smex)
   (flx-ido-mode 1) ;; turn on flx-ido
   )
(global-set-key (kbd "M-x") 'my-smex)


;; regex-tool
(custom-set-variables `(regex-tool-backend 'perl))




;; ediff
(defun ora-ediff-hook ()
  (ediff-setup-keymap)
  (define-key ediff-mode-map "j" 'ediff-next-difference)
  (define-key ediff-mode-map "k" 'ediff-previous-difference))

(add-hook 'ediff-mode-hook 'ora-ediff-hook)
(add-hook 'ediff-after-quit-hook-internal 'winner-undo)


;; modeline
(powerline-default-theme)

(avy-setup-default)

;;; abo-abo: Using rsync in dired
(defun ora-dired-rsync (dest)
  (interactive
   (list
    (expand-file-name
     (read-file-name
      "Rsync to:"
      (dired-dwim-target-directory)))))
  ;; store all selected files into "files" list
  (let ((files (dired-get-marked-files
                nil current-prefix-arg))
        ;; the rsync command
        (tmtxt/rsync-command
         "rsync -arvz --progress "))
    ;; add all selected file names as arguments
    ;; to the rsync command
    (dolist (file files)
      (setq tmtxt/rsync-command
            (concat tmtxt/rsync-command
                    (shell-quote-argument file)
                    " ")))
    ;; append the destination
    (setq tmtxt/rsync-command
          (concat tmtxt/rsync-command
                  (shell-quote-argument dest)))
    ;; run the async shell command
    (async-shell-command tmtxt/rsync-command "*rsync*")
    ;; finally, switch to that window
    (other-window 1)))



;;
(setq avy-timeout-seconds 1)

;; rename *Async Shell Command* with command line
(defadvice shell-command (after shell-in-new-buffer (command &optional output-buffer error-buffer))
  (when (get-buffer "*Async Shell Command*")
    (with-current-buffer "*Async Shell Command*"
      (rename-buffer (concat ">> " command)))))
(ad-activate 'shell-command)
