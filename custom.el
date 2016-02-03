;;custom setting

;;
(global-set-key (kbd "<end>") 'end-of-buffer)
(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "C-z") 'undo)


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


;; dired-get-size from abo-abo
(defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message
       "Size of all marked files: %s"
       (progn
         (re-search-backward "\\(^[ 0-9.,]+[A-Za-z]+\\).*total$")
         (match-string 1))))))

(define-key dired-mode-map (kbd "z") 'dired-get-size)

;; dired from abo-abo
(setq dired-listing-switches "-lah1v --group-directories-first")

(setq dired-recursive-copies 'always)
;(setq dired-recursive-deletes 'always)  ; careful
(global-set-key (kbd "C-x C-j") 'dired-jump)

;; ediff
(defun ora-ediff-hook ()
  (ediff-setup-keymap)
  (define-key ediff-mode-map "j" 'ediff-next-difference)
  (define-key ediff-mode-map "k" 'ediff-previous-difference))

(add-hook 'ediff-mode-hook 'ora-ediff-hook)
(add-hook 'ediff-after-quit-hook-internal 'winner-undo)

;; find name
(define-key dired-mode-map "F" 'find-name-dired)

;; modeline
(powerline-default-theme)

(avy-setup-default)
