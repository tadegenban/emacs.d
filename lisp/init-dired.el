;; not need dired-details because dired+ has the feature in emacs24.4 or later
;;(require 'dired-details)
;;(dired-details-install)

;; search file name only when focus is over file
(setq dired-isearch-filenames 'dwim)

(defun diredext-exec-git-command-in-shell (command &optional arg file-list)
  "Run a shell command `git COMMAND`' on the marked files.
if no files marked, always operate on current line in dired-mode
"
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg)))
     (list
      ;; Want to give feedback whether this file or marked files are used:
      (dired-read-shell-command "git command on %s: " current-prefix-arg files)
      current-prefix-arg
      files)))
  (unless (string-match "[*?][ \t]*\\'" command)
    (setq command (concat command " *")))
  (setq command (concat "git " command))
  (dired-do-shell-command command arg file-list)
  (message command))

;; @see http://blog.twonegatives.com/post/19292622546/dired-dwim-target-is-j00-j00-magic
;; op open two new dired buffers side-by-side and give your new-found automagic power a whirl.
;; Now combine that with a nice window configuration stored in a register and you’ve got a pretty slick work flow.
(setq dired-dwim-target t)

(eval-after-load 'dired
  '(progn
     ;;(setq-default dired-details-hidden-string "")
     ;;(define-key dired-mode-map "(" 'dired-details-toggle)
     ;;(define-key dired-mode-map ")" 'dired-details-toggle)

     (define-key dired-mode-map "/" 'dired-isearch-filenames)
     (define-key dired-mode-map "\\" 'diredext-exec-git-command-in-shell)
     (define-key dired-mode-map (kbd "SPC") 'avy-goto-word-or-subword-1)

     (require 'dired+)
     ;; dired from abo-abo
     (setq dired-listing-switches "-lah1v --group-directories-first")

     (setq dired-recursive-copies 'always)
     (setq dired-recursive-deletes 'always)
     (global-set-key (kbd "C-x C-j") 'dired-jump)

     ;; find name
     (define-key dired-mode-map "F" 'find-name-dired)

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



     (define-key dired-mode-map [mouse-2] 'dired-find-file)
     (dolist (file `(((if *unix* "zathura" "open") "pdf" "dvi" "pdf.gz" "ps" "eps")
                     ("unrar x" "rar")
                     ((if *unix* "mplayer -stop-xscreensaver" "mplayer")  "avi" "mpg" "rmvb" "rm" "flv" "wmv" "mkv" "mp4" "m4v" "webm")
                     ("mplayer -playlist" "list" "pls")
                     ((if *unix* "feh" "open") "gif" "jpeg" "jpg" "tif" "png" )
                     ("7z x" "7z")
                     ("djview" "djvu")
                     ("firefox" "xml" "xhtml" "html" "htm" "mht")))
       (add-to-list 'dired-guess-shell-alist-default
                    (list (concat "\\." (regexp-opt (cdr file) t) "$")
                          (car file))))
     ))

(provide 'init-dired)
