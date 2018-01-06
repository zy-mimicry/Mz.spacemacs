;;; packages.el --- MzMimicry-org layer packages file for Spacemacs.
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
;; added to `MzMimicry-org-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `MzMimicry-org/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `MzMimicry-org/pre-init-PACKAGE' and/or
;;   `MzMimicry-org/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst MzMimicry-org-packages
  '(
    (org :location built-in)
    deft
    )

  "The list of Lisp packages required by the MzMimicry-org layer.

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

(defun MzMimicry-org/post-init-org ()

  ;; define the refile targets
  (setq org-agenda-file-gtd (expand-file-name "gtd.org" org-agenda-dir))
  (setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
  (setq org-agenda-file-journal (expand-file-name "journal.org" org-agenda-dir))
  (setq org-agenda-file-code-snippet (expand-file-name "snippet.org" org-agenda-dir))
  (setq org-agenda-file-daily-english (expand-file-name "english.org" org-agenda-dir))
  (setq org-agenda-files (list org-agenda-dir))

  (with-eval-after-load 'org-agenda
    (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro)
    (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
      "." 'spacemacs/org-agenda-transient-state/body)
    )
  ;; the %i would copy the selected text into the template
  ;;http://www.howardism.org/Technical/Emacs/journaling-org.html
  ;;add multi-file journal
  (setq org-capture-templates
        '(
          ;; -----------------------------Just for work
          ("w" "Work.[#A]" entry (file+headline org-agenda-file-gtd "Linux-Android")
           "* TODO [#A] %?\n  %i\n %U"
           :empty-lines 1)
          ("t" "Todo.[#B]" entry (file+headline org-agenda-file-gtd "Workspace-Just-Do")
           "* TODO [#B] %?\n  %i\n"
           :empty-lines 1)
          ;; -----------------------------Just for life
          ("b" "Blog Ideas." entry (file+headline org-agenda-file-note "Blog Ideas")
           "* TODO [#B] %?\n  %i\n Date: %U"
           :empty-lines 1)
          ("l" "Links. " entry (file+headline org-agenda-file-note "Quick notes")
           "* TODO [#B] %?\n  %i\n Links: %a \n Date: %U"
           ;; ----------------------------Just for study
           :empty-lines 1)
          ("e" "English." entry (file+headline org-agenda-file-daily-english "Quick notes")
           "* TODO [C] %?\n \n %U"
           :empty-lines 1)
          ("s" "Code Snippet." entry (file org-agenda-file-code-snippet)
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          ("j" "Journal Entry." entry (file+datetree org-agenda-file-journal)
           "* %?"
           :empty-lines 1)))

  ;;An entry without a cookie is treated just like priority ' B '.
  ;;So when create new task, they are default 重要且紧急
  (setq org-agenda-custom-commands
        '(
          ("b" "Blog" tags-todo "Mzblog")
          ("l" "Links" tags-todo "Mzlink")
          ;; work
          ("w" . "Mz.Org - 工作任务安排")
          ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
          ("wb" "重要且不紧急的任务" tags-todo "-Weekly-Monthly-Daily+PRIORITY=\"B\"")
          ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
          ;; project for yourself
          ("p" . "M.Org - 个人项目安排")
          ("pw" tags-todo "PROJECT+WORK+hCATEGORY=\"linux\"")
          ("pl" tags-todo "PROJECT+DREAM+CATEGORY=\"project\"")
          ("W" "Weekly Review"
           ((stuck "") ;; review stuck projects as designated by org-stuck-projects
            (tags-todo "project") ;; review all projects (assuming you use todo keywords to designate projects)

            )))))

(defun MzMimicry-org/post-init-deft ()
  (progn
    (setq deft-extensions '("org"))
    (setq deft-directory "~/Mz.Org.com/Mz")
    (setq deft-recursive t)
    (global-set-key [f8] 'deft)
    (setq deft-use-filter-string-for-filename t)
    ))

;;; packages.el ends here
