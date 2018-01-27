;;; packages.el --- MzMimicry layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: yang <yang@yang-K53SD>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `MzMimicry-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `MzMimicry/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `MzMimicry/pre-init-PACKAGE' and/or
;;   `MzMimicry/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst MzMimicry-packages
  '(
    youdao-dictionary
    deft
    (org :location built-in)
    )
  "The list of Lisp packages required by the MzMimicry layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun MzMimicry/init-youdao-dictionary ()
  (use-package youdao-dicrionary
    :defer t
    :init
    (spacemacs/set-leader-keys "oy" 'youdao-dictionary-search-at-point+)))

(defun MzMimicry/post-init-deft ()
  (use-package deft
    :defer t
    :ensure t
    :init
    (spacemacs/set-leader-keys "odf" 'deft-find-file)
    :config
    (setq deft-extensions '("org"))
    (setq deft-directory deft-dir)
    (setq deft-recursive t)
    (setq deft-file-naming-rules '((noslash . "_")))
    (setq deft-text-mode 'org-mode)
    (setq deft-use-filter-string-for-filename t)
    (setq deft-org-mode-title-prefix t)
    (setq deft-use-filename-as-title nil)
    ;;))

    (setq deft-strip-summary-regexp
          (concat "\\("
                  "[\n\t]" ;; blank
                  "\\|^#\\+[[:upper:]_]+:.*$" ;; org-mode metadata
                  "\\|^#\\+[[:alnum:]_]+:.*$" ;; org-mode metadata
                  "\\)"))

    (defun MzMimicry/deft-new-file-named-advice (orig-fun &rest args)
      (setq name (pop args))
      (setq title name)
      (setq name (concat
                  (downcase
                   (replace-regexp-in-string
                    " " "_" name))))
      (push name args)
      (apply orig-fun args)
      (insert (concat "#+TITLE: " title "\n\n")))

    (advice-add 'deft-new-file-named
                :around #'MzMimicry/deft-new-file-named-advice)))

(defun MzMimicry/post-init-org ()

  (setq org-agenda-file-gtd (expand-file-name "gtd.org" org-agenda-dir))
  (setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
  (setq org-agenda-file-code-snippet (expand-file-name "snippet.org" org-agenda-dir))
  (setq org-agenda-file-daily-english (expand-file-name "english.org" org-agenda-dir))
  (setq org-agenda-files (list org-agenda-dir))
  (with-eval-after-load 'org-agenda
    (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro)
    (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
      "." 'spacemacs/org-agenda-transient-state/body)
    )
  (setq org-capture-templates
        '(
          ("w" "Work.[#A]" entry (file+headline org-agenda-file-gtd "Linux-Android")
           "* TODO [#A] %?\n  %i\n %U"
           :empty-lines 1)
          ("t" "Todo.[#B]" entry (file+headline org-agenda-file-gtd "Workspace-Just-Do")
           "* TODO [#B] %?\n  %i\n"
           :empty-lines 1)
          ("n" "Note Ideas." entry (file+headline org-agenda-file-note "Note Ideas")
           "* TODO [#B] %?\n  %i\n Date: %U"
           :empty-lines 1)
          ("l" "Links. " entry (file+headline org-agenda-file-note "Quick Links")
           "* TODO [#B] %?\n  %i\n Links: %a \n Date: %U"
           :empty-lines 1)
          ("e" "English." entry (file+headline org-agenda-file-daily-english "Quick English")
           "* TODO [C] %?\n \n %U"
           :empty-lines 1)
          ("s" "Code Snippet." entry (file org-agenda-file-code-snippet)
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          )
        )
  ;;An entry without a cookie is treated just like priority ' B '.
  ;;So when create new task, they are default 重要且紧急
  (setq org-agenda-custom-commands
        '(
          ("w" . "Mz.Org - 工作任务安排")
          ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
          ("wb" "重要且不紧急的任务" tags-todo "-Weekly-Monthly-Daily+PRIORITY=\"B\"")
          ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
          ("p" . "Mz.Org - 个人项目安排")
          ("pw" "打算学习的标签" tags-todo "PROJECT+WORK+hCATEGORY=\"mzlinux\"")
          ("pl" "打算开发的项目" tags-todo "PROJECT+DREAM+CATEGORY=\"mzproject\"")
          ("W" "Weekly Review"
           ((stuck "") ;; review stuck projects as designated by org-stuck-projects
            (tags-todo "project") ;; review all projects (assuming you use todo keywords to designate projects)

            )))))

;;; packages.el ends here
