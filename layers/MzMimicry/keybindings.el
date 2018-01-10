;; Keybindings
;; Please use `M-x help' for you!

(defun mimicry/as-vim-control-u ()
  "Just like vim's C-u in insert mode.
Note that: Just delete to this line , I think it's useful."
  (interactive)
  (progn
    (kill-region (point) (progn
                           (beginning-of-line) (point)))))
(define-key evil-insert-state-map (kbd "C-u") 'mimicry/as-vim-control-u)

(define-key evil-insert-state-map (kbd "C-a") 'move-beginning-of-line)
(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
(define-key evil-normal-state-map (kbd "C-a") 'move-beginning-of-line)
(define-key evil-normal-state-map (kbd "C-e") 'move-end-of-line)

;; paredit depended!
(define-key evil-insert-state-map (kbd "C-h") 'paredit-backward-delete)
(define-key evil-insert-state-map (kbd "C-d") 'paredit-forward-delete)
