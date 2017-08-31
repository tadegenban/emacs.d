;;custom setting

;;
(global-set-key (kbd "<end>") 'end-of-buffer)
(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-;") 'dired-jump)
(global-set-key (kbd "C-x k") 'kill-this-buffer)


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
;;Ö¸¶¨´°¿Ú´ò¿ªÎÄ¼þ
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
                                )
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
;; (defun my-smex ()
;;    (interactive)
;;    (flx-ido-mode -1) ;; turn off flx-ido temporarily
;;    (smex)
;;    (flx-ido-mode 1) ;; turn on flx-ido
;;    )
;; (global-set-key (kbd "M-x") 'my-smex)


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
      (rename-buffer (concat ">> " command) 1 ))))
(ad-activate 'shell-command)


(require 'p4)
;; ;; perforce from chenbin
;; ;; {{ perforce utilities
;; (defvar p4-file-to-url '("" "")
;;   "(car p4-file-to-url) is the original file prefix
;; (cadr p4-file-to-url) is the url prefix")

;; ;; (defun p4-generate-cmd (opts)
;; ;;   (format "p4 %s %s"
;; ;;           opts
;; ;;           (replace-regexp-in-string (car p4-file-to-url)
;; ;;                                     (cadr p4-file-to-url)
;; ;;                                     buffer-file-name)))

;; (defun p4-generate-cmd (opts)
;;   (format "p4 %s %s"
;;           opts
;;           buffer-file-name))

;; (defun p4fl ()
;;   "p4 edit current file."
;;   (interactive)
;;   (shell-command (p4-generate-cmd "filelog"))
;;   )


;; (defun p4edit ()
;;   "p4 edit current file."
;;   (interactive)
;;   (shell-command (p4-generate-cmd "edit"))
;;   (read-only-mode -1))

;; (defun p4submit (&optional file-opened)
;;   "p4 submit current file.
;; If FILE-OPENED, current file is still opened."
;;   (interactive "P")
;;   (let* ((msg (read-string "Say (ENTER to abort):"))
;;          (open-opts (if file-opened "-f leaveunchanged+reopen -r" ""))
;;          (full-opts (format "submit -d '%s' %s" msg open-opts)))
;;     ;; (message "(p4-generate-cmd full-opts)=%s" (p4-generate-cmd full-opts))
;;     (if (string= "" msg)
;;         (message "Abort submit.")
;;       (shell-command (p4-generate-cmd full-opts))
;;       (unless file-opened (read-only-mode 1))
;;       (message (format "%s submitted."
;;                        (file-name-nondirectory buffer-file-name))))))

;; (defun p4revert ()
;;   "p4 revert current file."
;;   (interactive)
;;   (shell-command (p4-generate-cmd "revert"))
;;   (read-only-mode 1))
;; ;; }}

;; ;; (defun prog-mode-hook-setup ()
;; ;;   (when (string-match-p "DIR/PROJ1/"
;; ;;                         (if buffer-file-name buffer-file-name ""))
;; ;;     (setq-local p4-file-to-url '("^.*DIR/PROJ1"
;; ;;                                  "//depot/development/DIR/PROJ1"))))
;; ;; (add-hook 'prog-mode-hook prog-mode-hook-setup)

;; find-dired output format
(setq find-ls-option '("-exec ls -ldh {} +" . "-ldh"))

;; spice-mode from https://github.com/snmishra/emacs-netlist-modes/blob/master/spice-mode/spice-mode.el
(require 'spice-mode)

;; pod-mod from https://github.com/renormalist/emacs-pod-mode/blob/master/pod-mode.el
(require 'pod-mode)
(add-to-list 'auto-mode-alist '("\\.pod$" . pod-mode))

;; all-the-icons in dired-mode
;; feels not good 
;;(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; all-the-icons in ivy
;;(all-the-icons-ivy-setup)

;; use ripgrep for counsel-grep
(setq counsel-grep-base-command
 "rg -i -M 120 --no-heading --line-number --color never '%s' %s")

