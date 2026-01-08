;;; brust-line-number.el --- Provides brust line number mode -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024 Laura Brustenga i Moncusí
;;
;; Author: Laura Brustenga i Moncusí <laurea987@gmail.com>
;; Maintainer: Laura Brustenga i Moncusí <laurea987@gmail.com>
;; Created: july 23, 2024
;; Modified: july 23, 2024
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/LauraBMo/brust-line-number
;; Package-Requires: ((emacs "29.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; Minor mode to show the current line number and the total number of lines in buffer.
;; The total number of lines is shown in a humane-readable format.
;;
;;; Code:

(defgroup brust-line-number nil
  "Show current and total number lines."
  :group 'mode-line
  :link '(url-link :tag "Homepage" "https://github.com/LauraBMo/brust-line-number"))

(defcustom brust-line-number-mode-show-total t
  "Show buffer's total number of lines in mode-line."
  :group 'brust-line-number
  :type 'bool)

(defcustom brust-line-number-total-face-height 0.7
  "Height for buffer's total number of lines."
  :group 'brust-line-number
  :type 'number)

;; TODO:
(defface brust-line-number-total-face
  `((t
     :inherit 'shadow
     :height ,brust-line-number-total-face-height))
  "Font face to show the total number of lines in buffer."
  :group 'brust-line-number)

(defface brust-line-number-total-face-highlight
  `((t
     :inherit 'mode-line-highlight
     :height ,brust-line-number-total-face-height))
  "Font face to show the total number of lines in buffer when mouse is on it."
  :group 'brust-line-number)

(defsubst brust-line-number-current-line nil
  "Return string to show current line in mode line."
  (propertize "%l"
              'face (if (doom-modeline--active) 'mode-line 'mode-line-inactive)
              'help-echo "Buffer size mouse-1: Display Line and Column Mode Menu"
              'mouse-face 'mode-line-highlight
              'local-map mode-line-column-line-number-mode-map))

(defsubst brust-line-number-total-lines nil
  "Return string to show the total number of lines in mode line."
  (propertize (concat "/" (brust--number-of-lines-current-buffer))
              'face 'brust-line-number-total-face
              'help-echo "Buffer size mouse-1: Display Line and Column Mode Menu"
              'mouse-face 'brust-line-number-total-face-highlight
              'local-map mode-line-column-line-number-mode-map))

(defsubst brust-line-number-mode--string nil
  "Show current line number and the total number of lines in buffer."
  (concat (brust-mode-line-doom-space)
          (brust-line-number-current-line)
          (when (and brust-line-number-mode-show-total
                     (doom-modeline--active))
                     (brust-line-number-total-lines))
          (brust-mode-line-doom-space)))

;;;###autoload
(define-minor-mode brust-line-number-mode
  "Toggle show current and total number line in the mode line (Brust Line Number).
With a prefix argument ARG, enable it if ARG is positive, and disable it otherwise.
If called from Lisp, enable the mode if ARG is omitted or nil.

Line numbers do not appear for very large buffers and buffers
with very long lines; see variables `line-number-display-limit'
and `line-number-display-limit-width'."
  :init-value t
  :global t
  :group 'brust-line-number
  (or global-mode-string (setq global-mode-string '("")))
  (setq global-mode-string
        (delete '(:eval (brust-line-number-mode--string)) global-mode-string))
  (if brust-line-number-mode
      (unless (member '(:eval (brust-line-number-mode--string)) global-mode-string)
        (setq global-mode-string
              (append global-mode-string '((:eval (brust-line-number-mode--string))))))))


(provide 'brust-line-number)
;;; brust-line-number.el ends here
