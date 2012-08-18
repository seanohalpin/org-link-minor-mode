;;; org-link-minor-mode.el -- Enable org-mode links in non-org modes
;;
;; Copyright (C) 2012
;; Author: Sean O'Halpin <sean dot ohalpin at gmail dot com>
;;
;; Enables org-mode links of the form:
;;
;;   http://www.bbc.co.uk
;;   man:emacs
;;   <http://www.bbc.co.uk>
;;   [[http://www.bbc.co.uk][BBC]]
;;   [[org-link-minor-mode]]
;;   [2012-08-18]
;;   <2012-08-18>
;;
;; Note that =org-toggle-link-display= will also work when this mode
;; is enabled.
;;

(require 'org)

(define-minor-mode org-link-minor-mode
  "Toggle display of org-mode style bracket links in non-org-mode buffers."
  :lighter " org-link"

  (let ((org-link-minor-mode-keywords
         (list
          '(org-activate-angle-links (0 'org-link t))
          '(org-activate-plain-links)
          '(org-activate-bracket-links (0 'org-link t))
          '(org-activate-dates (0 'org-date t))
          ))
        )
    (if org-link-minor-mode
        (if (derived-mode-p 'org-mode)
            (progn
              (message "org-mode doesn't need org-link-minor-mode")
              (org-link-minor-mode -1)
              )
          (font-lock-add-keywords nil org-link-minor-mode-keywords t)
          (kill-local-variable 'org-mouse-map)
          (org-set-local 'org-mouse-map
                         (let ((map (make-sparse-keymap)))
                           (define-key map [return] 'org-open-at-point)
                           (define-key map [tab] 'org-next-link)
                           (define-key map [backtab] 'org-previous-link)
                           (define-key map [mouse-2] 'org-open-at-point)
                           (define-key map [follow-link] 'mouse-face)
                           map)
                         )
          (org-set-local 'org-descriptive-links org-descriptive-links)
          (if org-descriptive-links (add-to-invisibility-spec '(org-link)))
          (org-set-local 'font-lock-unfontify-region-function
                         'org-unfontify-region)
          (org-restart-font-lock)
          )
      (unless (derived-mode-p 'org-mode)
        (font-lock-remove-keywords nil org-link-minor-mode-keywords)
        (org-restart-font-lock)
        (kill-local-variable 'org-descriptive-links)
        (kill-local-variable 'org-mouse-map)
        (kill-local-variable 'font-lock-unfontify-region-function)
        )
      )
    )
  )

(provide 'org-link-minor-mode)
