(defun zy-mimicry/find-file-from-notes-project ()
  (interactive)
  (progn
    (cd note-dir)
    (helm-projectile)))

(defun zy-mimicry/find-keyword-from-notes-project ()
  (interactive)
  (progn
    (cd note-dir)
    (spacemacs/helm-project-smart-do-search)))
