;; Use cperl-mode instead of the default perl-mode
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . perl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . perl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . perl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . perl-mode))
(add-to-list 'auto-mode-alist '("\\.t" . perl-mode))
(add-hook 'perl-mode-hook 'flymake-mode)

(provide 'init-cperl-mode)
