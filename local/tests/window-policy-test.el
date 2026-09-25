;;; window-policy-test.el --- deterministic check for the window-placement policy
;;
;;   emacs -Q --batch -l ~/.config/doom/local/tests/window-policy-test.el ; echo "exit=$?"
;;
;; Exit code is the verdict: 0 = every case passed, 1 = something failed.
;;
;; WHAT IT CHECKS, both from config.org, section "Change a few defaults >> Window
;; display":
;;
;;   1. `my/display-buffer-max-two-windows' itself -- which pane a new buffer
;;      lands in, and that a THIRD window never appears;
;;   2. the one exception to it: a buffer being *read* -- `my/in-place-modes',
;;      helpful, the Julia doc buffers and the Doom dashboard -- takes the window
;;      it was asked from instead of the pane beside it. A case for each of the
;;      three: both kinds of link followed in a real helpful buffer, a stand-in in
;;      `brust-julia-doc-mode', and the `find-file' a dashboard click runs (the
;;      real dashboard needs Doom, so its clicks are driven on a stand-in buffer
;;      in `+dashboard-mode');
;;   3. and that the exception is scoped to reading: an unrelated buffer landing
;;      while documentation is selected obeys the policy instead.
;;
;; HOW THE CODE GETS HERE.  The forms are read out of config.org -- no copy, so
;; this tests the bytes you will tangle -- and each is checked against the one
;; expected next: an unbalanced `defun' makes `read' swallow what follows, so the
;; block would still "work" while quietly losing the `add-to-list' (that happened
;; once; see CONFIG-NOTES.org).
;;
;; The helpful cases run the REAL helpful package, so Doom's straight build
;; directory goes on `load-path' and this file needs a Doom install to run; it is
;; not standalone.  Helpful names its buffers itself ("*helpful function: car*",
;; but "*helpful command: ...*" for a command), so where the name is not certain a
;; case picks the buffer up from the window instead.
;;
;; Geometry: batch frames are 80 columns wide, so `split-width-threshold' 40
;; stands in for "there is room to split" and 1000 for "there is not".  Those
;; numbers only choose the branch; what is under test is which window ends up
;; showing which buffer.

(require 'cl-lib)
(require 'seq)

;;; Setup

(defconst my/config-org
  (expand-file-name "../../config.org"
                    (file-name-directory (or load-file-name buffer-file-name)))
  "The literate config the forms are read from.")

(defun my/straight-build-dir ()
  "Doom's straight build directory for this Emacs, else the newest one."
  (let* ((root (expand-file-name "~/.config/emacs/.local/straight"))
         (exact (expand-file-name (format "build-%d.%d"
                                          emacs-major-version emacs-minor-version)
                                  root))
         (all (sort (seq-filter #'file-directory-p
                                (directory-files root t "\\`build-"))
                    #'string<)))
    (or (and (file-directory-p exact) exact)
        (car (last all))
        (error "No straight build directory under %s" root))))

(defun my/load-helpful ()
  "Put Doom's built packages on `load-path' and load helpful from there."
  (let ((build (my/straight-build-dir)))
    (dolist (dir (directory-files build t))
      (when (and (file-directory-p dir)
                 (not (member (file-name-nondirectory dir) '("." ".."))))
        (push dir load-path)))
    (require 'helpful))
  (unless (featurep 'helpful)
    (error "helpful did not load from %s" (my/straight-build-dir))))

;;; The forms, straight out of config.org

(defconst my/expected-forms
  '((defconst . my/in-place-modes)
    (defun . my/in-place-window-p)
    (defun . my/display-buffer-max-two-windows)
    (add-to-list . display-buffer-alist))
  "Forms expected in config.org, in order, as (HEAD . NAME).")

(defun my/form-name (form)
  "The name FORM introduces, for `my/expected-forms'; nil if it is not one of them."
  (pcase (car-safe form)
    ((or 'defun 'defconst) (nth 1 form))
    ('add-to-list (nth 1 (nth 1 form)))))

(defun my/read-config-forms ()
  "Read and check every policy form in `my/config-org', in order."
  (let ((expected my/expected-forms)
        forms)
    (with-temp-buffer
      (insert-file-contents my/config-org)
      (goto-char (point-min))
      (unless (search-forward "(defconst my/in-place-modes" nil t)
        (error "%s: policy block not found" my/config-org))
      (goto-char (match-beginning 0))
      (while expected
        (let* ((want (car expected))
               (form (read (current-buffer)))
               (got (my/form-name form)))
          (unless (eq got (cdr want))
            (error "Expected %s %s, read %S instead -- an unbalanced form earlier in the block swallows it"
                   (car want) (cdr want) form))
          (push form forms))
        (setq expected (cdr expected)))
      (nreverse forms))))

(my/load-helpful)
(dolist (form (my/read-config-forms))
  (eval form t))

;;; Harness

(defvar my/test-failures 0)

(defun my/check (name expected got)
  (if (equal expected got)
      (princ (format "PASS  %-38s %S\n" name got))
    (setq my/test-failures (1+ my/test-failures))
    (princ (format "FAIL  %-38s expected %S, got %S\n" name expected got))))

(defconst my/test-buffers '("*A*" "*B*" "*C*" "*source.el*" "*dash*" "*doc*")
  "Buffers the cases below display; reset (and emptied) before each one.")

(defun my/reset-buffers ()
  "A clean slate: no dedicated windows and no leftover displayable buffer.
A leftover *helpful* buffer would be found by `display-buffer-reuse-window'
and quietly change the answer, so those go too.  The stand-in buffers get
their major mode back too: two of the cases below put `+dashboard-mode' and
`brust-julia-doc-mode' into one of `my/test-buffers', and a mode left behind
would make the next case read as documentation."
  (dolist (w (window-list nil 'nomini))
    (set-window-dedicated-p w nil))
  (dolist (b (buffer-list))
    (when (and (or (string-prefix-p "*helpful" (buffer-name b))
                   (equal (buffer-name b) "helpful.el"))
               (not (buffer-modified-p b)))
      (kill-buffer b)))
  (dolist (name my/test-buffers)
    (with-current-buffer (get-buffer-create name)
      (setq buffer-read-only nil)
      (setq major-mode 'fundamental-mode)
      (erase-buffer))))

(defun my/state ()
  "Geometry, not selection order: (FIRST SECOND LAYOUT COUNT).
FIRST/SECOND are the buffer names read top-left to bottom-right: for a
side-by-side split that is (LEFT RIGHT), for a stacked one (TOP BOTTOM),
for a single window just (THE ONE).  `window-list' starts at the selected
window and wraps, so it cannot be used for this."
  (let* ((ws (window-list nil 'nomini))
         (sorted (sort (copy-sequence ws)
                       (lambda (a b)
                         (let ((ea (window-edges a))
                               (eb (window-edges b)))
                           (or (< (nth 0 ea) (nth 0 eb))
                               (and (= (nth 0 ea) (nth 0 eb))
                                    (< (nth 1 ea) (nth 1 eb))))))))
         (names (mapcar (lambda (w) (buffer-name (window-buffer w))) sorted)))
    (append names
            (list (cond ((null (cdr ws)) 'single)
                        ((and (= (nth 0 (window-edges (car ws)))
                                 (nth 0 (window-edges (cadr ws))))
                              (= (nth 2 (window-edges (car ws)))
                                 (nth 2 (window-edges (cadr ws)))))
                         'stacked)
                        ((and (= (nth 1 (window-edges (car ws)))
                                 (nth 1 (window-edges (cadr ws))))
                              (= (nth 3 (window-edges (car ws)))
                                 (nth 3 (window-edges (cadr ws)))))
                         'side-by-side)
                        (t 'unknown))
                  ;; The window count is what catches a third window.
                  (length ws)))))

(defun my/one-window (buf)
  "A sole window showing BUF."
  (my/reset-buffers)
  (delete-other-windows)
  (setq split-width-threshold 40
        split-height-threshold nil)
  (switch-to-buffer buf))

(defun my/two-windows (left-buf right-buf &optional dedicated-right)
  "Side-by-side LEFT-BUF | RIGHT-BUF, left selected.  Returns (LEFT RIGHT)."
  (my/one-window left-buf)
  (let* ((l (selected-window))
         (r (split-window l nil 'right)))
    (set-window-buffer r right-buf)
    (select-window l)
    (when dedicated-right (set-window-dedicated-p r t))
    (list l r)))

(defun my/find-navigate-button (buffer)
  "The first \"defined in foo.el\" button in BUFFER, or nil.
Those are the buttons `helpful--navigate' acts on; they are the only ones
carrying a `path' property."
  (with-current-buffer buffer
    (let ((pos (point-min)) found b)
      (while (and (not found) (< pos (point-max)))
        (setq b (next-button pos t))    ; t: a button sitting at POS counts too
        (cond ((null b) (setq pos (point-max)))
              ((button-get b 'path) (setq found b))
              (t (setq pos (1+ (button-end b))))))
      found)))

;;; 1. The policy itself

;; 1. Sole window, split possible -> split to the right, buffer on the RIGHT.
(my/one-window "*A*")
(display-buffer "*B*")
(my/check "1  sole window, split" '("*A*" "*B*" side-by-side 2) (my/state))

;; 2. Two windows, left selected -> the right pane takes it, still two windows.
(my/two-windows "*A*" "*C*")
(display-buffer "*B*")
(my/check "2  left selected" '("*A*" "*B*" side-by-side 2) (my/state))

;; 3. Two windows, right selected -> that pane takes it, no third window.
(let* ((wins (my/two-windows "*A*" "*C*"))
       (r (cadr wins)))
  (select-window r)
  (display-buffer "*B*")
  (my/check "3  rightmost selected" '("*A*" "*B*" side-by-side 2) (my/state))
  (my/check "3b selected pane unchanged" t (eq (selected-window) r)))

;; 4. Buffer already on screen (left pane) while the right is selected
;;    -> reuse it, do not move it and do not show it twice.
(my/two-windows "*B*" "*C*")
(select-window (cadr (window-list nil 'nomini)))  ; right window
(display-buffer "*B*")
(my/check "4  already visible, left alone" '("*B*" "*C*" side-by-side 2) (my/state))

;; 5. Right pane dedicated (side windows: treemacs, pdf-tools, Claude with
;;    use-side-window t) -> leave it alone, use the selected pane instead.
(let* ((wins (my/two-windows "*A*" "*C*" 'dedicated))
       (r (cadr wins)))
  (display-buffer "*B*")
  (my/check "5  dedicated pane untouched"
            '("*B*" "*C*" side-by-side 2 t)
            (append (my/state) (list (window-dedicated-p r)))))

;; 5b. The mirror image, the hole that was closed 2026-09-25: the SELECTED pane
;;     is the dedicated one.  It must not be written into and the default chain
;;     must not be reached either -- that used to split a third window.
(let* ((wins (my/two-windows "*A*" "*C*" 'dedicated))
       (r (cadr wins)))
  (select-window r)                        ; the dedicated window is selected
  (display-buffer "*B*")
  (my/check "5b selected pane dedicated, 2 windows"
            '("*B*" "*C*" side-by-side 2 t)
            (append (my/state) (list (window-dedicated-p r)))))

;; 6. Sole window, no room side-by-side -> MEASURED: `split-window-sensibly'
;;    third branch splits the sole usable window anyway, stacked, ignoring
;;    split-height-threshold. So the buffer lands BELOW, not to the right.
(my/one-window "*A*")
(setq split-width-threshold 1000)
(display-buffer "*B*")
(my/check "6  no room: stacks instead" '("*A*" "*B*" stacked 2) (my/state))

;; 7. Caller insists on another window while the selected one is rightmost
;;    -> the left pane is the only other one.
(my/two-windows "*A*" "*C*")
(select-window (cadr (window-list nil 'nomini)))
(display-buffer "*B*" '(nil (inhibit-same-window . t)))
(my/check "7  inhibit-same-window" '("*B*" "*C*" side-by-side 2) (my/state))

;; 8. Re-displaying the buffer of the current pane -> nothing moves, no dup.
(my/two-windows "*A*" "*B*")
(display-buffer "*A*")
(my/check "8  re-display current pane" '("*A*" "*B*" side-by-side 2) (my/state))

;;; 2. Links inside a helpful buffer

;; H1. Opening help from a source file in a sole window: the policy still
;;     applies -- help opens in a new pane on the right, source stays visible.
(my/one-window "*source.el*")
(helpful-callable 'car)
(my/check "H1 open help: policy, splits right"
          '("*source.el*" "*helpful function: car*" side-by-side 2) (my/state))

;; H2. A symbol link inside that help, in the selected (rightmost) pane: the
;;     target replaces the help in place, no third window, source untouched.
(helpful-callable 'cdr)
(my/check "H2 symbol link: in place"
          '("*source.el*" "*helpful function: cdr*" side-by-side 2) (my/state))
(my/check "H2 the pane keeps the click"
          "*helpful function: cdr*" (buffer-name (window-buffer (selected-window))))

;; H3. The case that started this: help ALONE in a single-window frame.  A link
;;     replaces it there rather than splitting the frame -- what built-in
;;     `help-mode' does, since it reuses its one *Help* buffer, while helpful
;;     makes a new buffer per symbol and so has nothing to reuse.
(my/one-window "*source.el*")
(helpful-callable 'car)
(delete-other-windows)                  ; keep the help window, now alone
(my/check "H3 setup: help alone" '("*helpful function: car*" single 1) (my/state))
(helpful-callable 'cdr)
(my/check "H3 symbol link: stays one window"
          '("*helpful function: cdr*" single 1) (my/state))

;; H4. The other door: "defined in foo.el" goes through `helpful--navigate'.
;;     Same window too -- here the real button, out of the real help buffer for
;;     a function that does have a source file.  The buffer is taken from the
;;     window rather than named: helpful picks the name itself, and it is
;;     "*helpful command: ...*" for a command, "*helpful function: ...*" for a
;;     plain function.
(my/one-window "*source.el*")
(helpful-callable 'helpful-callable)
(delete-other-windows)
(let ((help (window-buffer (selected-window))))
  (my/check "H4 setup: helpful-mode in the sole window"
            t (eq 'helpful-mode (buffer-local-value 'major-mode help)))
  (my/check "H4 setup: one window" 1 (length (window-list nil 'nomini)))
  (with-current-buffer help
    (let ((button (my/find-navigate-button help)))
      (cond ((null button)
             (my/check "H4 file link: button found" 'found 'missing))
            (t
             ;; `push-button' acts on a text-property button in the current
             ;; buffer, which is why this runs inside the help buffer.
             (push-button (button-start button))
             (my/check "H4 file link: same window"
                       '("helpful.el" single 1) (my/state)))))))

;; H5. A dedicated pane showing help (a side window, say) is never written into,
;;     whatever the policy above says: the link goes to the frame's other pane.
(my/two-windows "*source.el*" "*scratch*")
(helpful-callable 'car)                 ; left selected -> help lands right
(set-window-dedicated-p (selected-window) t)
(helpful-callable 'cdr)                 ; the pane is dedicated and selected
(my/check "H5 dedicated help pane untouched"
          '("*helpful function: cdr*" "*helpful function: car*" side-by-side 2)
          (my/state))

;; H6. The exception is scoped by what is *read*, not by who asked -- the whole
;;     difference from the doors it replaced.  An unrelated buffer arriving while
;;     documentation is selected follows the exception; where the docs are
;;     rightmost that is the pane the policy would have taken anyway, so only
;;     the left-hand geometry shows the change.
(my/one-window "*source.el*")
(helpful-callable 'car)
(display-buffer "*B*")
(my/check "H6a unrelated buffer, help rightmost"
          '("*source.el*" "*B*" side-by-side 2) (my/state))

;; H6b. The cost accepted with the simplification, stated as a case so it cannot
;;      change unnoticed: help on the LEFT loses its own pane to the arriving
;;      buffer instead of the pane beside it.
(my/one-window "*source.el*")
(helpful-callable 'car)
(let* ((r (selected-window))
       (l (window-in-direction 'left r)))
  (set-window-buffer l (get-buffer "*helpful function: car*"))
  (set-window-buffer r "*source.el*")
  (select-window l)
  (display-buffer "*B*")
  (my/check "H6b unrelated buffer, help left: takes its pane"
            '("*B*" "*source.el*" side-by-side 2) (my/state)))

;; H7. The third entry of `my/in-place-modes', and the reason no Julia code
;;     binds anything for this any more: a doc buffer is the same question as a
;;     helpful one.  Single window, which is where the split used to happen.
(my/one-window "*source.el*")
(let ((doc (get-buffer-create "*doc*")))
  (with-current-buffer doc (setq major-mode 'brust-julia-doc-mode))
  (set-window-buffer (selected-window) doc)
  (display-buffer "*B*")
  (my/check "H7 doc buffer, single window: stays one" '("*B*" single 1) (my/state)))

;;; 3. Clicking an item on the Doom dashboard

;; What a dashboard click runs is `find-file' on the file the item names ("Open
;; private configuration" is config.org, "Open my org" is my.org), so unlike the
;; helpful cases there is no door to stand in for: the file and the rule are the
;; whole story, and what the click adds -- `+dashboard/push-button', reached by
;; the remap in `+dashboard-mode-map' -- only decides that `find-file' is what
;; runs.  The real dashboard needs Doom (the module, its icons,
;; `doom-fallback-buffer'), so these drive a stand-in buffer in
;; `+dashboard-mode', which is a real `define-derived-mode' from `special-mode'
;; (doom+/modules/ui/dashboard/config.el), so `derived-mode-p' answers about it
;; the way it will in a live session.

(defun my/dash-window (buf)
  "A sole window showing BUF, standing in for the dashboard."
  (my/one-window buf)
  (with-current-buffer buf (setq-local major-mode '+dashboard-mode))
  buf)

(defun my/dash-two-windows (other)
  "Two windows: the dashboard on the LEFT, selected, OTHER on the right."
  (my/two-windows "*dash*" other)
  (with-current-buffer "*dash*" (setq-local major-mode '+dashboard-mode)))

;; D1. The complaint: a click on a dashboard that fills the frame. The file
;;     takes the window whole -- no split, and no dashboard left beside it.
(my/dash-window "*dash*")
(find-file "helpful.el")
(my/check "D1 click on a lone dashboard" '("helpful.el" single 1) (my/state))

;; D2. With a second pane open, the dashboard's own pane takes the target and
;;     the pane beside it is left alone.
(my/dash-two-windows "*source.el*")
(find-file "helpful.el")
(my/check "D2 second pane open: in place"
          '("helpful.el" "*source.el*" side-by-side 2) (my/state))

;; D3. A target that is already on screen in the other pane is reused, not
;;     duplicated, and not moved.
(my/dash-two-windows "*B*")
(pop-to-buffer "*B*")
(my/check "D3 target already visible: reused"
          '("*dash*" "*B*" side-by-side 2) (my/state))

;; D4. The accepted cost in its dashboard form: the dashboard is normally the
;;     whole frame, so a buffer arriving from elsewhere takes it. Same answer as
;;     D1, from the same rule.
(my/dash-window "*dash*")
(display-buffer "*B*")
(my/check "D4 unrelated buffer, dashboard selected"
          '("*B*" single 1) (my/state))

;;; Verdict

(princ (format "\n%s\n"
               (if (zerop my/test-failures)
                   "ALL PASS"
                 (format "%d FAILURE(S)" my/test-failures))))
(kill-emacs (if (zerop my/test-failures) 0 1))
