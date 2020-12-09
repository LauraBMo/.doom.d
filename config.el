;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Laura Brustenga i Moncusí"
      user-mail-address "laurea987@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; (setq doom-theme 'doom-solarized-ligh)
;; (setq custom-theme-directory "~/.doom.d/local/themes/")
;; (load-theme 'tsdh-dark-brusten t)
;; (load-theme 'darktooth t)

;; (load-theme 'doom-spacegrey t)
;; (load-theme 'doom-moonlight t)
;; (load-theme 'doom-miramare t)

;; (load-theme 'doom-solarized-light t)

;; (load-theme 'doom-zenburn t)

;; (load-theme 'doom-city-lights t)
;; (load-theme 'doom-monokai-classic t)
;; (load-theme 'doom-fairy-floss t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/Org")

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; The following code is inspirated by
;; http://endlessparentheses.com/init-org-Without-org-mode.html
(defvar endless/init.org-message-depth 5
  "What depth of init.org headers to message at startup.")

;; I rename the obious variable to not interfer with possible updates of org-babel.
;; I copy it here to avoid loading org-babel ;)
(defvar brust-endless/org-babel-src-block-regexp
  (concat
   ;; (1) indentation                 (2) lang
   "^\\([ \t]*\\)#\\+begin_src[ \t]+\\([^ \f\t\n\r\v]+\\)[ \t]*"
   ;; (3) switches
   "\\([^\":\n]*\"[^\"\n*]*\"[^\":\n]*\\|[^\":\n]*\\)"
   ;; (4) header arguments
   "\\([^\n]*\\)\n"
   ;; (5) body
   "\\([^\000]*?\n\\)??[ \t]*#\\+end_src")
  "Regexp used to identify code blocks.")

(defvar brust-endless/org-eblocks-lang
  '("elisp"
    "emacs-lisp")
  "List of strings for Elisp language")

(defun brust-endless/org-eval-eblocks (µcode &optional µinit µfile-p µheader-depth µmessage-depth)
  "Eval the SRC blocks of elisp code in µcode which is the name of a file or a string where are the blocks.
µfile-p has to be t if µcode is a file and nil otherwise.
When µcode is a file, if µinit is nil eval whole file, if it is a string, eval just that header and µheader-depth has to be its depth (nil means 1).
Subtrees under a COMMENTed header are not evaluated."
  (or µheader-depth (setq µheader-depth 1))
  (or µmessage-depth (setq µmessage-depth endless/init.org-message-depth))
  (with-temp-buffer
    (insert
     (if µfile-p
         (brust-endless/org-eval-eblocks-get-code µcode µinit µfile-p µheader-depth)
       µcode))
    (brust-endless/org-eval-eblocks-delete-commented-subtrees)
    (goto-char (point-min))
    (let (pheader neblock)
      (while (not (eobp))
        (cond
         ((looking-at "^\\(\\*+\\) \\(.*\\)$")
          (setq pheader (match-string 2)
                neblock 1)
          (if (< (- (match-end 1) (match-beginning 1))
                 µmessage-depth)
              (message "%s" (match-string 0))))
         ((looking-at brust-endless/org-babel-src-block-regexp)
          (if (memq (match-string 2) brust-endless/org-eblocks-lang)
              (goto-char (match-end 5))
            (eval-region (match-beginning 5)
                         (match-end 5))
            (message "%s :: %d" pheader neblock)
            (setq neblock (1+ neblock)))))
        (forward-line))
      (message "=========== ================================== ===========")
      (message "=========== !! Be happy, everything is load !! ===========")
      (message "=========== ================================== ==========="))))

(defun brust-endless/org-eval-eblocks-delete-commented-subtrees nil
  (interactive)
  (goto-char (point-min))
  (let ((case-fold-search nil)
        beg end
        hdepth)
    (while (re-search-forward "^\\(\\*+\\) COMMENT .*$" nil t)
      (setq beg (match-beginning 0)
            hdepth (- (match-end 1) (match-beginning 1))
            end (if (re-search-forward (format "^\\*\\{1,%d\\} " hdepth) nil t)
                    (match-beginning 0)
                  (point-max)))
      (delete-region beg end)
      (goto-char beg))))

(defun brust-endless/org-eval-eblocks-get-code (µcode &optional µinit µfile-p µheader-depth)
  (with-temp-buffer
    (insert-file-contents µcode)
    (if (not µinit) (buffer-string)
      (goto-char (point-min))
      (let ((beg
             (if (re-search-forward
                  (format (concat
                           "^\\*\\{%d\\}"
                           "\\( +\\| +COMMENT +\\)"
                           "\\(\\|TODO \\|DONE \\|CANCELED \\|DOING \\)%s")
                          µheader-depth µinit)
                  nil t)
                 (match-beginning 0)
               (user-error "Header not found")))
            (end
             (if (re-search-forward (format "^\\*\\{1,%d\\} " µheader-depth) nil t)
                 (match-beginning 0)
               (point-max))))
        (buffer-substring-no-properties beg end)))))

(when (< 24 emacs-major-version)
  (brust-endless/org-eval-eblocks "~/.doom.d/MyConfig.org" "init.el" t))
