;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el


;; WARNING: Disabling core packages listed in ~/.emacs.d/core/packages.el may
;; have nasty side-effects and is not recommended.

;; (disable-packages! forge cua preview flyspell-lazy)
(disable-packages! forge cua preview)


;; LaTeX stuff
(package! bratex :recipe (:host github :repo "sbrisard/bratex"))
;; Biblatex
;; Packages to retrieve bib entries from the web
;; Biblio is not working for crossref any more...
;; (package! org-ref) ;; But this is not working either
;; (package! bibretrieve) ;; For MathSciNet references
;; (package! biblio) ;; For all the others, mostly Crossref, ....
;; (package! ivy-bibtex) ;; For inserting cites

;; Downloading paper
(package! scihub :recipe (:host github :repo "emacs-pe/scihub.el"))
;; (package! lsp-latex :recipe (:host github :repo "ROCKTAKEY/lsp-latex"))
;; (package! org-ref) ;; it is way too heavy: it requires helm, helm-bibtex, parsebib, biblio, key-chord, pdf-tool

;; Handy tecosaur's packages:
;; take a screenshot of some code to share
(package! screenshot
  :recipe (:host github
           :repo "tecosaur/screenshot"))
;; Import any file to org mode
(package! org-pandoc-import
  :recipe (:host github
           :repo "tecosaur/org-pandoc-import"
           :files ("*.el" "filters" "preprocessors")))


;; Programing
;; Edit Maple .mpl files
(package! maplev :recipe (:host github :repo "JoeRiel/maplev"))
;; Edit POV-ray files
(package! pov-mode :recipe (:host github :repo "melmothx/pov-mode"))


;; Julia in Org-mode
;; Using vterm
;; (package! ob-julia-vterm :recipe (:host github :repo "shg/ob-julia-vterm.el")) ;; For ob-vterm-julia
;; (package! julia-vterm :recipe (:host github :repo "shg/julia-vterm.el")) ;; For ob-vterm-julia
;; Using ess
;; (package! ob-ess-julia :recipe (:type git :host github :repo "frederic-santos/ob-ess-julia" :includes (ob-julia)))
;; (package! ob-julia :recipe (:type git :host github :repo "nico202/ob-julia"))

;; Nyans
(package! nyan-mode)
(package! zone-nyan)

;; Miscelaneos
(package! keyfreq :recipe (:host github :repo "dacap/keyfreq"))
(package! visual-regexp)
(package! zoom)
;; (package! wc-mode :recipe (:host github :repo "bnbeckwith/wc-mode"))
;; (package! aggressive-indent) ;; use "= G" in normal mode

;; Try someday
;; (package! evil-tutor)
;; (package! esup)

;; Old stuff
;; (package! transpose-frame) ;; With evil rotate it is enogh
;; (package! company-statistics) ;; Doom uses https://github.com/raxod502/prescient.el
;; (package! company-box)
;; (package! company-tabnine)

;; (package! smerge-mode)
;; (package! wgrep)
;; (package! beacon)
;; (package! mu4e :recipe (:local-repo "~/src/mu4e")) ;; any way I need to add to load-path
;; (package! hydra)
;; (package! darktooth-theme)
;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)
