;;; julia-doc-test.el --- deterministic check for the Julia documentation buffer
;;
;;   emacs -Q --batch -l ~/.config/doom/local/tests/julia-doc-test.el ; echo "exit=$?"
;;
;; Exit code is the verdict: 0 = every case passed, 1 = something failed.
;;
;; WHAT IT CHECKS, from config.org, section "EmacsVTerm":
;;
;;   1. `brust-julia-doc--ref-target' -- which links are cross-references, and
;;      which symbol each one names;
;;   2. the click path.  This is the case that matters, because the honest
;;      mistake here is a link that computes the right target and still sends
;;      nothing: `make-text-button' without replacing shr's keymap leaves RET
;;      and mouse-2 on `shr-browse-url'.  So these cases click -- `push-button',
;;      the way RET does -- and check what came out, rather than inspecting the
;;      text properties the fix happens to install;
;;   3. `brust-julia-doc--show' on a real payload, which is the whole road the
;;      vterm escape takes: base64 in, JSON decoded, header and methods drawn,
;;      the REPL the payload arrived from remembered;
;;   4. `brust-julia-doc--send' -- that following a cross-reference really asks
;;      the REPL for that symbol, in the buffer the docs came from.
;;
;; HOW THE CODE GETS HERE.  As in window-policy-test.el: the forms are read out
;; of config.org, so this tests the bytes that will be tangled, and each is
;; checked against the one expected next -- an unbalanced `defun' makes `read'
;; swallow whatever follows, and the block would still "work" while quietly
;; losing that form.
;;
;; This file is not standalone: it needs config.org, and `shr' and `button',
;; which are Emacs's own.  It used to read the window policy out of config.org
;; as well, back when the doc buffers bound `display-buffer-overriding-action' to
;; show a followed link in place; the policy now asks the selected window's major
;; mode instead, so neither the Julia code nor this file touches that block.
;;
;; Nothing here talks to Julia.  The payload below is a fixture, and
;; `vterm-send-string' is replaced, so no REPL is needed and none is disturbed.

(require 'cl-lib)
(require 'seq)
(require 'shr)
(require 'button)

;;; Setup

(defconst jdoc/config-org
  (expand-file-name "../../config.org"
                    (file-name-directory (or load-file-name buffer-file-name)))
  "The literate config the forms are read from.")

(defconst jdoc/expected-forms
  '(require
    brust-julia-doc-follow-function
    brust-julia-doc--ref-target
    brust-julia-doc--follow-ref
    brust-julia-doc--linkify-refs
    brust-julia-doc-heading
    brust-julia-doc--payload
    brust-julia-doc--repl-buffer
    brust-julia-doc--back
    brust-julia-doc--forward
    brust-julia-doc--pending-back
    brust-julia-doc--nonempty
    brust-julia-doc-mode-map
    brust-julia-doc-mode
    brust-julia-doc-revert
    brust-julia-doc--visit
    brust-julia-doc-back
    brust-julia-doc-forward
    brust-julia-doc--open-source
    brust-julia-doc--insert-heading
    brust-julia-doc--insert-header
    brust-julia-doc--insert-methods
    brust-julia-doc--render
    brust-julia-doc--buffer-name
    brust-julia-doc--send
    brust-julia-doc--display
    brust-julia-doc--show
    brust-julia-doc--decode
    vterm)
  "Forms expected in the EmacsVTerm block, in order.")

(defun jdoc/form-name (form)
  "The name FORM introduces, for `jdoc/expected-forms'."
  (pcase (car-safe form)
    ((or 'defun 'defvar-local 'defvar 'defconst 'defface) (nth 1 form))
    ('define-derived-mode (nth 1 form))
    ('with-eval-after-load (nth 1 (nth 1 form)))
    (_ (car-safe form))))

(defun jdoc/region-after (marker)
  "The text of the elisp block that follows MARKER in config.org."
  (with-temp-buffer
    (insert-file-contents jdoc/config-org)
    (goto-char (point-min))
    (unless (search-forward marker nil t)
      (error "%s: %s not found" jdoc/config-org marker))
    (unless (search-forward "#+begin_src elisp\n" nil t)
      (error "%s: no elisp block after %s" jdoc/config-org marker))
    (let ((beg (point)))
      (unless (search-forward "#+end_src" nil t)
        (error "%s: block after %s never closed" jdoc/config-org marker))
      (buffer-substring-no-properties beg (match-beginning 0)))))

(defun jdoc/read-forms ()
  "Read and check every form of the EmacsVTerm block, in order."
  (let ((expected jdoc/expected-forms)
        forms)
    (with-temp-buffer
      (insert (jdoc/region-after "*** TODO EmacsVTerm"))
      (goto-char (point-min))
      (while expected
        (let* ((want (car expected))
               (form (read (current-buffer)))
               (got (jdoc/form-name form)))
          (unless (eq got want)
            (error "Expected %s, read %S instead -- an unbalanced form earlier in the block swallows it"
                   want form))
          (push form forms))
        (setq expected (cdr expected)))
      (unless (string-blank-p (buffer-substring-no-properties (point) (point-max)))
        (error "Forms after the last expected one -- extend `jdoc/expected-forms'"))
      (nreverse forms))))

(dolist (form (jdoc/read-forms))
  (eval form t))

;;; Harness

(defvar jdoc/failures 0)

(defun jdoc/check (name expected got)
  (if (equal expected got)
      (princ (format "PASS  %-42s %S\n" name got))
    (setq jdoc/failures (1+ jdoc/failures))
    (princ (format "FAIL  %-42s expected %S, got %S\n" name expected got))))

(defun jdoc/reset ()
  "Remove anything a previous case left behind.
A leftover doc buffer would be found by `display-buffer-reuse-window' and
quietly change where the next case lands."
  (dolist (b (buffer-list))
    (when (or (string-prefix-p "*julia-doc" (buffer-name b))
              (string-prefix-p "*jdoc" (buffer-name b)))
      (kill-buffer b))))

(defun jdoc/button-with (prop)
  "The first button in the current buffer carrying PROP, and its position."
  (let ((pos (point-min))
        found)
    (while (and (not found) (< pos (point-max)))
      (let ((b (next-button pos)))
        (cond ((null b) (setq pos (point-max)))
              ((button-get b prop) (setq found b))
              (t (setq pos (1+ (button-end b)))))))
    found))

(defun jdoc/rendered-p (phrase)
  "Non-nil when PHRASE appears in the current buffer's rendered text.
`shr-render-region' reflows: it puts a newline after every word, so
`search-forward' for a phrase of two words or more never matches.  Comparing
against the text with its newlines flattened is what the eye actually sees."
  (string-match-p (regexp-quote phrase)
                  (replace-regexp-in-string
                   "\n" " " (buffer-substring-no-properties (point-min) (point-max)))))

(defun jdoc/span-start (href)
  "Start of the first run of text in the current buffer whose `shr-url' is HREF."
  (let ((pos (point-min))
        found)
    (while (and (not found) (< pos (point-max)))
      (if (equal (get-text-property pos 'shr-url) href)
          (setq found pos)
        (setq pos (or (next-single-property-change pos 'shr-url) (point-max)))))
    found))

(defun jdoc/click-cross-references ()
  "Click every cross-reference button in the current buffer, in order.
Clicking rather than reading properties is the point: a link whose keymap is
still shr's looks identical on the page.  Nothing is returned -- the effect
lands in whatever the follow function records.

Only buttons carrying `brust-julia-doc-ref' are clicked.  A link we left to
shr is a button too (`next-button' finds it) but has no `action', so clicking
it signals `void-function nil' -- correct for shr to leave alone, and not
what this case is about."
  (let ((pos (point-min)))
    (while (< pos (point-max))
      (let ((b (next-button pos)))
        (if (null b)
            (setq pos (point-max))
          (setq pos (1+ (button-end b)))
          (when (button-get b 'brust-julia-doc-ref)
            (push-button (button-start b))))))))

;;; 1. Which links are cross-references

;; Julia's Markdown.html writes them two ways; both are measured, not guessed.
(jdoc/check "1a bare @ref      -> link text"
            "DomainError" (brust-julia-doc--ref-target "@ref" "DomainError"))
(jdoc/check "1b bare @ref, signature link"
            "sin(x)" (brust-julia-doc--ref-target "@ref" "sin(x)"))
(jdoc/check "1c bare @ref, qualified"
            "Base.sin" (brust-julia-doc--ref-target "@ref" "Base.sin"))
(jdoc/check "1d @ref with explicit target"
            "sin" (brust-julia-doc--ref-target "@ref sin" "the sine"))
(jdoc/check "1e explicit target, signature"
            "f(::Int)" (brust-julia-doc--ref-target "@ref f(::Int)" "f"))
;; Everything that is not a cross-reference must be left to shr.
(jdoc/check "1f an ordinary URL is not one"
            nil (brust-julia-doc--ref-target "https://example.com" "docs"))
(jdoc/check "1g nor an anchor"
            nil (brust-julia-doc--ref-target "#section" "there"))
;; The near-misses: a loose `string-prefix-p' would take both of these and hand
;; `@doc' the tail of the href.
(jdoc/check "1h @referenced is not a cross-reference"
            nil (brust-julia-doc--ref-target "@referenced" "x"))
(jdoc/check "1i a bare @ref with no text has no target"
            nil (brust-julia-doc--ref-target "@ref" "   "))
(jdoc/check "1j nor does an empty explicit target"
            nil (brust-julia-doc--ref-target "@ref " ""))

;;; 2. The click path, on HTML shr has rendered

(defconst jdoc/html
  (concat "<p>Throw a <a href=\"@ref\"><code>DomainError</code></a>, "
          "see <a href=\"@ref sin\">the sine</a> and "
          "<a href=\"https://example.com\">docs</a>.</p>")
  "A docstring fragment with each shape of link in it.")

(defvar jdoc/clicked nil)

(defun jdoc/record (target)
  (push target jdoc/clicked))

(defun jdoc/render-fixture ()
  "Render `jdoc/html' the way a doc buffer does, and linkify it.
Returns the buffer, left current."
  (let ((buffer (get-buffer-create "*jdoc-fixture*")))
    (with-current-buffer buffer
      (insert jdoc/html)
      (shr-render-region (point-min) (point-max))
      (setq jdoc/clicked nil)
      (brust-julia-doc--linkify-refs #'jdoc/record))
    buffer))

(jdoc/reset)
;; `with-current-buffer' unwinds, so the buffer the fixture builds has to be
;; entered again here -- the checks below run against whatever buffer is
;; current, and pointing them at the wrong one reports "no buttons" rather
;; than an error.
(with-current-buffer (jdoc/render-fixture)
  (goto-char (point-min))

  ;; The two links that point at Julia symbols, in buffer order.
  (jdoc/check "2a cross-references found"
              '("DomainError" "sin")
              (let ((pos (point-min)) found)
                (while (< pos (point-max))
                  (let ((b (next-button pos)))
                    (if (null b)
                        (setq pos (point-max))
                      (when (button-get b 'brust-julia-doc-ref)
                        (push (button-get b 'brust-julia-doc-ref) found))
                      (setq pos (1+ (button-end b))))))
                (nreverse found)))

  ;; RET on a cross-reference must reach the button, not shr -- this is the
  ;; assertion the half-fixed version fails.
  (goto-char (button-start (jdoc/button-with 'brust-julia-doc-ref)))
  (jdoc/check "2b RET on a cross-reference"
              'push-button (key-binding (kbd "RET")))
  (jdoc/check "2c TAB on a cross-reference"
              'forward-button (key-binding (kbd "TAB")))

  ;; And on the shr link that was left alone, RET is still shr's.  Read from
  ;; the span rather than from a button: an untouched shr link is not one, so
  ;; `next-button' never sees it.  (`text-property-any' is no good here: it
  ;; compares with `eq', and the href is a fresh string, not the literal.)
  (goto-char (jdoc/span-start "https://example.com"))
  (jdoc/check "2d RET on a URL is still shr's"
              'shr-browse-url (key-binding (kbd "RET")))

  ;; Clicking them -- through `push-button', which is what RET runs -- must
  ;; actually call the follow function, with the right symbols.
  (jdoc/click-cross-references)
  (jdoc/check "2e clicking reaches the sender"
              '("DomainError" "sin") (nreverse jdoc/clicked)))

;;; 3. A payload, end to end through `brust-julia-doc--show'

(defconst jdoc/payload
  (concat
   "{\"symbol\":\"sin\",\"binding\":\"Base.sin\",\"module\":\"Base\","
   "\"typesig\":\"Union{}\","
   "\"html\":\"<p>Compute sine of <code>x</code>, see "
   "<a href=\\\"@ref\\\"><code>sind</code></a>.</p>\","
   "\"results\":["
   "{\"sig\":\"sin(::Number)\",\"typesig\":\"Tuple{Number}\","
   "\"module\":\"Base.Math\",\"path\":\"math.jl\",\"file\":\"/tmp/math.jl\",\"line\":425},"
   "{\"sig\":\"sin(::Real)\",\"typesig\":\"Tuple{Real}\","
   "\"module\":\"Base.Math\",\"path\":\"math.jl\",\"file\":null,\"line\":440}]}")
  "What EmacsVterm.jl will send, with one method that has a file and one
that does not -- the second must not become a button that opens nothing.")

(defun jdoc/show (payload mime from-buffer)
  "Send PAYLOAD through the entry point, as the vterm filter would."
  (with-current-buffer from-buffer
    (brust-julia-doc--show
     "documentation" mime
     (base64-encode-string (encode-coding-string payload 'utf-8) t))))

(defvar jdoc/repl nil)
(jdoc/reset)
(setq jdoc/repl (get-buffer-create "*jdoc-repl*"))
(jdoc/show jdoc/payload "application/json" jdoc/repl)

(defvar jdoc/buffer (get-buffer "*julia-doc: sin*"))

(jdoc/check "3a buffer name from the symbol" t (and jdoc/buffer t))
(jdoc/check "3b it is in the mode"
            'brust-julia-doc-mode
            (and jdoc/buffer (buffer-local-value 'major-mode jdoc/buffer)))
(jdoc/check "3c the REPL it came from is remembered"
            "*jdoc-repl*"
            (and jdoc/buffer
                 (buffer-name (buffer-local-value 'brust-julia-doc--repl-buffer jdoc/buffer))))
(jdoc/check "3d `q' comes from special-mode"
            'quit-window
            (and jdoc/buffer (buffer-local-value 'brust-julia-doc-mode-map jdoc/buffer)
                 (lookup-key (buffer-local-value 'brust-julia-doc-mode-map jdoc/buffer)
                             (kbd "q"))))

(with-current-buffer (or jdoc/buffer (get-buffer-create "*jdoc-missing*"))
  (goto-char (point-min))
  (jdoc/check "3e header names the binding"
              t (and (search-forward "Base.sin" nil t) t))
  (goto-char (point-min))
  (jdoc/check "3f and where it is defined"
              t (and (search-forward "Defined in:  Base" nil t) t))
  (goto-char (point-min))
  (jdoc/check "3g Union{} is not shown as a signature"
              nil (and (search-forward "Signature" nil t) t))
  (goto-char (point-min))
  (jdoc/check "3h a Documentation heading"
              t (and (search-forward "Documentation" nil t) t))
  (jdoc/check "3i the docstring itself is rendered"
              t (and (jdoc/rendered-p "Compute sine of") t))
  (goto-char (point-min))
  (jdoc/check "3j a Methods heading, counted"
              t (and (search-forward "Methods (2)" nil t) t))
  (goto-char (point-min))
  ;; Only the method whose file is known carries the button properties.
  (let ((with-file (jdoc/button-with 'brust-julia-doc-file)))
    (jdoc/check "3k method with a file is a button"
                '("/tmp/math.jl" 425)
                (and with-file
                     (list (button-get with-file 'brust-julia-doc-file)
                           (button-get with-file 'brust-julia-doc-line)))))
  ;; A cross-reference inside the docstring is linkified in the payload case too.
  (goto-char (point-min))
  (jdoc/check "3l docstring cross-reference still linkified"
              t (and (jdoc/button-with 'brust-julia-doc-ref) t)))

;; The text/html road, which is what an EmacsVterm.jl without the JSON half
;; sends: it must still render rather than error.
(jdoc/reset)
(defvar jdoc/repl2 (get-buffer-create "*jdoc-repl*"))
(jdoc/show "<p>Only HTML here.</p>" "text/html" jdoc/repl2)
(jdoc/check "3m text/html still renders, under the plain name"
            '(t t)
            (let ((buffer (get-buffer "*julia-doc*")))
              (list (and buffer t)
                    (and buffer
                         (with-current-buffer buffer
                           (and (jdoc/rendered-p "Only HTML here.") t))))))

;;; 3n. What `?help' sends: nothing attached at all

;; Julia's help mode displays an `MD' of its own making -- it goes through
;; `REPL.helpmode', not `Docs.doc' -- so `symbol', `binding', `module' and
;; `typesig' carry nothing and there are no `results'.  This rendered badly
;; once: an empty string is *true* in elisp, so the guards of the shape
;; (when field ...) all passed and the buffer opened on a blank heading line
;; followed by "Defined in:  " and "Signature:   " with nothing after them,
;; named `*julia-doc: *' after the empty symbol.
;;
;; Julia now sends null for those fields, but only once its half is updated;
;; a Julia that still sends "" must render identically, so both are checked.

(defconst jdoc/no-annotation
  (concat "{\"symbol\":%s,\"binding\":%s,\"module\":%s,\"typesig\":%s,"
          "\"html\":\"<p>Compute sine of <code>x</code>.</p>\","
          "\"results\":[]}")
  "A payload with nothing attached; %s stands in for the four absent fields.")

(defun jdoc/bare-facts (absent)
  "Render the no-annotation payload with ABSENT in each absent field, and
report what the buffer holds."
  (jdoc/reset)
  (jdoc/show (format jdoc/no-annotation absent absent absent absent)
             "application/json" (get-buffer-create "*jdoc-repl*"))
  (let ((buffer (get-buffer "*julia-doc*")))
    (list :name (and buffer (buffer-name buffer))
          :first-line (and buffer
                           (with-current-buffer buffer
                             (goto-char (point-min))
                             (buffer-substring-no-properties
                              (line-beginning-position) (line-end-position))))
          ;; Any line that is a heading with nothing after it.
          :empty-headers (and buffer
                              (with-current-buffer buffer
                                (seq-some (lambda (line)
                                            (string-match-p
                                             "\\`\\(Defined in:\\|Signature:\\|Methods\\)[ \t]*\\'"
                                             line))
                                          (split-string
                                           (buffer-substring-no-properties
                                            (point-min) (point-max))
                                           "\n"))))
          :has-doc (and buffer
                        (with-current-buffer buffer
                          (and (jdoc/rendered-p "Compute sine of") t))))))

;; The up-to-date Julia.
(let ((facts (jdoc/bare-facts "null")))
  (jdoc/check "3n null: the plain buffer name" "*julia-doc*" (plist-get facts :name))
  (jdoc/check "3n null: opens on the first heading"
              "Documentation" (plist-get facts :first-line))
  (jdoc/check "3n null: no heading with an empty value"
              nil (plist-get facts :empty-headers))
  (jdoc/check "3n null: the docstring still renders"
              t (plist-get facts :has-doc)))

;; A Julia that has not been updated yet.
(let ((facts (jdoc/bare-facts "\"\"")))
  (jdoc/check "3o \"\": the same plain buffer name" "*julia-doc*" (plist-get facts :name))
  (jdoc/check "3o \"\": opens on the first heading"
              "Documentation" (plist-get facts :first-line))
  (jdoc/check "3o \"\": no heading with an empty value"
              nil (plist-get facts :empty-headers))
  (jdoc/check "3o \"\": the docstring still renders"
              t (plist-get facts :has-doc)))

;; And the same rule on its own, since it decides both the name and the header.
(jdoc/check "3p buffer name: a symbol" "*julia-doc: sin*"
            (brust-julia-doc--buffer-name '(:symbol "sin")))
(jdoc/check "3p buffer name: an empty symbol" "*julia-doc*"
            (brust-julia-doc--buffer-name '(:symbol "")))
(jdoc/check "3p buffer name: no symbol at all" "*julia-doc*"
            (brust-julia-doc--buffer-name '(:html "<p>x</p>")))
(jdoc/check "3p nonempty: a value" "sin" (brust-julia-doc--nonempty "sin"))
(jdoc/check "3p nonempty: empty is absent" nil (brust-julia-doc--nonempty ""))
(jdoc/check "3p nonempty: nil is absent" nil (brust-julia-doc--nonempty nil))

;;; 3q. The mode's own keys

;; These are worth checking here because they are now what *fires*: the map is
;; given precedence over evil's normal state (see "Evil mode >> Settings"), so
;; its contents are the observable behaviour rather than a shadowed intention.
(jdoc/check "3q RET follows" 'push-button
            (lookup-key brust-julia-doc-mode-map (kbd "RET")))
(jdoc/check "3q TAB walks" 'forward-button
            (lookup-key brust-julia-doc-mode-map (kbd "TAB")))
(jdoc/check "3q S-TAB walks back" 'backward-button
            (lookup-key brust-julia-doc-mode-map (kbd "<backtab>")))
(jdoc/check "3q n walks" 'forward-button
            (lookup-key brust-julia-doc-mode-map (kbd "n")))
(jdoc/check "3q p walks back" 'backward-button
            (lookup-key brust-julia-doc-mode-map (kbd "p")))
(jdoc/check "3q h goes back" 'brust-julia-doc-back
            (lookup-key brust-julia-doc-mode-map (kbd "h")))
(jdoc/check "3q l goes forward" 'brust-julia-doc-forward
            (lookup-key brust-julia-doc-mode-map (kbd "l")))
(jdoc/check "3q gr redraws" 'brust-julia-doc-revert
            (lookup-key brust-julia-doc-mode-map (kbd "gr")))

;; `g' has to stay a prefix.  A complete binding on `g' here would take evil's
;; `g' prefix with it and `gg' would ring the bell -- measured in a helpful
;; buffer, whose map binds `g' singly.
(jdoc/check "3q g is a prefix, not a binding" t
            (and (keymapp (lookup-key brust-julia-doc-mode-map (kbd "g"))) t))
;; And `r' is deliberately left to evil.
(jdoc/check "3q r is left alone" nil
            (lookup-key brust-julia-doc-mode-map (kbd "r")))

;;; 4. Following a cross-reference asks the right REPL

(defvar jdoc/sent nil)

(jdoc/reset)
(setq jdoc/repl (get-buffer-create "*jdoc-repl*"))
(jdoc/show jdoc/payload "application/json" jdoc/repl)
(with-current-buffer (get-buffer "*julia-doc: sin*")
  (goto-char (point-min))
  (let ((button (jdoc/button-with 'brust-julia-doc-ref)))
    (jdoc/check "4a the docstring link is there to follow" t (and button t))
    (setq jdoc/sent nil)
    (cl-letf (((symbol-function 'vterm-send-string)
               (lambda (string &optional paste)
                 (push (list string paste) jdoc/sent))))
      (push-button (button-start button)))
    (jdoc/check "4b following sends @doc to the REPL"
                '(("@doc sind\n" t))
                (nreverse jdoc/sent))
    (jdoc/check "4c and remembers where it came from"
                (buffer-name (current-buffer))
                (buffer-name brust-julia-doc--pending-back))))

;; A doc buffer with no live REPL must say so, not fail obscurely.
(with-current-buffer (get-buffer "*julia-doc: sin*")
  (setq brust-julia-doc--repl-buffer nil)
  (jdoc/check "4d a dead REPL is reported"
              '(user-error "The Julia REPL this documentation came from is gone")
              (condition-case e (brust-julia-doc--send "sin") (error e))))

;;; 5. Anything that is not documentation is left to julia-repl

;; `EmacsVterm.options.image = true' in this machine's startup.jl, so images
;; really do arrive down this same escape sequence.  They are not ours to
;; render; the delegation is what keeps them working, so it is worth a case.
;; (`julia-repl--show' is undefined in this harness -- julia-repl is not on
;; `load-path' here -- which is what lets 5b see the error branch.)
(jdoc/reset)
(defvar jdoc/delegated nil)
(setq jdoc/delegated nil)
(cl-letf (((symbol-function 'julia-repl--show)
           (lambda (kind mime data) (push (list kind mime data) jdoc/delegated))))
  (with-temp-buffer
    (brust-julia-doc--show "image" "image/png" "AAAA")))
(jdoc/check "5a an image is handed to julia-repl--show"
            '(("image" "image/png" "AAAA")) (nreverse jdoc/delegated))

;; `text-quoting-style' is pinned because Emacs rewrites the ` and ' in an
;; error message when it is *displayed*: the same call reports
;; "Unsupported data kind ‘nonsense’..." or "...`nonsense'..." depending on a
;; user setting, and comparing against either spelling would make this case
;; depend on whose Emacs ran it.
(jdoc/check "5b an unknown kind is reported, not swallowed"
            '(error "Unsupported data kind `nonsense' or MIME type `text/plain'")
            (let ((text-quoting-style 'grave))
              (condition-case e
                  (with-temp-buffer
                    (brust-julia-doc--show "nonsense" "text/plain" ""))
                (error e))))

;;; Verdict

(jdoc/reset)
(princ (format "\n%s\n"
               (if (zerop jdoc/failures)
                   "ALL PASS"
                 (format "%d FAILURE(S)" jdoc/failures))))
(kill-emacs (if (zerop jdoc/failures) 0 1))
