;;; org-link-minor-mode.el -- Enable org-mode bracket links in non-org modes
;;
;; Copyright (C) 2012
;; Author: Sean O'Halpin <sean dot ohalpin at gmail dot com>
;;
;; Enables org-mode bracket links of the form:
;;
;;   [[http://www.bbc.co.uk][BBC]]
;;   [[org-link-minor-mode]]
;;
;; Note that =org-toggle-link-display= will also work when this mode
;; is enabled.
;;

(require 'org)

(define-minor-mode org-link-minor-mode
  "Toggle display of org-mode style bracket links in non-org-mode buffers."
  :lighter " org-link"

  (save-excursion
    (save-match-data
      (let ((org-link-minor-mode-keywords
             (list '(org-activate-bracket-links (0 'org-link t)))))
        (goto-char (point-min))
        (if org-link-minor-mode
            (if (derived-mode-p 'org-mode)
                (progn
                  (message "org-mode doesn't need org-link-minor-mode")
                  (org-link-minor-mode -1)
                  )
              (font-lock-add-keywords nil org-link-minor-mode-keywords t)
              (org-set-local 'org-descriptive-links 'org-descriptive-links)
              (if org-descriptive-links (add-to-invisibility-spec '(org-link)))
              (org-set-local 'font-lock-unfontify-region-function
                             'org-unfontify-region)
              (org-restart-font-lock)
              )
          (unless (derived-mode-p 'org-mode)
            (progn
              (font-lock-remove-keywords nil org-link-minor-mode-keywords)
              (org-remove-from-invisibility-spec '(org-link))
              (while (re-search-forward org-bracket-link-regexp nil t)
                (with-silent-modifications
                  (org-unfontify-region (match-beginning 0) (match-end 0))
                  )
                )
              (org-restart-font-lock)
              )
            )
          )
        )
      )
    )
  )

(provide 'org-link-minor-mode)
