;; @see http://stackoverflow.com/questions/2886184/copy-paste-in-emacs-ansi-term-shell/2886539#2886539
(defun ash-term-hooks ()
  ;; dabbrev-expand in term
  (define-key term-raw-escape-map "/"
    (lambda ()
      (interactive)
      (let ((beg (point)))
        (dabbrev-expand nil)
        (kill-region beg (point)))
      (term-send-raw-string (substring-no-properties (current-kill 0)))))
  ;; yank in term (bound to C-c C-y)
  (define-key term-raw-escape-map "\C-y"
    (lambda ()
      (interactive)
      (term-send-raw-string (current-kill 0)))))
(add-hook 'term-mode-hook 'ash-term-hooks)

;; {{ @see http://emacs-journey.blogspot.com.au/2012/06/improving-ansi-term.html
;; kill the buffer when terminal is exited
(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

;; I use tcsh
(defvar my-term-shell "/bin/tcsh")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

;; utf8
(defun my-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'my-term-use-utf8)

;; }}

;; {{ multi-term
(defun last-term-buffer (l)
  "Return most recently used term buffer."
  (when l
	(if (eq 'term-mode (with-current-buffer (car l) major-mode))
	    (car l) (last-term-buffer (cdr l)))))

(setq multi-term-switch-after-close nil)

(defun get-term ()
  "Switch to the term buffer last used, or create a new one if
    none exists, or if the current buffer is already a term."
  (interactive)
  (let ((b (last-term-buffer (buffer-list))))
	(if (or (not b) (eq 'term-mode major-mode))
	    (multi-term)
	  (switch-to-buffer b))))

(define-key global-map (kbd "C-x e") 'multi-term)
(eval-after-load 'dired
  '(define-key dired-mode-map (kbd "`") 'multi-term)
  )


(defun term-send-kill-whole-line ()
  "Kill whole line in term mode."
  (interactive)
  (term-send-raw-string "\C-a")
  (term-send-raw-string "\C-k"))

(defun term-send-kill-line ()
  "Kill line in term mode."
  (interactive)
  (term-send-raw-string "\C-k"))

(setq multi-term-program "/bin/tcsh")
(setq term-unbind-key-list '("C-x" "M-x" "C-c"))

(setq term-bind-key-alist
      '(("C-c C-c" . term-interrupt-subjob)
        ("C-c C-e" . term-send-esc)
        ("C-p" . term-send-up)
        ("C-n" . term-send-down)
        ("C-s" . isearch-forward)
        ("C-r" . term-send-reverse-search-history)
        ("C-m" . term-send-raw)
        ("C-k" . term-send-kill-whole-line)
        ("C-y" . term-paste)
        ("C-_" . term-send-raw)
        ("M-f" . term-send-forward-word)
        ("M-b" . term-send-backward-word)
        ("M-K" . term-send-kill-line)
        ("M-p" . previous-line)
        ("M-n" . next-line)
        ("M-y" . yank-pop)
        ("M-." . term-send-raw-meta)
        ("C-;" . dired-jump)
        ))

;;Often I want to rename the terminal buffer so that it's not just *terminal<#>*.
;;We can introduce a function to rename the buffer to be in the form *term* buffer-name.
(defun rename-term (name)
  (interactive "s")
  (rename-buffer (concat "*term< " name " >")))

;; }}

(provide 'init-term-mode)
