;;; -*- lexical-binding: t; -*-

(setq
 ;; Personal data
 user-full-name "Laura Brustenga i Moncusí"
 user-mail-address "laurea987@gmail.com"

 ;; Scratch buffer
 initial-scratch-message ";; ╔═╗┌─┐┬─┐┌─┐┌┬┐┌─┐┬ ┬\n;; ╚═╗│  ├┬┘├─┤ │ │  ├─┤\n;; ╚═╝└─┘┴└─┴ ┴ ┴ └─┘┴ ┴\n"
 ;; doom-scratch-initial-major-mode 'lisp-interaction-mode

 ;; European agenda.
 ;; european-calendar-style t
 calendar-week-start-day 1

 ;; Local Variables Set save all local variable and do not query.
 ;; enable-local-variables :all

 ;; Buffer line numbers
 ;; Line numbers are pretty slow all around. The performance boost of
 ;; disabling them outweighs the utility of always keeping them on.
 display-line-numbers-type nil
 ;; (global-display-line-numbers-mode -1)

 ;; Killing Emacs with no questions
 confirm-kill-emacs nil

 ;; Clipboard save the current (system) clipboard before replacing it with the Emacs' text.
 save-interprogram-paste-before-kill t
 ;; kill-ring-max 50

 ;; More real buffers
 doom-unreal-buffer-functions '(minibufferp)

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
 ;; doom-font (font-spec :family "IBM Plex Mono" :size 16 :weight 'light)
 doom-font (font-spec :family "IBM Plex Mono" :size 16)

 ;; There are two ways to load a theme. Both assume the theme is installed and
 ;; available. You can either set `doom-theme' or manually load a theme with the
 ;; `load-theme' function. This is the default:
 doom-theme 'doom-one
 ;; doom-theme 'doom-sakura-light
 ;; doom-theme 'doom-fairy-floss

 ;; If you use `org' and don't want your org files in the default location below,
 ;; change `org-directory'. It must be set before org loads!
 org-directory "~/Dropbox/Org"

 ;; Visual fill mode
 ;; It is like visual line mode but breaks the lines at =fill-column=.
 ;; For visual-fill-mode see https://github.com/hlissner/doom-emacs/pull/1906/files
 +word-wrap-extra-indent 'single
 )

(setq +doom-dashboard-menu-sections
      '(
        ;; ("Load workspace"
        ;;  :icon
        ;;  (all-the-icons-octicon "rocket" :face 'doom-dashboard-menu-title)
        ;;  :action +workspace/load)
        ;; ("Open file in Dropbox"
        ;;  :icon
        ;;  (all-the-icons-octicon "rocket" :face 'doom-dashboard-menu-title)
        ;;  :action +workspace/load)
        ("Open my org"
         :icon
         (all-the-icons-fileicon "org" :face 'doom-dashboard-menu-title)
         :when (file-exists-p (expand-file-name "~/Dropbox/Org/my.org"))
         :action brust-open-my-org)
        ;; :action (lambda nil (open-file (expand-file-name "~/Dropbox/Org/my.org"))))
        ("Email"
         :icon (all-the-icons-octicon "mail" :face 'font-lock-keyword-face)
         :action mu4e)
        ;; ("Open register" :icon
        ;;  (all-the-icons-octicon "bookmark" :face 'doom-dashboard-menu-title)
        ;;  :action jump-to-register)
        ;; ("Jump to bookmark"
        ;;  :icon (all-the-icons-octicon "bookmark" :face 'doom-dashboard-menu-title)
        ;;  :action bookmark-jump)
        ("Open org-agenda"
         :icon
         (all-the-icons-octicon "calendar" :face 'doom-dashboard-menu-title)
         :when (fboundp 'org-agenda)
         :action org-agenda)
        ;; ("Reload last session"
        ;;  :icon
        ;;  (all-the-icons-octicon "history" :face 'doom-dashboard-menu-title)
        ;;  :when (file-exists-p (expand-file-name persp-auto-save-fname persp-save-dir))
        ;;  :face
        ;;  (:inherit
        ;;   (doom-dashboard-menu-title bold))
        ;;  :action doom/quickload-session)
        ("Open private configuration"
         :icon (all-the-icons-octicon "tools" :face 'doom-dashboard-menu-title)
         :when (file-directory-p doom-private-dir)
         :action doom/open-private-config)
        ;; ("Notes"
        ;;  :icon (all-the-icons-octicon "light-bulb" :face 'font-lock-keyword-face)
        ;;  :action ragone-deft-or-close)
        ;; ("Passwords"
        ;;  :icon (all-the-icons-octicon "lock" :face 'font-lock-keyword-face)
        ;;  :action pass)
        ;; ("IRC"
        ;;  :icon (all-the-icons-faicon "comments" :face 'font-lock-keyword-face)
        ;;  :action =irc)))
        ))

(setq +lookup-provider-url-alist
      '(;; ("Doom Emacs issues" "https://github.com/hlissner/doom-emacs/issues?q=is%%3Aissue+%s")
        ("Google"            +lookup--online-backend-google "https://google.com/search?q=%s")
        ("Wikipedia"         "https://wikipedia.org/search-redirect.php?language=en&go=Go&search=%s")
        ("Thesaurus"         "https://www.thesaurus.com/browse/%s")
        ("Singular Manual"   "https://www.google.com/search?q=site:www.singular.uni-kl.de+%s")
        ;; ("Project Gutenberg" "http://www.gutenberg.org/ebooks/search/?query=%s")
        ("DuckDuckGo"        +lookup--online-backend-duckduckgo "https://duckduckgo.com/?q=%s")
        ("DevDocs.io"        "https://devdocs.io/#q=%s")
        ("StackOverflow"     "https://stackoverflow.com/search?q=%s")
        ("Github"            "https://github.com/search?ref=simplesearch&q=%s")
        ("Youtube"           "https://youtube.com/results?aq=f&oq=&search_query=%s")
        ("Wolfram alpha"     "https://wolframalpha.com/input/?i=%s")
        ("Google images"     "https://www.google.com/images?q=%s")
        ("Google maps"       "https://maps.google.com/maps?q=%s")
        ))

(add-hook! 'emacs-startup-hook (delete-selection-mode 1))
;; (setq delete-selection-save-to-register 'kill-ring)

(put 'erase-buffer 'disabled nil)

(setq column-number-mode nil
      size-indication-mode nil
      ;; doom-modeline-buffer-encoding nil
      line-number-mode nil)

(make-face 'mode-line-top-line-number)

(set-face-attribute
 'mode-line-top-line-number nil
 :inherit 'mode-line
 :foreground "gray60" :height 0.7)

(defsubst doom-modeline-spc nil
  "Text style with whitespace."
  (propertize " " 'face (if (doom-modeline--active)
                            'mode-line
                          'mode-line-inactive)))

(defsubst brust-line-number-mode--string nil
  "Show current line/buffer total number of lines."
  (concat (doom-modeline-spc)
          ;; (:propertize "\[" face mode-line-bars-face)
          (propertize "%l"
                      'face (if (doom-modeline--active) 'mode-line 'mode-line-inactive)
                      'help-echo "Buffer size mouse-1: Display Line and Column Mode Menu"
                      'mouse-face 'mode-line-highlight
                      'local-map mode-line-column-line-number-mode-map)
          (propertize (if brust-line-number-mode-show-total
                          (concat "/" (brust--number-of-lines-current-buffer))
                        "")
                      'face 'mode-line-top-line-number
                      'help-echo "Buffer size mouse-1: Display Line and Column Mode Menu"
                      ;; 'mouse-face 'mode-line-highlight
                      'local-map mode-line-column-line-number-mode-map)
          (doom-modeline-spc)))

(defgroup brust-line-number-mode nil "Show current and total number line.")

(defcustom brust-line-number-mode-show-total t
  "Show buffer's total number of lines in mode-line"
  :group 'brust-line-number-mode
  :type 'bool)

(define-minor-mode brust-line-number-mode
  "Toggle show current and total number line in the mode line (Brust Line Number mode).
With a prefix argument ARG, enable it if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

Line numbers do not appear for very large buffers and buffers
with very long lines; see variables `line-number-display-limit'
and `line-number-display-limit-width'."
  :init-value t :global t :group 'brust-line-number-mode
  (or global-mode-string (setq global-mode-string '("")))
  (setq global-mode-string
        (delete '(:eval (brust-line-number-mode--string)) global-mode-string))
  (if brust-line-number-mode
      (unless (member '(:eval (brust-line-number-mode--string)) global-mode-string)
        (setq global-mode-string
              (append global-mode-string '((:eval (brust-line-number-mode--string))))))))

;; (add-hook! 'emacs-startup-hook
;;   (setq global-mode-string '("" (:eval (brust-line-number-mode--string)) display-time-string)))

(add-hook! 'emacs-startup-hook (brust-line-number-mode +1))

(defun brust-kill-date nil
  (interactive)
  (kill-new (format-time-string "%e/%m/%Y" (current-time))))

(defun brust-message-date nil
  (interactive)
  (message (format-time-string "w%Wd%j %A, %e %B %Y, (%e/%m/%Y - %R %Z) -- %s" (current-time))))

(defvar mode-line-display-time-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line mouse-1] #'brust-message-date)
    (define-key map [mode-line mouse-3] #'brust-kill-date)
    map) "\
Keymap to show or kill current date.")

(customize-set-variable 'display-time-string-forms
                        '((propertize (concat " " 12-hours ":" minutes am-pm " ")
                                      'face 'mode-line
                                      'help-echo "Current date: mouse 1 show, mouse 3 kill"
                                      'local-map mode-line-display-time-mode-map)))

(setq display-time-default-load-average nil)

;; Time format
(add-hook! 'emacs-startup-hook (display-time-mode +1))

(after! citar
  (setq
   ;; Use icons
   citar-symbols
   `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green :v-adjust -0.1) . " ")
     (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . " ")
     (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange :v-adjust 0.01) . " "))
   citar-symbol-separator "  "
   ;; My biblio files
   citar-bibliography '("~/Dropbox/bibliography/my.bib")
   citar-library-paths '("~/Dropbox/bibliography/pdf/"
                         "~/Dropbox/bibliography/")
   citar-notes-paths '("~/Dropbox/bibliography/notes.org"))

  (defun brust-citar-title-to-fname (title ext)
    ;; expand-file-name ;; Relative paths work, so why?
    (cl-loop for path in citar-library-paths
             collect (concat path
                             (brust-title-to-fname title)
                             "." ext)))

  (defun brust-citar-title-to-fname-default (title)
    (interactive)
    (car (brust-citar-title-to-fname title "pdf")))

  ;; See citar become in citar.el README.
  (defvar citar-embark-become-map
    (let ((map (make-sparse-keymap)))
      ;; Callee functions
      (define-key map (kbd "p") #'("Insert cite" . citar-insert-citation))
      (define-key map (kbd "f") #'("Open file" . citar-open-library-file))
      map)
    "Citar Embark become keymap."))

(after! (embark citar)
  ;; tell embark about the keymap
  (add-to-list 'embark-become-keymaps #'citar-embark-become-map))

(after! (latex bibtex)
  (add-to-list 'auto-mode-alist '("\\.bib\\'"  . bibtex-mode))
  ;; Spell checking (requires the ispell software)
  ;; (add-hook 'bibtex-mode-hook 'flyspell-mode)

  (setq bibtex-maintain-sorted-entries t ;; to sort bibtex entries with C-c C-c
        bibtex-comma-after-last-field t ;; insert a comma after last field
        ;; Change fields and format
        bibtex-user-optional-fields '(("keywords" "Keywords to describe the entry" "")
                                      ("file" "Link to document file." ":"))
        bibtex-align-at-equal-sign t
        ;; How to format entries
        bibtex-entry-format
        (append '(whitespace
                  realign
                  unify-case
                  last-comma
                  sort-fields)
                (delq! 'required-fields bibtex-entry-format))))

(defun brust-bibtex-link-pdf (&optional title doi)
  "Link pdf to a bib entrie. Download from Sci-Hub if pdf not found."
  (interactive (list
                (bibtex-text-in-field "title")
                (bibtex-text-in-field "doi")))
  (let ((fname (brust-citar-title-to-fname-default title)))
    (unless (bibtex-text-in-field "file")
      (bibtex-beginning-first-field)
      (move-end-of-line 1) (forward-char -1)
      (bibtex-make-field "file")
      (forward-char -1) (insert fname)
      (bibtex-clean-entry))
    (if (file-exists-p fname)
        (find-file fname)
      (scihub doi fname))))

;; See https://github.com/pzorin/bibretrieve
(use-package! bibretrieve
  :commands bibretrieve
  :config
  (setq bibretrieve-prompt-for-bibtex-file nil ;; use defaul bib file
        bibretrieve-backends '(("msn" . 10) ("arxiv" . 5))))

(use-package! biblio
  :config
  (setq biblio-crossref-user-email-address user-mail-address)
  (add-to-list 'biblio-selection-mode-actions-alist
               '("Sci-Hub (download pdf)" . brust-biblio-scihub))
  (map! :map biblio-selection-mode-map
        "j" #'biblio--selection-next
        "k" #'biblio--selection-previous))

(defun brust-biblio-scihub (entry)
  (if-let ((title (biblio-alist-get 'title entry))
           (doi (biblio-alist-get 'doi entry))
           (fname (brust-citar-title-to-fname-default title)))
      (if (file-exists-p fname)
          (find-file fname)
        (scihub doi fname))
    (message "No DOI or Title found for %s" (car entry))))

(defun biblio-zbmath-backend (command &rest args)
  "A biblio.el backend for searching the zbmath.org database.

COMMAND is a symbol specifying the backend command to execute.
ARGS are the arguments for the command."
  (pcase command
    (`name "ZBMath")
    (`prompt "ZBMath search: ")
    (`url (format "https://www.zbmath.org/search/?q=%s" (url-encode-url (car args))))
    (`parse-buffer
     (let ((results '()))
       (with-current-buffer (current-buffer)
         (goto-char (point-min))
         (while (re-search-forward "class=\"title\"><a href=\"/api/v2/entry/\\([0-9]+\\)\">\\(.*?\\)</a>" nil t)
           (let* ((id (match-string-no-properties 1))
                  (title (match-string-no-properties 2))
                  (metadata `((id . ,id)
                              (title . ,title))))
             (push metadata results))))
       results))
    (`forward-bibtex
     (let ((metadata (car args))
           (forward-to (cadr args)))
       (let ((bibtex (biblio-zbmath-get-bibtex metadata)))
         (funcall forward-to bibtex))))
    (_ (error "Invalid command"))))

(defun biblio-zbmath-get-bibtex (metadata)
  "Retrieve the BibTeX record for the paper with METADATA from zbmath.org.

METADATA is a alist of metadata for the paper."
  (let ((id (alist-get 'id metadata)))
    (with-temp-buffer
      (url-insert-file-contents (format "https://www.zbmath.org/api/v2/entry/%s/bibtex" id))
      (buffer-string))))

(add-hook 'biblio-init-hook #'biblio-zbmath-backend)

(use-package! scihub
  :commands scihub
  :config
  (setq scihub-download-directory "~/Dropbox/bibliography/pdf/"
        scihub-open-after-download t
        scihub-fetch-domain 'scihub-fetch-domains-lovescihub
        scihub-homepage "https://sci-hub.se"))

(map! :after citar :map citar-map
      :desc "Sci-Hub" "s" #'brust-citar-scihub)

(defun brust-citar-scihub (key-entry)
  "Download DOI associated with the KEY-ENTRY from Sci-Hub.

With prefix, rebuild the cache before offering candidates."
  (interactive (list (citar-select-ref
                      :rebuild-cache current-prefix-arg)))
  (if-let ((doi (citar-get-value 'doi (cdr key-entry)))
           (title (citar-get-value 'title (cdr key-entry)))
           (fname (brust-citar-title-to-fname-default title)))
      (progn
        (citar-open-entry key-entry)
        (brust-bibtex-link-pdf title doi))
    (message "No DOI or Title found for %s" (car key-entry))))

;; After calling =citar-insert-cite=, type =C-:= (=embark-act=), =B= (=embark-become=).
(map!
 :after citar
 :map citar-embark-become-map
 ;; bibretrieve.el search bib entries in MathSciNet
 :desc "MathSciNet" "m" #'bibretrieve
 ;; Biblio.el search bib entries on internet
 :desc "ArXiv"      "x" #'biblio-arxiv-lookup
 :desc "CrossRef"   "c" #'biblio-crossref-lookup
 :desc "HAL"        "h" #'biblio-hal-lookup
 :desc "Insert doi" "i" #'biblio-doi-insert-bibtex)

;; https://githubmemory.com/repo/minad/vertico/issues/156
;; (defun my/vertico-insert-or-exit ()
;;   "Insert the candidate if it's a directory, otherwise select it and exit."
;;   (interactive)
;;   (if (and (>= vertico--index 0) ;; We are selecting some candidate
;;            (file-directory-p (vertico--candidate))) ;; and the candidate is a directory
;;       (vertico-insert)
;;     (vertico-exit)))

(map!
 "C-:" #'embark-act
 :map minibuffer-mode-map
 ;; Motion: LOWER from keyboard
 ;; "M-j" #'ivy-next-line
 ;; "M-k" #'ivy-previous-line
 ;;
 ;; Finish
 ;; "<right>"  #'ivy-alt-done
 ;; "<right>"  #'my/vertico-insert-or-exit
 ;; ";"   #'ivy-immediate-done
 ;; "<return>" #'vertico-exit-input
 "C-:" #'embark-act
 ;; Current bind  "M-<return>" ;; good enough
 ;;
 ;; History
 ;; Already bind
 ;; "<next>"   #'next-history-element
 ;; "<prior>"  #'previous-history-element
 ;; Old binds
 ;; "M-j"      #'next-history-element
 ;; "M-k"      #'previous-history-element
 ;; "M-j"      #'ivy-next-history-element
 ;; "M-k"      #'ivy-previous-history-element
 ;;
 ;; Embark
 ;; "M-o" #'ivy-dispatching-done
 ;;
 ;; ;; Interaction
 ;; "M-w"      #'ivy-yank-word
 ;; "C-o"      #'hydra-ivy/body
 ;; "C-<"      #'ivy-minibuffer-shrink
 ;; "C->"      #'ivy-minibuffer-grow
 ;; "M-m"      #'ivy-mark
 ;; Security
 ;; "<return>" #'nil
 )

(defun brust-vertico/find-file-in--add-hidden-files-option (orig-fun &rest args)
  (if current-prefix-arg
      (let ((+vertico-consult-fd-args "fdfind --color=never -i -H -I --regex "))
        (apply orig-fun args))
    (apply orig-fun args)))

(advice-add '+vertico/find-file-in :around #'brust-vertico/find-file-in--add-hidden-files-option)
;; (advice-remove '+vertico/find-file-in #'brust-vertico/find-file-in-add-hidden-files-option)

(defun brust-doom-project-find-file--add-hidden-files-option (orig-fun &rest args)
  (and current-prefix-arg
      (+vertico/find-file-in default-directory)
      t))

;; (advice-remove 'doom-project-find-file #'brust-doom-project-find-file--add-hidden-files-option)
;; (advice-add 'doom-project-find-file :around #'brust-doom-project-find-file--add-hidden-files-option)
(advice-add 'doom-project-find-file :before-until #'brust-doom-project-find-file--add-hidden-files-option)

;; +file-templates-dir

;; It is run once when upgrading or syncing doom (when .emacs.d/module/ folder might be modified).
;; cp -r ~/.doom.d/local/templates/* ~/.emacs.d/modules/editor/file-templates/templates
;; alias doom-sync='~/.emacs.d/bin/doom sync && \
;;     cp -r ~/.doom.d/local/templates/* ~/.emacs.d/modules/editor/file-templates/templates && \
;;     echo > Templates sync'
;; alias doom-up='~/.emacs.d/bin/doom upgrade && doom-sync'

(set-file-template! "[.]sing" :trigger "__sing" :mode 'c++-mode)
(set-file-template! "[.]tex"  :trigger "__tex"  :mode 'latex-mode)
(set-file-template! "[.]jl"   :trigger "__jl"   :mode 'julia-mode)

(after! hl-todo
  (setq hl-todo-keyword-faces
        `(
          ("TODO"     . '(warning bold))
          ("DONE"     . "#afd8af")
          ("DOING"    . "#4169e1")
          ("CANCELED" . "#708090")
          ))
  )
;; TODO DONE DOING CANCELED

(after! elfeed
  (setq elfeed-search-filter "@1-week-ago +unread"
        ;; elfeed-search-print-entry-function #'my-search-print-fn
        elfeed-search-print-entry-function #'elfeed-goodies/entry-line-draw
        elfeed-show-entry-delete #'elfeed-goodies/delete-pane
        ;; elfeed-search-date-format '("%y-%m-%d" 10 :left)
        elfeed-search-title-max-width 90)

  (map! :map elfeed-search-mode-map
        :desc "Open entry" :n "SPC" #'elfeed-search-show-entry
        :desc "Download pdf" :n "x" #'robo/elfeed-entry-to-arxiv
        :desc "Biblio" :n "X" #'brust-elfeed-arxiv-send-entry-to-biblio
        )


  ;;        (:map elfeed-show-mode-map
  ;;         :desc "Fetch arXiv paper to the local library" "a" #'robo/elfeed-entry-to-arxiv)))
  (map! :map elfeed-show-mode-map
        :desc "Quit" :n "q" #'elfeed-goodies/delete-pane
        :desc "Open web" :n "o" #'link-hint-open-link
        )

  (add-hook! 'elfeed-search-mode-hook 'elfeed-update))

(defcustom elfeed-goodies/feed-source-column-width 16
  "Width of the feed source column."
  :type 'integer)

(defcustom elfeed-goodies/tag-column-width 24
  "Width of the tags column."
  :type 'integer)

(defun brust-elfeed-get-nth-name (n list)
  (plist-get (nth n list) :name))

(defun concatenate-authors (list)
  "Given AUTHORS-LIST, list of plists; return string of all authors concatenated."
  (concat
   (brust-elfeed-get-nth-name 0 list)
   (if (> (length list) 1) (concat ", " (brust-elfeed-get-nth-name 1 list)))
   (if (> (length list) 2) (concat ", " (brust-elfeed-get-nth-name 2 list)))
   (if (> (length list) 3) " et al")
   "."))

(defun elfeed-goodies/entry-line-draw (entry)
  "Print ENTRY to the buffer."
  (let* (;; Title
         (title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
         (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
         (title-width (- (window-width) 10 elfeed-search-trailing-width))
         ;; (title-width (- (window-width) elfeed-goodies/feed-source-column-width
         ;;                 elfeed-goodies/tag-column-width 4))
         (title-column (elfeed-format-column
                        title (elfeed-clamp
                               elfeed-search-title-min-width
                               title-width
                               title-width)
                        :left))
         ;; Authors
         (authors (concatenate-authors (elfeed-meta entry :authors)))
         (authors-column (elfeed-format-column authors 45 :left))
         (authors-face (if (memq 'unread (elfeed-entry-tags entry))
                           'default
                         'font-lock-comment-face))
         ;; Score (requires elfeed-score.el)
         (entry-score (elfeed-format-column (number-to-string (elfeed-score-scoring-get-score-from-entry entry)) 10 :left))
         ;; Feed
         (feed (elfeed-entry-feed entry))
         (feed-title
          (when feed
            (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
         (feed-column (elfeed-format-column
                       feed-title (elfeed-clamp elfeed-goodies/feed-source-column-width
                                                elfeed-goodies/feed-source-column-width
                                                elfeed-goodies/feed-source-column-width)
                       :left))
         ;; Tags
         (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
         (tags-str (concat "[" (mapconcat 'identity tags ",") "]"))
         (tag-column (elfeed-format-column
                      tags-str (elfeed-clamp (length tags-str)
                                             elfeed-goodies/tag-column-width
                                             elfeed-goodies/tag-column-width)
                      :left)))
    (insert
     (propertize feed-column 'face 'elfeed-search-feed-face) " "
     ;; entry-score  " "
     (propertize entry-score 'face 'elfeed-search-tag-face) " "
     ;; (propertize tag-column 'face 'elfeed-search-tag-face) " "
     (propertize authors-column 'face authors-face 'kbd-help authors) " "
     (propertize title 'face title-faces 'kbd-help title))
    ))

(defun elfeed-goodies/delete-pane ()
  "Delete the *elfeed-entry* split pane."
  (interactive)
  (let* ((buff (get-buffer "*elfeed-entry*"))
         (window (get-buffer-window buff)))
    (kill-buffer buff)
    (delete-window window)))

(use-package! elfeed-score
  :after elfeed
  :config
  (setq
   elfeed-score-rule-stats-file "~/.doom.d/local/elfeed.stats"
   elfeed-score-score-file "~/.doom.d/local/elfeed.score"
   elfeed-score-serde-score-file  "~/.doom.d/local/elfeed.score"
   )
  ;; (setq elfeed-score-serde-score-file nil) ;;
  ;; (elfeed-score-load-score-file "~/.doom.d/local/elfeed.score") ; See the elfeed-score documentation for the score file syntax
  (elfeed-score-enable)
  (map! :map elfeed-search-mode-map
        :desc "Score" :n "=" elfeed-score-map))

(defun brust-elfeed-arxiv-send-entry-to-biblio (entry)
  "Fetch an arXiv paper into the local library from the current elfeed entry."
  (interactive (list (elfeed-search-selected :ignore-region)))
  (require 'elfeed-show)
  (when (elfeed-entry-p entry)
    (when-let* ((link (elfeed-entry-link entry))
                (match-idx (string-match "arxiv.org/abs/\\([0-9.]*\\)" link))
                (matched-arxiv-number (match-string 1 link)))
      (biblio-arxiv-lookup matched-arxiv-number))))

(defun robo/elfeed-entry-to-arxiv (entry)
  "Fetch an arXiv paper into the local library from the current elfeed entry."
  (interactive (list (elfeed-search-selected :ignore-region)))
  (require 'elfeed-show)
  (when (elfeed-entry-p entry)
    (when-let* ((link (elfeed-entry-link entry))
                (match-idx (string-match "arxiv.org/abs/\\([0-9.]*\\)" link))
                (matched-arxiv-number (match-string 1 link))
                (title (elfeed-entry-title entry))
                (fname (brust-citar-title-to-fname-default title)))
      (message "Going to arXiv: %s" matched-arxiv-number)
      (arxiv-get-pdf matched-arxiv-number fname))))

;; From https://github.com/jkitchin/org-ref/blob/cbe9e870a5f488cdfc5e6a3b5478845ea8acdcde/org-ref-arxiv.el#L216
(defun arxiv-get-pdf (arxiv-number pdf)
  "Retrieve a pdf for ARXIV-NUMBER and save it to PDF."
  (interactive
   (list (read-string
          "arxiv: "
          (arxiv-maybe-arxiv-id-from-current-kill))
         (read-string
          "PDF: ")))
  (let ((pdf-url (with-current-buffer
                     (url-retrieve-synchronously
                      (concat
                       "http://arxiv.org/abs/" arxiv-number))
                   ;; <meta name="citation_pdf_url" content="http://arxiv.org/pdf/0801.1144" />
                   (goto-char (point-min))
                   (search-forward-regexp
                    "name=\\\"citation_pdf_url\\\" content=\\\"\\(.*\\)\\\"")
                   (match-string 1))))
    (url-copy-file pdf-url pdf)
    ;; now check if we got a pdf
    (unless (org-ref-pdf-p pdf)
      (delete-file pdf)
      (message "Error downloading arxiv pdf %s" pdf-url))))

;; From https://github.com/jkitchin/org-ref/blob/cbe9e870a5f488cdfc5e6a3b5478845ea8acdcde/org-ref-utils.el#L457
(defun org-ref-pdf-p (filename)
  "Check if FILENAME is PDF file.
From the PDF specification 1.7:
    The first line of a PDF file shall be a header consisting of
    the 5 characters %PDF- followed by a version number of the
    form 1.N, where N is a digit between 0 and 7."
  (let* ((header (with-temp-buffer
                   (set-buffer-multibyte nil)
                   (insert-file-contents-literally filename nil 0 5)
                   (buffer-string)))
         (valid (string-equal (encode-coding-string header 'utf-8) "%PDF-")))
    (if valid
        valid
      (message "Invalid pdf. Header = %s" header)
      nil)))

;; From https://github.com/jkitchin/org-ref/blob/cbe9e870a5f488cdfc5e6a3b5478845ea8acdcde/org-ref-arxiv.el#L153
(defun arxiv-maybe-arxiv-id-from-current-kill ()
  "Try to get an arxiv ID from the current kill."
  (let* ((the-current-kill (ignore-errors (current-kill 0 t)))  ;; nil if empty kill ring
         (arxiv-url-prefix-regexp "^https?://arxiv\\.org/\\(pdf\\|abs\\|format\\)/")
         (arxiv-cite-prefix-regexp "^\\(arXiv\\|arxiv\\):")
         (arxiv-id-old-regexp "[a-z-]+\\(\\.[A-Z]\\{2\\}\\)?/[0-9]\\{5,7\\}") ; Ex: math.GT/0309136
         (arxiv-id-new-regexp "[0-9]\\{4\\}[.][0-9]\\{4,5\\}\\(v[0-9]+\\)?") ; Ex: 1304.4404v2
         (arxiv-id-regexp (concat "\\(" arxiv-id-old-regexp "\\|" arxiv-id-new-regexp "\\)")))
    (cond
     (;; make sure current-kill has something in it
      ;; if current-kill is not a string, return nil
      (not (stringp the-current-kill))
      nil)
     (;; check if current-kill looks like an arxiv ID
      ;; if so, return it
      ;; Ex: 1304.4404v2
      (s-match (concat "^" arxiv-id-regexp) the-current-kill)
      the-current-kill)
     (;; check if current-kill looks like an arxiv cite
      ;; if so, remove the prefix and return
      ;; Ex: arXiv:1304.4404v2 --> 1304.4404v2
      (s-match (concat arxiv-cite-prefix-regexp arxiv-id-regexp "$") the-current-kill)
      (replace-regexp-in-string arxiv-cite-prefix-regexp "" the-current-kill))
     (;; check if current-kill looks like an arxiv url
      ;; if so, remove the url prefix and return
      ;; Ex: https://arxiv.org/abs/1304.4404 --> 1304.4404
      (s-match (concat arxiv-url-prefix-regexp arxiv-id-regexp "$") the-current-kill)
      (replace-regexp-in-string arxiv-url-prefix-regexp "" the-current-kill))
     (;; check if current-kill looks like an arxiv PDF url
      ;; if so, remove the url prefix, the .pdf suffix, and return
      ;; Ex: https://arxiv.org/pdf/1304.4404.pdf --> 1304.4404
      (s-match (concat arxiv-url-prefix-regexp arxiv-id-regexp "\\.pdf$") the-current-kill)
      (replace-regexp-in-string arxiv-url-prefix-regexp "" (substring the-current-kill 0 (- (length the-current-kill) 4))))
     ;; otherwise, return nil
     (t
      nil))))

(add-hook! 'emacs-startup-hook
  (+global-word-wrap-mode +1)
  (add-to-list '+word-wrap-disabled-modes 'emacs-lisp-mode)
  (add-to-list '+word-wrap-visual-modes 'org-mode))

(map!
 ;; s- commands: commands executed several times AND in several distinct modes.
 "s-s"      #'save-buffer
 "s-w"      #'evil-window-next
 ;; "s-c"      #'close-quoted-open-paren-right-or-left-end-of-line
 "s-f"      #'close-quoted-open-paren-right-or-left
 ;; "s-SPC"    #'brust-cycle-whitespace ;; I am used to 'g SPC'
 "s-h"      #'recenter-top-bottom
 ;; "s-f"      #'flyspell-correct-previous ;; Learning to use z=
 ;; s- motion command
 "s-j"      #'evil-scroll-down
 "s-k"      #'evil-scroll-up
 ;; Cycling in kill-ring
 ;; "C-P"      #'brust-evil-paste-pop-backwards ;; see C-n
 "M-p"      #'consult-yank-pop
 ;; :ier "M-i" #'evil-normal-state ;; it was tab-to-tab-stop
 ;; Now I use evil-escape (equivalent to key-chords jk kj) Press them a single key!

 ;; Insert mode
 :i "C-,"   #'+spell/correct
 ;; Normal mode workarounds (keep it to minimum)
 ;; :n "u"     #'emacs-undo ;; now undo works fine
 :nim "C-e" #'doom/forward-to-last-non-comment-or-eol
 :n "q"     #'kill-current-buffer
 :n "Q"     #'mark-whole-buffer ;; was undefined
 ;; TODO Take care of org-mode?
 ;; I move by paragraphs more then by sentences
 :mvn "{"     #'evil-backward-sentence-begin
 :mvn "}"     #'evil-forward-sentence-begin
 :mvn "("     #'evil-backward-paragraph
 :mvn ")"     #'evil-forward-paragraph

 ;; :nvmro "w" #'evil-backward-word-begin
 ;; :nvmro "W" #'evil-backward-WORD-begin
 ;; :n "H"     #'recenter-top-bottom ;; There is no difference with s-h
 ;; More handy TABs (From Hlissner)
 :n [tab] (general-predicate-dispatch nil
            (fboundp 'evil-jump-item)
            #'evil-jump-item)

 :v [tab] (general-predicate-dispatch nil
            (and (bound-and-true-p yas-minor-mode)
                 (or (not (memq (char-after) (list ?\( ?\[ ?\{ ?\} ?\] ?\))))))
            #'yas-insert-snippet
            (fboundp 'evil-jump-item)
            #'evil-jump-item)
 ;; Personal extensions
 ;; "<f2>"  #'brust-correct-prev-spelling
 "<f5>"  #'consult-kmacro
 "<f9>"  #'mu4e
 "<f10>" #'magit-status
 :n "g SPC" #'brust-cycle-whitespace ;; It was unbind
 (:prefix "z"
  :n "j" #'brust-correct-prev-spelling
  :n "k" #'brust-correct-prev-spelling)
 ;; Binding for buffers
 (:map doom-leader-buffer-map
  ;; :desc "Ibuffer"     :n "i" #'+ibuffer/open-for-current-workspace
  :desc "Ibuffer all" :n "i" #'ibuffer)
 (:leader
  :desc "locleader" "SPC" nil ;; Unbind "SPC SPC"
  :desc "Delete other windows" "w 0" #'delete-other-windows
  ;; :desc "Rotate anticlockwise" "w a" #'rotate-frame-anticlockwise
  ;;
  ;; My global bindings of Laura: functions used everywhere but not so often.
  (:prefix ("l" . "BMO")
   :desc "narrow generic"    "n"    #'endless/narrow-or-widen-dwim
   :desc "code screenshot"   "p"    #'screenshot
   :desc "visual rx replace" "%"    #'vr/query-replace
   :desc "macro insert str"  "<f3>" #'kmacro-query-my
   ;; :desc "ispell & abbrev"   "i"    #'endless/ispell-word-then-abbrev
   "1" #'zoom-out ;; enlarge font
   "2" #'zoom-in ;; reduce font
   ))
 )

(defun advice-once (symbol where function &optional props)
  (let* ((name (symbol-name function))
         (fname (intern (concat name "--advice-once"))))
    (fset fname `(lambda (&rest _)
                   "Copy for advice it once."
                   (funcall ',function)
                   (advice-remove ',symbol #',fname)))
    (advice-add symbol where fname props)))

(defun brust-by-five (-function args)
  (funcall-interactively -function (if (numberp args) (* 5 args) 5)))

(defun zoom-in nil
  (interactive)
  (set-face-attribute 'default nil :height (+ (face-attribute 'default :height) 10)))

(defun zoom-out nil
  (interactive)
  (set-face-attribute 'default nil :height (- (face-attribute 'default :height) 10)))

(defconst all-paren-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?{  "(}" table)
    (modify-syntax-entry ?}  "){" table)
    (modify-syntax-entry ?\( "()" table)
    (modify-syntax-entry ?\) ")(" table)
    (modify-syntax-entry ?\[ "(]" table)
    (modify-syntax-entry ?\] ")[" table)
    (modify-syntax-entry ?\\ "'"  table)
    ;; (modify-syntax-entry ?\< "(>" table)
    ;; (modify-syntax-entry ?\> ")<" table)
    table)
  "A syntax table giving all parenthesis parenthesis syntax.")

(defun close-quoted-open-paren (args dir)
  "dir=0 -> right, dir=1 -> left"
  (with-syntax-table all-paren-syntax-table
    (cl-loop repeat args do
             (let* ((i dir)
                    (pos (save-excursion (up-list (1- (* 2 dir))) (point)))
                    (closing (matching-paren (char-after (- pos dir)))))
               (while (eq (char-before (- pos i)) ?\\)
                 (setq i (1+ i)))
               (cl-loop repeat (- i dir) do
                        (progn
                          (unless (or (eolp) (evil-insert-state-p)) (forward-char +1))
                          (insert "\\")
                          ))
               (unless (or (eolp) (evil-insert-state-p)) (forward-char +1))
               (insert closing)
               (backward-char (* dir i)))))
  t)

(defun close-quoted-open-paren-right (&optional args)
  (interactive "P")
  (close-quoted-open-paren (if (numberp args) args 1) 0))

(defun close-all-open-paren-right nil
  (interactive)
  (while (ignore-errors (close-quoted-open-paren-right))))

(defun close-quoted-open-paren-left (&optional args)
  (interactive "P")
  (close-quoted-open-paren (if (numberp args) args 1) 1))

(defun close-all-open-paren-left nil
  (interactive)
  (while (ignore-errors (close-quoted-open-paren-left))))

(defun my-texmathp nil
  (interactive)
  (when (texmathp)
    (let ((pnt (point))
          (p (ignore-errors
               (goto-char (cdr texmathp-why))
               (sp-forward-sexp 1))))
      (goto-char pnt)
      p)))

(defun close-quoted-open-paren-right-or-left (&optional args)
  (interactive "P")
  (or args (setq args 1))
  (cl-loop repeat args do
           (if (and (fboundp 'texmathp)
                    (my-texmathp))
               (unless (and (ignore-errors (close-quoted-open-paren-right))
                            (if (my-texmathp) t (delete-char -2) nil))
                 (unless (and (ignore-errors (close-quoted-open-paren-left))
                              (if (my-texmathp) t (delete-char 2) nil))))
             (unless (ignore-errors (close-quoted-open-paren-right))
               (unless (ignore-errors (close-quoted-open-paren-left)))))))

(defun close-quoted-open-paren-right-or-left-end-of-line (&optional args)
  (interactive "P")
  (when (not (string= (thing-at-point 'char) " ")) (move-end-of-line 1))
  (close-quoted-open-paren-right-or-left args))

(defvar consult-colors-history nil
  "History for `consult-colors-emacs' and `consult-colors-web'.")

;; No longer preloaded in Emacs 28.
(autoload 'list-colors-duplicates "facemenu")
;; No preloaded in consult.el
(autoload 'consult--read "consult")

(defun consult-colors-emacs (color)
  "Show a list of all supported colors for a particular frame.\

You can insert the name (default), or insert or kill the hexadecimal or RGB value of the
selected color (it needs embrack)."
  (interactive
   (list (consult--read (list-colors-duplicates (defined-colors))
                        :prompt "Emacs color: "
                        :require-match t
                        :category 'color
                        :history '(:input consult-colors-history)
                        )))
  (insert color))

;; Adapted from counsel.el to get web colors.
(defun counsel-colors--web-list nil
  "Return list of CSS colors for `counsult-colors-web'."
  (require 'shr-color)
  (sort (mapcar #'downcase (mapcar #'car shr-color-html-colors-alist)) #'string-lessp))

(defun consult-colors-web (color)
  "Show a list of all CSS colors.\

You can insert the name (default), or insert or kill the hexadecimal or RGB value of the
selected color (it needs embrack)."
  (interactive
   (list (consult--read (counsel-colors--web-list)
                        :prompt "Color: "
                        :require-match t
                        :category 'color
                        :history '(:input consult-colors-history)
                        )))
  (insert color))

(defun rounding-numbers (list-of-num decimal-points)
  "Return the list of numbers rounded up to decimal-points."
  (let ((rounding (expt 10 decimal-points)))
    (mapcar (lambda (x) (/ (fround (* rounding x)) rounding)) list-of-num)))

(defun numbers-to-string (list-of-num SEPARATOR)
  "Converts a list of numbers to a string \"num1,num2,num3,...\", where ."
  (mapconcat #'number-to-string list-of-num SEPARATOR))

;; Colors RGB number as string
(defvar color-rgb-round-decimal-points 2 "Number of decimal points to round RGB colors.")
(defvar-local color-rgb-string-separator "," "SEPARATOR between numbers for RGB strings.")

(defun color-name-to-rgb-string (NAME)
  "Return the RGB value of color NAME as string \"num1,num2,num3\", with num between 0 and 1.
Return nil if NAME does not designate a valid color."
  (when-let ((rgb (color-name-to-rgb NAME)))
    (numbers-to-string rgb color-rgb-string-separator)))

(defun color-name-to-round-rgb-string (NAME)
  "Returns the rounded RGB value of color as string \"num1,num2,num3\", with num between 0 and 1.
Return nil if NAME does not designate a valid color."
  (when-let ((rgb (color-name-to-rgb NAME)))
    (numbers-to-string (rounding-numbers rgb color-rgb-round-decimal-points)
                       color-rgb-string-separator)))

;; Adapted from counsel.el to conver color name to hex.
(defun counsel-colors--hex (NAME)
  "Return hexadecimal value of color with NAME.
Return nil if NAME does not designate a valid color."
  (when-let* ((rgb (color-name-to-rgb NAME))
              ;; Sets 2 digits per component.
              (hex (apply #'color-rgb-to-hex (append rgb '(2)))))
    hex))

(after! embark
  (embark-define-keymap embark-consult-color-action-map
    "Keymap for embark actions in the `color' category of marginalia.")

  ;; Kill and insert versions
  (defvar embark-consult-color-functions-alist
    '(((color-name-to-round-rgb-string . "rRGB") . ("r" . "k"))
      ((color-name-to-rgb-string       . "RGB")  . ("R" . "K"))
      ((counsel-colors--hex            . "hex")  . ("h" . "H")))
    "Cons list of ((fun . desc) . (bind_insert . bind_kill)) of functions converting a color name to some value.
Used to define their `insert' and `kill-new' versions for embark actions.")

  ;; Define `insert' versions
  (cl-loop for fun in embark-consult-color-functions-alist do
           ;; (message "dir %s, name %s" (car dirname) (cdr dirname))
           (let* ((sym (caar fun))
                  (bind (cadr fun))
                  (desc (format "Insert %s" (cdar fun)))
                  (newname (intern (format "%s-insert" (symbol-name sym)))))
             ;; `(lambda (color) (insert (apply ',fun (list color))))
             (fset newname `(lambda (color)
                              (insert (,sym color))
                              (pushnew! consult-colors-history color)))
             ;; (define-key 'embark-consult-color-action-map (kbd bind) (cons desc newname))
             (map! :map embark-consult-color-action-map
                   :desc desc bind newname)))

  ;; Define `kill-new' versions
  (cl-loop for fun in embark-consult-color-functions-alist do
           (let* ((sym (caar fun))
                  (bind (cddr fun))
                  (desc (format "Kill %s" (cdar fun)))
                  (newname (intern (format "%s-kill" (symbol-name sym)))))
             ;; `(lambda (color) (kill-new (apply ',fun (list color))))
             (fset newname `(lambda (color)
                              (kill-new (,sym color))
                              (pushnew! consult-colors-history color)))
             ;; (define-key 'embark-consult-color-action-map (kbd bind) (cons desc newname))
             (map! :map embark-consult-color-action-map
                   :desc desc bind newname)))

  (add-to-list 'embark-keymap-alist '(color . embark-consult-color-action-map)))

(defun customize-face-at-point nil
  "Customize face which point is at."
  (interactive)
  (let ((face (get-text-property (point) 'face)))
    (if face
        (customize-face face)
      (message "No face defined at point"))))

(defun brust-return-buffer-substring-advice (orig-fun &rest args)
  "Same as 'delete-region' but returns the deleted string"
  (let ((str (apply 'buffer-substring args)))
    (apply orig-fun args)
    str))

(advice-add 'delete-region :around #'brust-return-buffer-substring-advice)

(defun brust-dcaps-to-scaps nil
  (save-excursion
    (let ((end (point)))
      (and (= -3 (skip-syntax-backward "w"))
           (let (case-fold-search)
             (looking-at-p "\\b[[:upper:]]\\{2\\}[[:lower:]]"))
           (capitalize-region (point) end)))))

(defun dcaps-to-scaps nil
  "Convert word in DOuble CApitals to Single Capitals."
  (interactive)
  (when (= ?w (char-syntax (char-before)))
    (brust-dcaps-to-scaps)))

(defun dcaps-to-scaps-notinmath nil
  "Convert word in DOuble CApitals to Single Capitals."
  (interactive)
  (when (and (= ?w (char-syntax (char-before)))
             (not (texmathp)))
    (brust-dcaps-to-scaps)))

(defun brust-dcaps-to-scaps-notinmath-p nil
  (or (derived-mode-p 'latex-mode)
      (eq major-mode 'org-mode)))

(define-minor-mode dubcaps-mode
  "Toggle `dubcaps-mode'.  Converts words in DOuble CApitals to
Single Capitals as you type."
  :init-value nil
  :lighter ("") ;; String to show in mode-line
  (if dubcaps-mode
      (if (brust-dcaps-to-scaps-notinmath-p)
          (add-hook 'post-self-insert-hook #'dcaps-to-scaps-notinmath nil 'local)
        (add-hook 'post-self-insert-hook #'dcaps-to-scaps nil 'local))
    (remove-hook 'post-self-insert-hook #'dcaps-to-scaps 'local)
    (remove-hook 'post-self-insert-hook #'dcaps-to-scaps-notinmath 'local)))

(add-hook 'text-mode-hook #'dubcaps-mode)

;; The following code is inspirated by
;; http://endlessparentheses.com/init-org-Without-org-mode.html
(defvar endless/init.org-message-depth 5
  "What depth of init.org headers to message at startup.")

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

(defun brust-endless/org-eval-eblocks (µcode &optional µinit µfile-p µheader-depth μfun)
  "Eval the SRC blocks of elisp code in µcode which is the name of a file or a string where are the blocks.
µfile-p has to be t if µcode is a file and nil otherwise.
When µcode is a file, if µinit is nil eval whole file, if it is a string, eval just that header and µheader-depth has to be its depth (nil means 1).
Subtrees under a COMMENTed header are not evaluated."
  (or µheader-depth (setq µheader-depth 1))
  (with-temp-buffer
    (insert
     (if µfile-p
         (brust-endless/org-eval-eblocks-get-code µcode µinit µfile-p µheader-depth)
       µcode))
    (brust-endless/org-eval-eblocks-delete-commented-subtrees)
    (goto-char (point-min))
    (cl-flet ((funeval (or μfun 'eval-region)))
      (let (pheader neblock)
        (while (not (eobp))
          (cond
           ((looking-at "^\\(\\*+\\) \\(.*\\)$")
            (setq pheader (match-string 2)
                  neblock 1)
            (message "%s" (match-string 0)))
           ((looking-at brust-endless/org-babel-src-block-regexp)
            ;; (when (memq (match-string 2) brust-endless/org-eblocks-lang)
            (funeval (match-beginning 5) (match-end 5))
            (message "%s :: %d" pheader neblock)
            (setq neblock (1+ neblock))
            ;; (goto-char (match-end 5))
            ))
          (forward-line +1))))
    (message "=========== ================================== ===========")
    (message "=========== !! Be happy, everything is load !! ===========")
    (message "=========== ================================== ===========")))


(defun brust-eval-track-time (beg end)
  (let ((sec (car (benchmark-run (eval-region beg end)))))
    (message "(sec: %.3f)" sec)))

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

;; (when (< 24 emacs-major-version)
;;   (brust-endless/org-eval-eblocks "~/.doom.d/MyConfig.org" "init.el" t))

(defun brust-evil-insert--to-normal-to-insert-state (&optional ARG)
  (evil-normal-state)
  (evil-insert-state)
  (forward-char 1))

(defun brust-apply-function-line-by-line (FUNCTION &rest ARGS)
  "Executes function FUNCTION, from point-min, and moves forward one line. Repeat until end of buffer."
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (apply FUNCTION ARGS)
      (forward-line +1))))

(defun kmacro-query-my (arg)
  "Prompt for input using minibuffer during kbd macro execution.
   With prefix argument, allows you to select what prompt string to use.
   If the input is non-empty, it is inserted at point."
  (interactive "P")
  (let* ((prompt (if arg (read-from-minibuffer "PROMPT: ") "Input: "))
         (input (minibuffer-with-setup-hook (lambda nil (kbd-macro-query t))
                  (read-from-minibuffer prompt))))
    (unless (string= "" input) (insert input))))

(defun up-slightly (args) (interactive "p") (brust-by-five #'scroll-up args))
(defun down-slightly (args) (interactive "p") (brust-by-five #'scroll-down args))

(defun up-one nil (interactive) (scroll-up 1))
(defun down-one nil (interactive) (scroll-down 1))

(defun up-a-lot nil (interactive) (scroll-up))
(defun down-a-lot nil (interactive) (scroll-down))

(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)

(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

(defun endless/narrow-or-widen-dwim (args)
  "Widen if buffer is narrowed, narrow-dwim otherwise.
  Dwim means: region, org-src-block, org-subtree, or
  defun, whichever applies first. Narrowing to
  org-src-block actually calls `org-edit-src-code'.

  With prefix P, don't widen, just narrow even if buffer
  is already narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p)
              (not args))
         (widen)
         (let ((recenter-redisplay t))
           (recenter nil)))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end))
         (deactivate-mark)
         (goto-char (point-min)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing
         ;; command. Remove this first conditional if
         ;; you don't want it.
         (cond ((ignore-errors (org-edit-special) t))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((and (derived-mode-p 'latex-mode)
              (ignore-errors (LaTeX-narrow-to-environment))))
        ((derived-mode-p 'emacs-lisp-mode)
         (narrow-to-defun))
        (t
         (brust-narrow-to-paragraph))))

(defun brust-open-my-org nil
  (interactive)
  (find-file (expand-file-name (concat org-directory  "/my.org"))))

(defvar brust-math-software-buffers-prompts
  '(("*julia*"    . "^julia>")
    ("*singular*" . "^>"))
  "List of cons with buffer names runing some math software and a regex for its promp string")

(defun brust-math-software-intangify-buffer-text (-regexp beg end)
  "Set cursor-intangible property to all buffer text maching regular expresion `-regexp` between `beg` and  `end`"
  (save-excursion
    (goto-char beg)
    (save-match-data
      (while (re-search-forward -regexp end t)
        (add-text-properties (1- (match-beginning 0)) (match-end 0) '(cursor-intangible t rear-nonsticky nil))))))

(defun brust-math-software-intangify-cursor-on-prompt (beg end length)
  "Set cursor-intangible in math software buffers prompts"
  (let ((-prompt (cdr (assoc (buffer-name) brust-math-software-buffers-prompts))))
    (when -prompt
      (brust-math-software-intangify-buffer-text -prompt beg end))))

(defun brust-math-software-hookfun-to-intangify-prompt nil
  (cursor-intangible-mode 1)
  (add-hook 'after-change-functions #'brust-math-software-intangify-cursor-on-prompt nil t))

(defun brust-correct-prev-spelling nil
  (interactive)
  (save-excursion
    (+spell/previous-error)
    (+spell/correct)))

(defun brust-title-to-fname (title)
  (with-temp-buffer
    (insert (downcase title))
    ;; Remove currly brackets, colon, underscores,...
    (goto-char (point-min))
    (while (re-search-forward "[{}:_$\]+" nil t)
      (replace-match ""))
    ;; Replace white spaces by a dash
    (goto-char (point-min))
    (while (re-search-forward (concat "[" brust-whitespace-regexp " ]+") nil t)
      (replace-match "-"))
    ;; Get the file name
    (buffer-string)))

(defsubst brust--number-of-lines-current-buffer nil
  (let ((n (string-to-number
            (save-excursion
              (goto-char (point-max))
              (format-mode-line "%l")))))
    (s-trim
     (cond
      ((> n 1000000) (format "%7.1fM" (/ n 1000000.0)))
      ((> n 1000) (format "%7.1fk" (/ n 1000.0)))
      ;;((> n 100) (format "%7.1fh" (/ n 100.0)))
      (t (format "%8d" n))))))

(defun brust-vterm--eval-string (string &optional paste-p)
  (with-current-buffer (process-buffer vterm--process)
    (vterm-send-string string paste-p)))

(defun brust-vterm--eval-buffer-substring (beg end &optional paste-p)
  (brust-vterm--eval-string (concat (s-trim (buffer-substring-no-properties beg end)) "\n") paste-p))

(defun brust-vterm--eval-region nil
  (brust-vterm--eval-buffer-substring (region-beginning) (region-end) 1))

(defun brust-vterm--eval-line nil
  (brust-vterm--eval-buffer-substring (line-beginning-position) (line-end-position)))

(defun brust-vterm--link (proc-buffer origin-buffer)
  "Copies the value of the local variable `vterm--process' from buffer `proc-buffer' to buffer `origin-buffer'.
Then, in `origin-buffer' we can use such a process to execute code in terminal via ."
  (save-excursion
    (set-buffer proc-buffer)
    (let ((proc vterm--process))
      (set-buffer origin-buffer)
      (setq-local vterm--process proc))))

(defun brust-vterm--launch-and-link (origin-buffer sufix)
  "Launches a new instance of vterm in buffer `origin-buffer-sufix' and links its process to `origin-buffer'."
  (save-excursion
    (let ((proc-buffer (concat origin-buffer sufix)))
      (vterm-other-window proc-buffer)
      (brust-vterm--link proc-buffer origin-buffer))))

(defvar brust-inline-whitespace-regexp  " \t\v\f")
(defvar brust-whitespace-regexp  " \t\v\f\n")

(defun skip-white-space-forward (&optional point inline-p)
  (interactive)
  (skip-chars-forward (if inline-p
                          brust-inline-whitespace-regexp
                        brust-whitespace-regexp))
  (when point (constrain-to-field nil point))
  (point))

(defun skip-white-space-backward (&optional point inline-p)
  (interactive)
  (skip-chars-backward (if inline-p
                           brust-inline-whitespace-regexp
                         brust-whitespace-regexp))
  (when point (constrain-to-field nil point))
  (point))

(defun delete-white-space-forward (&optional start inline-p)
  (interactive)
  (let ((p0 (point)))
    (delete-region (or start p0) (skip-white-space-forward p0 inline-p))))

(defun delete-white-space-backward (&optional start inline-p)
  (interactive)
  (let ((p0 (point)))
    (delete-region (or start p0) (skip-white-space-backward p0 inline-p))))

(defvar brust-cycle-whitespace--context nil
  "Store context used in consecutive calls to `brust-cycle-whitespace' command.
       The first time `brust-cycle-whitespace' runs, it saves in this variable:
       the original point position, and the original spacing around point.")

(defun brust-cycle-whitespace nil
  (interactive)
  (let* ((p0 (point))
         (beg (skip-white-space-backward p0))
         (end (skip-white-space-forward p0))
         (indent (buffer-substring-no-properties
                  (skip-white-space-backward nil t)
                  end))
         (context (buffer-substring beg end))
         (nline (1- (length (split-string context "\n")))))
    (cond
     ((or (not (equal last-command this-command))
          (not brust-cycle-whitespace--context))
      ;; Special handling for case where there is no space at all.
      (cond ((< beg end)
             (setq brust-cycle-whitespace--context ;;Save for later.
                   (cons p0 context))
             (delete-region beg end)
             (when (and (< (1+ beg) end)   ;; more than one space
                        (< end (point-max))  ;; erase whitespace at eobp
                        (< (point-min) beg)) ;; and at bobp
               (insert
                (cond ((< nline 2) " ")
                      ((< nline 3) (concat "\n" indent))
                      (t (concat "\n\n" indent))))))
            (t ;; indent when it is called without surrounding whitespaces.
             (end-of-line)
             (brust-cycle-whitespace))))
     ;; Final call: (and (equal last-command this-command) (equal beg end))
     ((not (< beg end))
      (insert (cdr brust-cycle-whitespace--context))
      (goto-char (car brust-cycle-whitespace--context))
      (setq cycle-spacing--context nil))
     ;; Intermadiate calls (and (equal last-command this-command) (< beg end))
     (t
      (delete-region beg end)
      (insert
       (cond ((< nline 1) "")
             ((< nline 2) " ")
             ((< nline 3) (concat "\n" indent))
             (t (concat "\n\n" indent))))))))
;; (more-expansions #'(brust-cycle-whitespace)))

(after! org
  (setq
   ;; org-edit-src-auto-save-idle-delay 20
   org-src-window-setup #'current-window
   org-cycle-global-at-bob t
   org-return-follows-link t
   org-hide-leading-stars nil
   org-ellipsis " ↴")
  (add-hook! 'org-mode-hook
    (setq
     org-hide-leading-stars nil
     org-src-window-setup #'current-window))
  (map! :map org-mode-map
        "<" 'brust-org<
        (:localleader
         ;; "SPC" (kbd "C-c C-c")
         :desc "vterm-julia send" "SPC" #'brust-org-mode-vterm-julia-send-region-or-block
         :desc "vterm-julia launch new" "v" #'brust-julia--link-or-launch-and-link-vterm
         :desc "Babel" "B" org-babel-map
         )))

(after! org
  (setq org-agenda-files (quote ("~/Dropbox/Org/" "~/Dropbox/bibliography/notes.org"))
        org-agenda-todo-list-sublevels nil
        org-deadline-warning-days 3
        org-agenda-skip-scheduled-if-done 1
        org-agenda-skip-deadline-if-done 1
        org-agenda-skip-deadline-if-done 1
        org-agenda-custom-commands
        '(("h" "My agenda view"
           ((agenda "")
            (todo))))))

(after! org
  (setq org-latex-listings 'minted
        org-latex-packages-alist '(("" "minted"))
        org-latex-minted-langs '((ess-julia "julia")
                                 (julia-vterm "julia"))
        org-latex-pdf-process
        '("lualatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "lualatex -shell-escape -interaction nonstopmode -output-directory %o %f")
        org-latex-minted-options
        '(("breaklines" "")
          ;; ("escapeinside" "||")
          ("linenos" "")
          ("numbersep" "3pt")
          ("mathescape" "true")
          ;; ("gobble" "2")
          ("frame" "lines")
          ("framesep" "2mm")
          ;; ("fontsize" "\small")
          )))

(after! org
  (setq org-capture-templates
        (append
         org-capture-templates
         `(
           ;; New Email
           ("e" "TODO respond to email"
            entry
            (file+headline "~/Dropbox/Org/my.org" "ToDo Miscellaneous")
            "* TODO %^{Description}\n%A\n%?\n")
           ;; Ledger
           ("l" "Ledger")
           ("lb" "Bank"
            plain
            (file ,(format "~/Dropbox/Org/ledger-%s.dat" (format-time-string "%Y")))
            ,my/org-ledger-card-template
            :empty-lines 1
            :immediate-finish t)
           ("lc" "Cash"
            plain
            (file ,(format "~/Dropbox/Org/ledger-%s.dat" (format-time-string "%Y")))
            ,my/org-ledger-cash-template
            :empty-lines 1
            :immediate-finish t)
           ;; Hugo
           ("h" "Hugo post"
            entry
            ;; It is assumed that below file is present in `org-directory'
            ;; and that it has a "Blog Ideas" heading. It can even be a
            ;; symlink pointing to the actual location of all-posts.org!
            (file+olp "my.org" "Blog Ideas")
            (function org-hugo-new-subtree-post-capture-template))))))

;; Populates only the EXPORT_FILE_NAME property in the inserted headline.
(defun org-hugo-new-subtree-post-capture-template ()
  "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
  (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
         (fname (org-hugo-slug title)))
    (mapconcat #'identity
               `(
                 ,(concat "* TODO " title)
                 ":PROPERTIES:"
                 ,(concat ":EXPORT_FILE_NAME: " fname)
                 ,(concat ":EXPORT_DATE: " date) ;Enter current date and time
                 ":END:"
                 "%?\n")          ;Place the cursor here finally
               "\n")))
;; (defun org-hugo-new-subtree-post-capture-template ()
;;   "Returns `org-capture' template string for new Hugo post.
;; See `org-capture-templates' for more information."
;;   (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
;;          (fname (org-hugo-slug title)))
;;     (mapconcat #'identity
;;                `(
;;                  ,(concat "* TODO " title)
;;                  ":PROPERTIES:"
;;                  ,(concat ":EXPORT_HUGO_BUNDLE: " fname)
;;                  ":EXPORT_FILE_NAME: index"
;;                  ,(concat ":EXPORT_DATE: " date) ;Enter current date and time
;;                  ":END:"
;;                  "%?\n")                ;Place the cursor here finally
;;                "\n")))

(defvar my/org-ledger-card-template
  "%(org-read-date) %^{Payee}
       Expenses:%^{Account}  €%^{Amount}
       Liabilities:DebidCard:Mediolanum"
  "Template for devid card transaction with ledger.")

(defvar my/org-ledger-cash-template
  "%(org-read-date) * %^{Payee}
       Expenses:%^{Account}  €%^{Amount}
       Assets:Cash:Wallet"
  "Template for cash transaction with ledger.")

(after! org
  (setq org-structure-template-alist (delete '("e" . "example") org-structure-template-alist)
        ;; org-structure-template-alist (delete '("j" . "src ess-julia :results output :session *julia* :exports both") org-structure-template-alist)
        ;; org-structure-template-alist (delete '("jj" . "src ess-julia :results output") org-structure-template-alist)
        org-structure-template-alist (delete '("E" . "export") org-structure-template-alist)))

(after! org
  (add-to-list 'org-structure-template-alist
               '("ee" . "src elisp"))
  (add-to-list 'org-structure-template-alist
               '("ep" . "src elisp :tangle packages.el"))
  (add-to-list 'org-structure-template-alist
               '("E" . "example"))
  (add-to-list 'org-structure-template-alist
               '("b" . "src bash"))
  (add-to-list 'org-structure-template-alist
               '("L" . "LaTeX"))
  ;; Shortcut for "normal" session evaluation with verbatim output:
  ;; (add-to-list 'org-structure-template-alist
  ;;              '("jj" . "src julia"))
  (add-to-list 'org-structure-template-alist
               ;; '("j" . "src ess-julia :results output :session *julia* :exports both"))
               '("jj" . "src julia :results output"))
  ;; Shortcut for inline graphical output within a session:
  ;; (add-to-list 'org-structure-template-alist
  ;;              '("jpic" . "src ess-julia :results output graphics file :file FILENAME.png"))
  (add-to-list 'org-structure-template-alist
               '("jvterm" . "src julia-vterm :session"))
  ;; Shortcut for well-formatted org table output within a session:
  (add-to-list 'org-structure-template-alist
               '("jtab" . "src julia :results value table :colnames yes")))

(defun brust-org< nil
  "Self insert command or expand org-insert-structure-template"
  (interactive)
  (if (or (region-active-p) (looking-back "^"))
      (progn
        (call-interactively 'org-insert-structure-template)
        (insert "\n")
        (backward-char 1))
    (self-insert-command 1)))

(after! org
  (defun brust-org-mode-pretty-headers (keysymbol)
    (let ((key (car keysymbol))
          (symbol (cdr keysymbol)))
      `(,(format "^\\(\\*\\{%s\\}\\) " key)
        (1
         (progn (compose-region (match-beginning 1) (match-end 1) ,symbol) nil)
         append))))

  (font-lock-add-keywords            ;; A bit silly but my headers are now
   'org-mode                         ;; shorter, and that is nice canceled
   (mapcar #'brust-org-mode-pretty-headers
           '(("1" . "☰")
             ("2" . "☱")
             ("3" . "☲")
             ("4" . "☳")
             ("5" . "☴")
             ("6" . "☵")
             ("7" . "☶")
             ("8," . "☷")))))

(defun brust-org-mode-vterm-julia-send-region-or-line nil
  (interactive)
  (org-babel-when-in-src-block
   (brust-julia--ensure-vterm-process-alive)
   (if (use-region-p)
       (brust-vterm--eval-region)
     (brust-vterm--eval-line))))

(defun brust-org-mode-vterm-julia--eval-block nil
  (org-babel-when-in-src-block
   ;; Format block-info = (language body arguments switches name start coderef)
   (let* ((block-info (org-babel-get-src-block-info t))
          ;; (lang (car block-info))
          (body (nth 1 block-info)))
     (brust-vterm--eval-string (concat body "\n") 1))))

(defun brust-org-mode-vterm-julia-send-region-or-block nil
  (interactive)
  (brust-julia--ensure-vterm-process-alive)
  (cond ((use-region-p) (brust-vterm--eval-region))
        ((org-at-heading-p) (brust-endless/org-julia--eval-header))
        (t (brust-org-mode-vterm-julia--eval-block))))

;; Julia blocks
(defun brust-endless/org-julia--eval-header nil
  (save-excursion
    (org-narrow-to-subtree)
    ;; (brust-endless/org-eval-eblocks-delete-commented-subtrees)
    ;; (goto-char (point-min))
    (while (not (eobp))
      (when (looking-at brust-endless/org-babel-src-block-regexp)
        (brust-vterm--eval-buffer-substring (match-beginning 5) (match-end 5) 1))
      (forward-line +1))
    (widen)))

;; (brust-endless/org-eval-eblocks
;;  nil
;;  nil
;;  nil
;;  'brust-vterm--eval-buffer-substring))

;; Elisp blocks
(defun brust-endless/org-eval-current-header nil
  (interactive)
  (brust-endless/org-eval-eblocks
   (and (org-copy-subtree)
        (pop kill-ring))))

(use-package! org-pandoc-import :after org)

;; Add hooks and some basic variables declations
(brust-endless/org-eval-eblocks "~/.doom.d/local/lisp/brusts-latex-config.org" "init" t)

;; + variables has to be declared before loading module
(setq +latex-bibtex-file "~/Dropbox/bibliography/my.bib"
      +latex-viewers '(pdf-tools))

(after! latex
  ;; File types
  (add-to-list 'auto-mode-alist '("\\.sty\\'"  . LaTeX-mode))

  ;; Doom stuff
  (remove-hook 'TeX-mode-hook #'TeX-fold-mode)
  ;; Settings
  ;; Config options
  (brust-endless/org-eval-eblocks "~/.doom.d/local/lisp/brusts-latex-config.org" "config" t)
  ;; Add C-c C-q for clean and indent
  ;; (brust-endless/org-eval-eblocks "~/.doom.d/local/lisp/brusts-latex-config.org" "LaTeX-extra" t)
  )

(after! (latex reftex)
  (brust-endless/org-eval-eblocks "~/.doom.d/local/lisp/brusts-latex-config.org" "RefTeX" t)

  (add-hook! 'reftex-select-label-mode-hook
    (map! :map reftex-select-label-mode-map
          :e "j"  #'reftex-select-next
          :e "k"  #'reftex-select-previous))

  (setq reftex-toc-mode-hook nil) ;; +ref.el in modules/lang/latex
  (add-hook! 'reftex-toc-mode-hook
    (map! :map 'local
          :e "j"   #'next-line
          :e "k"   #'previous-line
          :e "q"   #'kill-buffer-and-window
          :e "ESC" #'kill-buffer-and-window
          :e "1"  #'brust-reftex-toc-level-1
          :e "2"  #'brust-reftex-toc-level-2
          :e "3"  #'brust-reftex-toc-level-3
          :e "4"  #'brust-reftex-toc-level-4
          :e "5"  #'brust-reftex-toc-level-5
          :e "6"  #'brust-reftex-toc-level-6
          :e "m"  #'describe-mode
          )))

(after! (latex cdlatex)
  (brust-endless/org-eval-eblocks "~/.doom.d/local/lisp/brusts-latex-config.org" "cdLaTeX" t))

(use-package! bratex
  :after latex)

(map! :after latex
      (:map LaTeX-mode-map
       :gin "]"    #'brust-LaTeX-insert-math1
       :gin "}"    #'brust-LaTeX-insert-math2
       ;; "C-c C-q"   #'latex/clean-fill-indent-environment ;; Now use "= G"
       "s-e"       #'brust-LaTeX-next-error
       "s-t"       #'TeX-complete-symbol ;; Auto-complete funcion of AUCTeX
       "C-c C-e"   #'brust-LaTeX-env
       "<M-up>"    #'bratex-cycle-size
       "<M-down>"  #'bratex-cycle-size-reverse
       "<M-right>" #'bratex-cycle-bracket
       "<M-left>"  #'bratex-cycle-bracket-reverse
       (:localleader
        "5" #'latex-replace-in-math
        "%" #'latex-replace-regexp-in-math
        "0" #'brust-cycle-texmath
        "W" #'brust-wc-save-words
        "r" #'reftex-reference
        ;; "t" #'reftex-toc
        "b" #'citar-insert-citation
        "h" #'brust-LaTeX-set-header
        "SPC" #'TeX-command-master
        "m" #'TeX-insert-macro
        "]" #'LaTeX-close-environment
        "E" #'LaTeX-environment
        )))

(map! :after (latex cdlatex)
      :map cdlatex-mode-map
      "`" nil
      :i ";"   #'cdlatex-math-symbol
      :i "C-;" (lambda nil (insert ";"))
      :i "TAB" #'cdlatex-tab
      :localleader
      "e" #'cdlatex-environment)

;; (setq auto-mode-alist (delete '("\\.jl\\'" . ess-julia-mode) auto-mode-alist))

;; `ob-julia' needs this variable to be defined, but it's defined in
;; `ess-custom', which won't be available if you're using :lang julia and not
;; :lang ess.
(defvar inferior-julia-program-name (or (executable-find "julia") "julia"))

(after! julia-repl
  (julia-repl-set-terminal-backend 'vterm)
  ;; (add-hook 'term-mode-hook #'visual-line-mode)
  ;; (setq auto-mode-alist (delete '("\\.jl\\'" . ess-julia-mode) auto-mode-alist))
  ;; treat underscores as word delimiters, see https://github.com/hlissner/doom-emacs/blob/develop/docs/faq.org#how-do-i-get-motions-to-treat-underscores-as-word-delimiters
  (add-hook! 'julia-mode-hook (progn (modify-syntax-entry ?_ "w")
                                     (modify-syntax-entry ?! "w")))
  (when (executable-find "julia")
    (setq julia-repl-executable-records
          `(;; (default "julia")
            (master ,(executable-find "julia")))))

  ;; (add-hook! 'julia-repl-hook (julia-repl--send-string (concat "include(\"" (expand-file-name "~/.julia/config/startup.jl") "\")")))
  ;; It cause a problem, execute julia-repl--send-string in this hook (outside hook there is no problem, not realted to doom, emacs -q and install julia-repl reproduce it) Actually, not needed, now julia-repl loads startup.jl
  (map! (:map julia-mode-map
         (:localleader
          :desc "Generate exports"    "x" #'brust-julia-update-exports))
        (:map julia-repl-mode-map
         (:localleader
          :desc "line or region"      "SPC" #'julia-repl-send-region-or-line
          :desc "Start process"       "o" #'+julia/open-repl
          :desc "Start eglot server"  "." #'+lsp!
          :desc "Set dir to buffer's" "d" #'julia-repl-cd
          :desc "Doc symbol"          "h" #'julia-repl-doc
          :desc "Call \\@edit"        "e" #'julia-repl-edit
          :desc "Send buffer"         "b" #'julia-repl-send-buffer
          :desc "Methods symbol"      "m" #'julia-repl-list-methods))
        (:map vterm-mode-map
         :prefix "C-c"
         :desc "Clear buffer" "d" #'comint-clear-buffer)))

(use-package! lsp-julia
  ;; :after lsp
  :config
  (setq ;; lsp-julia-package-dir nil
        lsp-julia-default-environment "~/.julia/environments/v1.8"
        ;; lsp-enable-folding t
        lsp-julia-lint-nothingcomp nil ;; Do not check for nothing === something
        lsp-julia-format-indents nil
        lsp-julia-format-calls t
        ))

(defun brust-julia--launch-and-link-vterm nil
  (brust-vterm--launch-and-link (buffer-name) "--vjulia")
  (brust-vterm--eval-string "julia\n"))

(defun brust-julia--link-or-launch-and-link-vterm nil
  (interactive)
  (if (y-or-n-p "Link buffer to a julia process [y] or launch and link a new one [n]")
      (brust-vterm--link
       (save-window-excursion
         (consult-buffer)
         (buffer-name))
       (buffer-name))
    (brust-julia--launch-and-link-vterm)))

(defun brust-julia--ensure-vterm-process-alive nil
  ;; When process is not alive, always launch a new one without asking.
  ;; If I wanted to link (unlikely), I can kill the new process and
  ;; call brust-..-link-or-launch-and-link.
  (unless (process-live-p vterm--process) (brust-julia--launch-and-link-vterm)))

(defun brust--julia-input-bounds nil
  (save-excursion
    (move-beginning-of-line 1)
    (search-forward "> " (point-at-eol) t)
    ;; (message "  Input bounds are %i %i"
    ;;          (car (cons (point) (point-at-eol)))
    ;;          (cdr (cons (point) (point-at-eol))))
    (cons (point) (point-at-eol))))

(defun brust--julia-input-string nil
  (let* ((-bounds (brust--julia-input-bounds))
         (-str (buffer-substring (car -bounds) (cdr -bounds))))
    ;; (message "  Input string is \"%s\"" -str)
    -str))

(defun brust--julia-input-delete nil
  (interactive)
  (let* ((-bounds (brust--julia-input-bounds))
         (N (- (cdr -bounds) (car -bounds))))
    (dotimes (i N) (term-send-left))
    (dotimes (i N) (term-send-del))))

(defun brust-julia--add-function (-fun)
  ;; (move-end-of-line 1)
  ;; (dotimes (i (point-at-eol) (point)) (term-send-right))
  (let ((input (brust--julia-input-string)))
    (brust--julia-input-delete)
    (julia-repl--send-string (concat -fun "(" input ")"))))

(defvar brust-julia-add-function-alist
  '("typeof"
    "eltype"
    "size")
  "\
List if julia functions names to define wrap for.")

(after! vterm
  (cl-loop for fun in brust-julia-add-function-alist do
           ;; (message "dir %s, name %s" (car dirname) (cdr dirname))
           (let ((fun-name (intern (format "brust-julia-send-%s" fun)))
                 (desc (concat "Sent wrap for " fun))
                 (bind (downcase (substring fun 0 1))))
             ;; (message "dir %s, name %s" dir name)
             (fset fun-name
                   `(lambda nil (interactive)
                      (brust-julia--add-function ,fun)))
             (map! (:map vterm-mode-map
                    (:prefix "C-c"
                     (:prefix ("f" . "Wrap fun")
                      :desc desc bind fun-name)))))))

(defun brust-julia-update-exports nil
  (interactive)
  (save-excursion
    (let ((defunlist (brust-julia--collect-defuns)))
      (goto-char (point-min))
      (insert "\nexport\n")
      (while (< 1 (length defunlist))
        (insert (car (pop defunlist)) ",\n"))
      (insert (car (pop defunlist)) "\n"))))

(defun brust-julia--collect-defuns nil
  (goto-char (point-max))
  (let ((defunlist '()))
    (while (julia-beginning-of-defun)
      (if (string= (thing-at-point 'word t) "function") (forward-word 2))
      (pushnew! defunlist (julia-repl--symbols-at-point))
      (move-beginning-of-line 1))
    defunlist))

;; (add-load-path! "~/src/maplev-master/lisp")
(autoload 'maplev-mode "maplev" "Maple editing mode" 'interactive)
(add-to-list 'auto-mode-alist '("\\.mpl\\'" . maplev-mode))

(defun brust-pov-ray-compile nil
  (interactive)
  (save-buffer)
  (pov-menu-render-highest))

(map! :localleader
      :map pov-mode-map
      "SPC" #'brust-pov-ray-compile
      "q" #'pov-command-query ;AS
      "h" #'pov-keyword-help
      "r" #'pov-tool-bar-command-render
      "l" #'pov-show-render-output
      "1" #'pov-menu-render-test
      "2" #'pov-menu-render-low
      "3" #'pov-menu-render-mid
      "4" #'pov-menu-render-high
      "5" #'pov-menu-render-highest
      "i" #'pov-open-include-file
      "e" #'pov-menu-external-viewer
      "v" #'pov-menu-internal-viewer
      )

(setq singular-emacs-home-directory "/usr/share/singular/emacs/")
;; (add-load-path! singular-emacs-home-directory)
(cl-pushnew singular-emacs-home-directory load-path :test #'string=)
(autoload 'singular "singular"
  "Start Singular using default values." t)
(autoload 'singular-other "singular"
  "Ask for arguments and start Singular." t)

(add-to-list 'auto-mode-alist '("\\.sing\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.lib\\'" .  c++-mode))

(defun brust-singular-mode-hook nil
  ;; turn-on fontification for c++-mode
  (font-lock-mode 1)
  (setq singular-help-fall-back-file-name "singular.hlp")
  (set (make-local-variable 'singular-commands-alist) nil)
  (load (concat singular-emacs-home-directory "cmd-cmpl"))
  ;; turn on aut-new line
  (c-toggle-auto-newline 1)
  ;; tunr off hungry-delete
  (c-toggle-hungry-state -1)
  (company-mode -1))

(add-hook 'c++-mode-hook #'brust-singular-mode-hook)

(defun brust-singular-intetractive-mode nil
  (brust-math-software-hookfun-to-intangify-prompt)
  (hl-line-mode 1))

(add-hook 'singular-interactive-mode-hook #'brust-singular-intetractive-mode)

(defadvice singular-send-or-copy-input (before finish-line activate)
  (brust-singular-finish-line-interaction-mode))

(map! (:map c++-mode-map
       "C-<return>" #'newline
       "<return>" #'brust-singular-finish-line-singular-edit-mode
       (:localleader
        "<tab>" #'brust-singular-dynamic-complete
        "a"   #'singular-beginning-of-line
        "p"   #'brust-singular-add-print
        "s"   #'brust-singular-add-std
        "SPC" #'brust-singular-eval-region-or-line
        ";" #'comment-region
        "b" #'brust-singular-eval-buffer
        "s" #'brust-singular-fixed-region-set-region
        "f" #'brust-singular-fixed-region-eval
        "e" #'brust-singular-eval-proc))
      (:map singular-interactive-mode-map
       "C-p" #'brust-singular-add-print
       "C-s" #'brust-singular-add-std))

(defvar brust-singular-fixed-region-poss nil "Cons of positions delimiting the fixed region")

(defun brust-singular-fixed-region-set-region (args)
  (interactive "P")
  (unless (use-region-p) (user-error "Region has to be activate"))
  (let ((beg (region-beginning))
        (end (region-end)))
    (setq brust-singular-fixed-region-poss (cons beg end))
    (message "Fixed-region seted from line %d to %d"
             (line-number-at-pos beg)
             (line-number-at-pos end)))
  (deactivate-mark t))

(defun brust-singular-fixed-region-eval (args)
  (interactive "P")
  (message "Evaluated region (%d:%d) in [[%s]]"
           (line-number-at-pos (car brust-singular-fixed-region-poss))
           (line-number-at-pos (cdr brust-singular-fixed-region-poss))
           buffer-file-name)
  (brust-singular--eval-string
   (buffer-substring-no-properties
    (car brust-singular-fixed-region-poss)
    (cdr brust-singular-fixed-region-poss))
   args))

(defun brust-singular-eval-region-or-line (args)
  (interactive "P")
  (let (-str)
    (if (not (use-region-p))
        (save-excursion
          (while (not (or (brust-singular--ending-semicolon-p) (bobp)))
            (forward-line -1))
          (setq -str (thing-at-point 'line t))
          (unless (brust-singular--ending-semicolon-p -str)
            (user-error "There is no line to eval"))
          (unless (brust-singular--check-parents -str)
            (user-error "Unbalanced Parents!!!"))
          (message "Evaluated line (%d) in [[ %s ]]"
                   (line-number-at-pos (point))
                   (buffer-name)))
      (message "Evaluated region between lines (%d:%d) in [[ %s ]]"
               (line-number-at-pos (region-beginning))
               (line-number-at-pos (region-end))
               (buffer-name))
      (setq -str (buffer-substring-no-properties
                  (region-beginning) (region-end))))
    (brust-singular--eval-string -str args)))

(defun brust-singular--ending-semicolon-p (&optional -string)
  (unless -string
    (setq -string (thing-at-point 'line t)))
  (string= ";"
           (substring (s-trim
                       (car
                        (split-string
                         -string "//")))
                      -1)))

(defun brust-singular--check-parents (&optional -string)
  (unless -string
    (setq -string (thing-at-point 'line t)))
  (with-temp-buffer
    (insert -string)
    (ignore-errors (check-parens) t)))

(defun brust-singular--eval-string (-str &optional args)
  (save-window-excursion
    (singular)
    (goto-char (point-max))
    (let ((process (singular-process))
          (--str (concat (s-trim -str)
                         (unless (string= (substring -str -1) ";")
                           "\n;"))))
      (when args (singular-control-c 'restart))
      (singular-input-filter process --str)
      (singular-send-string process --str))))

(defun brust-singular--delete-comments (&optional -string)
  (unless -string
    (setq -string (thing-at-point 'line t)))
  (with-temp-buffer
    (insert -string)
    (goto-char (point-min))
    (while (search-forward "//" nil t)
      (forward-char -2)
      (delete-region (point) (line-end-position)))
    (buffer-string)))

(defun brust-singular-eval-proc (args)
  "Eval last proc declaration."
  (interactive "P")
  (save-excursion
    (search-backward "proc" nil t)
    (let ((-beg (point))
          (-name
           (if (re-search-forward "[ \s\t]+" (line-end-position) t)
               (let ((-beg2 (point)))
                 (if (search-forward "(" (line-end-position) t)
                     (s-trim (buffer-substring-no-properties -beg2 (1- (point))))
                   nil))
             nil)))
      (search-forward "{" nil t)
      (forward-char -1)
      (sp-forward-sexp)
      (brust-singular--eval-string
       (buffer-substring-no-properties -beg (point))
       args)
      (if -name
          (message "Evaluated proc {{%s}}, between lines (%d:%d), in file [[%s]]"
                   -name
                   (line-number-at-pos -beg)
                   (line-number-at-pos (point))
                   (file-name-base (buffer-name)))
        (message "Evaluated proc between lines (%d:%d) and file [[%s]] (Warring:: its name is not on the definition line)"
                 (line-number-at-pos -beg)
                 (line-number-at-pos (point))
                 (file-name-base (buffer-name)))))))

;;(defun brust-singular-eval-buffer-line-by-line nil
;;  (interactive)
;;  (let ((-total-str (buffer-string))
;;        (-base-name (file-name-base (buffer-name))))
;;    (with-temp-buffer
;;      (insert -total-str)
;;      (brust-singular--delete-comments)
;;      (goto-char (point-min))
;;      (while (not (eobp))
;;        ;;(or (brust-check-line-parents) (user-error "Unbalanced Parent!!!"))
;;        (let ((-str (s-trim (buffer-substring-no-properties
;;                             (line-beginning-position)
;;                             (line-end-position))))
;;              (-line (line-number-at-pos)))
;;          (unless
;;              (cond ((string= -str "") t)
;;                    ((string= (substring -str -1) ";")
;;                     (brust-singular--eval-string
;;                      -str
;;                      (format "line:%d:of::%s--" -line -base-name)
;;                      nil)
;;                     t)
;;                    (t (brust-singular-eval-environment args) t))
;;            (message "Error on line:%d (%s)" -line -str)
;;            (goto-char (point-max)))
;;          ;;(when err (goto-char err))
;;          (forward-line 1))))))

;;(defun brust-singular--temp-file (-str -name)
;;  (let ((-temp-file
;;         (make-temp-file
;;          (replace-regexp-in-string "[.]" "-" -name)
;;          nil ".sing")))
;;    (with-temp-buffer
;;      (insert -str)
;;      (append-to-file (point-min) (point-max) -temp-file))
;;    -temp-file))

(defun brust-singular-add-print nil
  (interactive)
  (brust-singular-add-function "print"))

(defun brust-singular-add-std nil
  (interactive)
  (brust-singular-add-function "std"))

(defun brust-singular-add-function (-fun)
  (let* ((-bounds (if (region-active-p)
                      `(,(region-beginning) . ,(region-end))
                    (save-excursion
                      (move-beginning-of-line 1)
                      (search-forward "> " (point-at-eol) t)
                      `(,(point) . ,(progn
                                      (move-end-of-line 1)
                                      (search-backward ";" (point-at-bol) t)
                                      (point))))))
         (-str (buffer-substring-no-properties (car -bounds) (cdr -bounds))))
    (goto-char (car -bounds))
    (delete-region (car -bounds) (cdr -bounds))
    (insert -fun "(" -str ")")
    (move-end-of-line 1)
    (insert ";")))

(defun brust-singular-finish-line-singular-edit-mode nil
  (interactive)
  (if (or (bolp) (eobp)) (insert "\n")
    (move-end-of-line 1)
    (when (search-backward "//" (point-at-bol) t)
      (skip-chars-backward "[:space:]"))
    (let ((-main-line (s-trim-right
                       (buffer-substring-no-properties (point-at-bol) (point))))
          (-comment-line (buffer-substring-no-properties (point) (point-at-eol))))
      (delete-region (point-at-bol) (point-at-eol))
      (if (or (< (length -main-line) 1))
          (insert (concat -comment-line "\n"))
        (insert
         (concat ;;compare (insert (concat nil "hello")) vs (insert nil "hello")
          (with-temp-buffer ;; To close-all-open-paren-r just of this line and do not use narrow
            (insert (concat -main-line
                            (unless (string= (substring -main-line -1) ";")
                              ";")))
            (forward-char -1)
            (close-all-open-paren-right)
            (buffer-string))
          -comment-line
          "\n"))))))

(defun brust-singular-finish-line-interaction-mode nil
  (interactive)
  (narrow-to-region (point-at-bol) (point-at-eol))
  (move-end-of-line 1)
  (delete-horizontal-space)
  (unless (string= (string (char-before (point))) ";")
    (insert ";"))
  (forward-char -1)
  (close-all-open-paren-right)
  (widen))

(defun brust-singular-dynamic-complete ()
  "Dynamic complete word before point.
      Performs completion of Singular commands."
  (interactive)
  (let* ((end (point))
         (beg
          (save-excursion
            (skip-chars-backward "a-zA-Z0-9")
            (point)))
         (str (buffer-substring-no-properties beg end)))
    (if (string= str "")
        (indent-region (point-at-bol) (point-at-eol))
      ;; (call-interactively 'indent-region)
      (if singular-commands-alist
          (singular-completion-do str beg end singular-commands-alist)
        (message "Completion of Singular commands disabled.")
        (ding)))))

;; Setup M2.el for autoloading
;; add "/usr/share/info" to Info-default-directory-list if it isn't there (it is already there)
;; (add-to-list 'Info-default-directory-list "/usr/share/info")
;; (add-load-path! "/usr/share/emacs/site-lisp/Macaulay2/")
(cl-pushnew  "/usr/share/emacs/site-lisp/Macaulay2/" load-path :test #'string=)

(autoload 'M2             "M2" "Run Macaulay2 in an emacs buffer" t)
(autoload 'M2-mode        "M2" "Macaulay2 editing mode" t)
(autoload 'm2-mode        "M2" "Macaulay2 editing mode, name in lower case" t)
(autoload 'm2-comint-mode "M2" "Macaulay2 command interpreter mode, name in lower case" t)
(add-to-list 'auto-mode-alist '("\\.m2\\'" . M2-mode))

;; Uncomment these lines to enable syntax highlighting for the interpreter language
;;(autoload 'D-mode "D-mode" "Editing mode for the interpreter language" t)
;;(add-to-list 'auto-mode-alist '("\\.dd?\\'" . D-mode))

(map! (:map M2-mode-map
       :n "= Q" #'brust-M2-indent-buffer
       (:localleader
        "SPC" #'brust-M2-M2-or-M2-send-to-program
        "Q" #'brust-M2-indent-buffer)))

(defun brust-M2-electric-tab-inerit-indentation nil
  (let ((context (delete-white-space)))
    (M2-electric-tab)
    (when (string-match-p "\n" context) (insert context))))

(defun brust-M2-indent-buffer nil
  (interactive)
  (brust-apply-function-line-by-line 'brust-M2-electric-tab-inerit-indentation))

(defun brust-M2-M2-or-M2-send-to-program nil
  (interactive)
  (if (get-buffer "*M2*")
      (call-interactively 'M2-send-to-program)
    (call-interactively 'M2)))

(setq pre-abbrev-expand-hook (quote (ignore))
      save-abbrevs 'silently)
(when (file-exists-p "~/Dropbox/config/abbrev-def.el")
  (setq abbrev-file-name "~/Dropbox/config/abbrev-def.el"))

(setq-default abbrev-mode t)
(add-hook 'emacs-startup-hook #'quietly-read-abbrev-file)

(setq global-auto-revert-ignore-modes (quote (PDFView))
      auto-revert-check-vc-info t)

(add-hook! 'emacs-startup-hook (global-auto-revert-mode +1))

(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)

(defun ora-ediff-prepare-buffer nil
  (when (memq major-mode '(org-mode emacs-lisp-mode))
    (outline-show-all)))

(defun ediff-copy-both-to-C nil
  (interactive)
  (ediff-copy-diff
   ediff-current-difference nil 'C nil
   (concat
    (ediff-get-region-contents
     ediff-current-difference 'A ediff-control-buffer)
    (ediff-get-region-contents
     ediff-current-difference 'B ediff-control-buffer))))

(defun add-d-to-ediff-mode-map nil
  (define-key ediff-mode-map "d" #'ediff-copy-both-to-C))

(after! ediff
  (add-hook 'ediff-keymap-setup-hook #'add-d-to-ediff-mode-map)
  (add-hook 'ediff-prepare-buffer-hook 'ora-ediff-prepare-buffer))

(setq eldoc-echo-area-use-multiline-p nil)

(add-hook! 'emacs-lisp-mode-hook (modify-syntax-entry ?- "w"))

(setq hl-todo-highlight-punctuation ":")

;; (setq ispell-highlight-face 'flyspell-incorrect)

;; See https://github.com/doomemacs/doomemacs/issues/4239
;; Useful for spell-fu
;; Notice the lack of "--run-together"
(setq ispell-extra-args '("--sug-mode=ultra"))

(add-hook! 'emacs-startup-hook (recentf-mode 1))

(after! org
  ;; Doom disables =show-paren-mode= because:
  ;;  ;; `show-paren-mode' causes flickering with indent overlays made by
  ;;  ;; `org-indent-mode', so we turn off show-paren-mode altogether
  ;;  but it is not a problem for me so long, so I reable it.
  (add-hook 'org-mode-hook #'brust-doom-reable-show-paren-mode-h t)
  (add-hook 'org-mode-hook #'org-setup-<>-syntax-fix))

;; Locally reable show parens
(defun brust-doom-reable-show-paren-mode-h nil
  "Turn on `show-paren-mode' buffer-locally."
  (setq-local show-paren-mode t))

;; Fix syntax for chars <,> in org-mode blocks
(defun org-mode-<>-syntax-fix (start end)
  "Change syntax of characters ?< and ?> to symbol within source code blocks."
  (let ((case-fold-search t))
    (when (eq major-mode 'org-mode)
      (save-excursion
        (goto-char start)
        (while (re-search-forward "<\\|>" end t)
          (when (save-excursion
                  (and
                   (re-search-backward "[[:space:]]*#\\+\\(begin\\|end\\)_src\\_>" nil t)
                   (string-equal (downcase (match-string 1)) "begin")))
            ;; This is a < or > in an org-src block
            (put-text-property (point) (1- (point))
                               'syntax-table (string-to-syntax "_"))))))))
(defun org-setup-<>-syntax-fix nil
  "Setup for characters ?< and ?> in source code blocks.
Add this function to `org-mode-hook'."
  (make-local-variable 'syntax-propertize-function)
  (setq syntax-propertize-function 'org-mode-<>-syntax-fix)
  (syntax-propertize (point-max)))

;; we will call `blink-matching-open` ourselves...
(remove-hook 'post-self-insert-hook
             #'blink-paren-post-self-insert-function)
;; this still needs to be set for `blink-matching-open` to work
(setq blink-matching-paren 'show)

(let ((ov nil)) ; keep track of the overlay
  (advice-add
   #'show-paren-function
   :after
    (defun show-paren--off-screen+ (&rest args)
      "Display matching line for off-screen paren."
      ;; (apply orig-fun args)
      (when (overlayp ov)
        (delete-overlay ov))
      ;; check if it's appropriate to show match info,
      ;; see `blink-paren-post-self-insert-function'
      (when (and (overlay-buffer show-paren--overlay)
                 (not (or cursor-in-echo-area
                          executing-kbd-macro
                          noninteractive
                          (minibufferp)
                          this-command))
                 (and (not (bobp))
                      (memq (char-syntax (char-before)) '(?\) ?\$)))
                 (= 1 (logand 1 (- (point)
                                   (save-excursion
                                     (forward-char -1)
                                     (skip-syntax-backward "/\\")
                                     (point))))))
        ;; rebind `minibuffer-message' called by
        ;; `blink-matching-open' to handle the overlay display
        (cl-letf (((symbol-function #'minibuffer-message)
                   (lambda (msg &rest args)
                     (let ((msg (apply #'format-message msg args)))
                       (setq ov (display-line-overlay+
                                 (window-start) msg ))))))
          (blink-matching-open))))))

(defadvice show-paren--off-screen+ (around evil activate)
  "Match parentheses in Normal state."
  (if (if (memq 'not evil-highlight-closing-paren-at-point-states)
          (memq evil-state evil-highlight-closing-paren-at-point-states)
        (not (memq evil-state evil-highlight-closing-paren-at-point-states)))
      ad-do-it
    (let ((pos (point)) syntax narrow)
      (setq pos
            (catch 'end
              (dotimes (var (1+ (* 2 evil-show-paren-range)))
                (if (zerop (mod var 2))
                    (setq pos (+ pos var))
                  (setq pos (- pos var)))
                (setq syntax (syntax-class (syntax-after pos)))
                (cond
                 ((eq syntax 4)
                  (setq narrow pos)
                  (throw 'end pos))
                 ((eq syntax 5)
                  (throw 'end (1+ pos)))))))
      (if pos
          (save-excursion
            (goto-char pos)
            (save-restriction
              (when narrow
                (narrow-to-region narrow (point-max)))
              ad-do-it))
        ;; prevent the preceding pair from being highlighted
        (dolist (ov '(show-paren--overlay
                      show-paren--overlay-1
                      show-paren-overlay
                      show-paren-overlay-1))
          (let ((ov (and (boundp ov) (symbol-value ov))))
            (when (overlayp ov) (delete-overlay ov))))))))

(defun display-line-overlay+ (pos str &optional face)
  "Display line at POS as STR with FACE.

FACE defaults to inheriting from default and highlight."
  (let ((ol (save-excursion
              (goto-char pos)
              (make-overlay (line-beginning-position)
                            (line-end-position)))))
    (overlay-put ol 'display str)
    (overlay-put ol 'face
                 (or face '(:inherit default :inherit highlight)))
    ol))

(setq password-cache-expiry nil
      remote-file-name-inhibit-cache nil
      tramp-completion-reread-directory-timeout nil
      auth-source-cache-expiry nil
      tramp-ssh-controlmaster-options "" ;; See https://www.reddit.com/r/emacs/comments/fgl6gu/emacs_tramp_tricks/ and https://puppet.com/blog/speed-up-ssh-by-reusing-connections/
      tramp-verbose 1
      vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))

(defun brust-decrypt (file)
  (when (file-exists-p file)
    (let ((-temp-file (make-temp-file (file-name-base file))))
      (epa-decrypt-file file -temp-file)
      (delete-file -temp-file))))

;; (add-hook! 'emacs-startup-hook (brust-decrypt "~/.authinfo.gpg"))

(after! ibuffer
  ;; Redefine size Ibuffer's column to display the total number of lines,
  ;; a humanly understandable measure of size.
  (define-ibuffer-column size
    (:name "nºLines"
     :inline t
     :header-mouse-map ibuffer-size-header-map
     :summarizer brust--number-of-lines-summarize)
    (save-window-excursion
      (switch-to-buffer buffer)
      (brust--number-of-lines-current-buffer)))

  (defun brust--number-of-lines-string-to-number (str)
    (let ((factor
           (cond
            ((string-match-p "k" str) 1000)
            ((string-match-p "M" str) 1000000)
            (t 1))))
      (floor (* factor (string-to-number str)))))

  (defun brust--number-of-lines-summarize (nlines)
    (number-to-string
     (cl-loop for n in nlines sum
              (brust--number-of-lines-string-to-number n))))

  ;; Add a view to display full name and filename.
  (setq ibuffer-formats ;; Modify Ibuffer columns (toggle with `)
        (append ibuffer-formats
                '((mark vc-status-mini " "
                        (icon 2 2 :left :elide)
                        (size 5 -1 :right)
                        " "
                        (name 40 40 :left :elide)
                        ;; " "
                        ;; (mode 16 16 :left :elide)
                        ;; " "
                        ;; (vc-status 16 16 :left)
                        " "
                        filename-and-process))))

  (setq ibuffer-saved-filter-groups
        (list (cons "home"
                    `((,(concat
                         (all-the-icons-icon-for-mode 'org-mode :v-adjust -0.05)
                         " Org")
                       (or (mode . org-mode)
                           (name . "Org")
                           (filename . "Org")))
                      (,(concat
                         (all-the-icons-octicon
                          "file-directory"
                          :face ibuffer-filter-group-name-face
                          :v-adjust -0.05)
                         " Files") (filename . ".*"))
                      (,(concat
                         (all-the-icons-icon-for-mode 'dired-mode :v-adjust -0.05)
                         " Dired")
                       (mode . dired-mode))
                      (,(concat
                         (all-the-icons-icon-for-mode 'vterm-mode :v-adjust -0.05)
                         " Vterm")
                       (mode . vterm-mode))
                      ("Magit" (name . "\*magit"))
                      ("ERC" (mode . erc-mode))
                      ("Help" (or (name . "\*Help\*")
                                  (name . "\*Apropos\*")
                                  (filename . ".el.gz$")
                                  (name . "\*info\*")))
                      ("Doom emacs" (or
                                     (name . "^\\*scratch\\*$")
                                     (name . "^\\*doom\\*$")
                                     (name . "^\\*Messages\\*$")))
                      ("System" (name . "^\*.*\*$"))
                      )))
        ibuffer-sorting-mode 'alphabetic
        ibuffer-expert t
        ibuffer-hook nil)

  (add-hook 'ibuffer-hook 'brust-ibuffer-setting)

  (defun brust-ibuffer-setting nil
    (setq ibuffer-filter-groups (append
                                 (ibuffer-projectile-generate-filter-groups)
                                 (cdr (assoc "home" ibuffer-saved-filter-groups)))
          ibuffer-hidden-filter-groups nil)
    (ibuffer-update nil t))
  )

(map! :after company
      :map company-active-map
      "TAB"    #'company-abort
      "<tab>"  #'company-abort
      ;; "M-o"    #'counsel-company
      "<left>" #'company-complete-common
      "<right>" #'brust-company-insert-selection
      "C-j"    #'company-next-page
      "C-k"    #'company-previous-page
      "C-l"    #'company-show-location
      )

;; (defun brust-company--cdlatex-or-yas-on-abort (result)
;;   (when result
;;     (cond ((fboundp 'cdlatex-tab) (cdlatex-tab))
;;           ((fboundp 'yas-expand) (yas-expand)))))

;; (defun brust-company--cdlatex-or-yas-on-abort (result))
;; (add-hook 'company-completion-cancelled-hook #'brust-company--cdlatex-or-yas-on-abort)

(defun brust-company-insert-selection nil
  "Insert the selected candidate and continue company."
  (interactive)
  (when (and (company-manual-begin) company-selection)
    (let ((result (nth company-selection company-candidates)))
      (company--insert-candidate result))))

(after! company
  (setq +lsp-company-backends '(company-tabnine :separate company-capf company-yasnippet))
  (setq company-show-numbers t)
  (setq company-idle-delay 0)
)

(setq evil-cross-lines t
      ;; Use both =jk= and =kj= to esc insert mode
      ;; (equivalent to key-chords jk kj) Press them as single key!
      evil-escape-unordered-key-sequence t
      evil-split-window-below t
      ;; pasting in visual state NOT adds the replaced text to the kill ring
      evil-kill-on-visual-paste nil
      ;; cursor is allowed to move one character past the end of the line
      evil-move-beyond-eol t
      evil-vsplit-window-right t)
(global-evil-visualstar-mode +1)

(defun bb/evil-delete--black-hole-register (orig-fn beg end &optional type _ &rest args)
  (apply orig-fn beg end type ?_ args))

(advice-add 'evil-delete-char :around 'bb/evil-delete--black-hole-register)
(advice-add 'evil-delete-backward-char :around 'bb/evil-delete--black-hole-register)

(use-package! keyfreq
  :init
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1)
  (setq keyfreq-excluded-commands
        '(self-insert-command
          forward-char
          backward-char
          previous-line
          next-line)))

(use-package! lsp-ui
  :after lsp
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show))

(use-package! lsp-treemacs
  :after lsp
  :commands lsp-treemacs-errors-list)

(after! magit
  (setq magit-turn-on-auto-revert-mode nil
        magit-diff-hide-trailing-cr-characters t
        magit-set-upstream-on-push 'dontask
        magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1
        magit-save-repository-buffers 'dontask
        magit-diff-paint-whitespace t
        ;; magit-diff-refine-ignore-whitespace nil
        magit-diff-refine-hunk t)

  ;; (add-hook 'magit-log-edit-mode-hook #'turn-on-flyspell)
  ;; (add-hook 'git-commit-mode-hook #'turn-on-flyspell)

  (add-hook! 'magit-mode-hook
            (map! :map magit-mode-map
                  :n "n" #'magit-section-forward-sibling
                  :n "p" #'magit-section-backward-sibling)))

(use-package! nyan-mode
  :defer t
  :init
  (add-hook! 'emacs-startup-hook (nyan-mode +1))
  :config
  (setq nyan-minimum-window-width 90
        ;;nyan-cat-face-number 3
        +nyan-outerspace-image+ "~/.doom.d/local/outerspace.xpm"
        nyan-wavy-trail nil
        nyan-animate-nyancat nil
        ;; nyan-animation-frame-interval 0.2
        nyan-bar-length 36)
  ;; (nyan-start-animation)
  )

(use-package! zone
  :after nyan-mode
  :config
  (zone-when-idle (* 5 60)))

(use-package! zone-nyan
  :after zone
  :config
  (setq zone-programs [zone-nyan]
        zone-nyan-hide-progress t))

(after! pdf-tools
  ;; open pdfs scaled to fit page
  ;; (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t
        pdf-view-resize-factor 1.1)
  ;; faster motion
  (map!
   :map pdf-view-mode-map
   :n "<"            #'pdf-view-first-page
   :n ">"            #'pdf-view-last-page
   :n "q"            #'kill-current-buffer
   ;; "C-k"          #'pdf-view-next-page-command
   ;; "C-i"          #'pdf-view-previous-page-command
   ;; "s-SPC"        #'pdf-view-scroll-down-or-previous-page
   :n "s-j"          #'pdf-view-next-line-or-next-page
   :n "s-k"          #'pdf-view-previous-line-or-previous-page
   :n "s-h"          #'image-backward-hscroll
   :n "s-l"          #'image-forward-hscroll
   :n "j"            #'brust-pdf-view-next-line-or-next-page-5
   :n "k"            #'brust-pdf-view-previous-line-or-previous-page-5
   :n "h"            #'brust-image-backward-hsroll-5
   :n "l"            #'brust-image-forward-hsroll-5
   ;; "C-n"          #'brust-ace-window
   ;; "n"            #'brust-ace-window
   :n "<mouse-5>"    #'brust-pdf-view-next-line-or-next-page-5
   :n "<mouse-4>"    #'brust-pdf-view-previous-line-or-previous-page-5
   :n "C-<mouse-5>"  #'pdf-view-next-page-command
   :n "C-<mouse-4>"  #'pdf-view-previous-page-command
   :n "s-<mouse-5>"  #'pdf-view-next-line-or-next-page
   :n "s-<mouse-4>"  #'pdf-view-previous-line-or-previous-page
   ;; :n "."            #'hydra-pdftools/body
   ))

;; (eval-after-load 'interleave
;; (add-hook 'pdf-view-mode-hook #'brust-pdf-tools-hook t))

(defun brust-image-backward-hsroll-5 (args)
  (interactive "p")
  (brust-by-five #'image-backward-hscroll args))
(defun brust-image-forward-hsroll-5 (args)
  (interactive "p")
  (brust-by-five #'image-forward-hscroll args))
(defun brust-pdf-view-next-line-or-next-page-5 (args)
  (interactive "p")
  (brust-by-five #'pdf-view-next-line-or-next-page args))
(defun brust-pdf-view-previous-line-or-previous-page-5 (args)
  (interactive "p")
  (brust-by-five #'pdf-view-previous-line-or-previous-page args))

(use-package! screenshot
  :commands screenshot
  :init
  ;; TODO Check whether it is still needed.
  (advice-once 'screenshot :before #'load-screenshot)
  (defun load-screenshot nil
    (load-file (locate-library "screenshot.el")))
  )

(use-package! wgrep
  :defer t
  :config
  (setq wgrep-auto-save-buffer t
        wgrep-enable-key "r"))

(use-package! visual-regexp
  :commands (vr/replace vr/query-replace))

(use-package! zoom
  :defer t
  :init
  (setq zoom-size '(0.618 . 0.618)
        zoom-ignored-major-modes '("dired-mode"
                                   "ediff-mode"
                                   ;; "eshell-mode"
                                   ;; "neotree-mode"
                                   "sr-speedbar-mode")
        zoom-ignored-buffer-name-regexps '("^*calc" "^\\*magit: +.*"))
  (add-hook! 'emacs-startup-hook (zoom-mode +1)))

(after! ediff
  (add-hook! 'ediff-before-setup-hook (zoom-mode -1))
  (add-hook! 'ediff-cleanup-hook (zoom-mode +1)))
