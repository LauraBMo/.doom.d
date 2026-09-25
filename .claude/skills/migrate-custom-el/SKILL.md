---
name: migrate-custom-el
description: Fold ~/.config/doom/custom.el back into config.org and delete it. Use whenever custom.el exists in the Doom user directory — a startup warning names it, its settings appearing twice (custom.el and config.org) shows it, or the user asks to migrate their customisations, or says settings ended up in custom.el again.
---

# Fold custom.el into config.org

Settings in this config live in `config.org` — the org-tangled source of truth.
Emacs nevertheless writes two things to `$DOOMDIR/custom.el`:

- what the **Customize** UI saves (`custom-set-variables`, `custom-set-faces`,
  `custom-set-faces`), and
- what answering **`!`** ("always safe") at a file-local-variable prompt appends
  (`en/disable-command` writes to `custom-file`, which Doom's advice points at
  `custom.el` — `doom-emacs.el:288-292`, with `custom-file` set at `:284`).

So `custom.el` is a *transient* file: it is ignored by git, and a startup check
in `config.org` (search for `my/custom-file`) raises a warning whenever it
exists. This skill is what removes it again, by moving what it holds into
`config.org`.

## Procedure

1. Read `custom.el` (in this repo, `~/.config/doom/custom.el`). Note its mtime —
   if it is older than the last migration something else wrote it, and it is
   worth asking before touching anything.
2. Sort each entry by what it is, and place it — with the Edit tool, never a
   script that rewrites the file — at the matching anchor in `config.org`:

   | In custom.el | Where it goes in config.org |
   |---|---|
   | `custom-set-faces` entries | the `** Faces` block (the `(custom-set-faces …)` form) |
   | `custom-set-variables` entries | the `(setq …)` block under `** Set some vars`, as a `VAR VALUE` pair |
   | `safe-local-variable-values` pairs | that same `(setq …)` block, at the `;; Local Variables` comment |
   | `(put 'CMD 'disabled t)` / `… nil` | the `** Enabling` block, which already holds `(put 'erase-buffer 'disabled nil)` |
   | anything else | show it to the user and ask — do not guess |

   Add a one-line comment for any entry whose reason is not obvious from the
   value; a bare pair of hex colours tells the next reader nothing.
3. **Check for duplicates first.** Faces arrive from the Customize UI *after*
   they were written into config.org by hand, so the entry is often already
   there and identical — all three faces on 2026-09-25 were. Only add what is
   genuinely missing.
4. Re-tangle, because `config.org` alone changes nothing:
   - if an Emacs session with that file open is reachable, revert the buffer
     first (`revert-buffer`) — tangling reads the buffer, not the disk — then
     `M-x org-babel-tangle`;
   - otherwise a batch Emacs tangles the file directly:
     `emacs -Q --batch --eval '(org-babel-tangle-file "config.org")'`.
   Saving the buffer also retangles, asynchronously, via the `:config literate`
   module — see CONFIG-NOTES.org for why that is worth knowing.
5. Verify by reading the settings back, not by `git diff`: neither `config.el`
   nor `packages.el` is tracked any more, so git shows nothing about either. Read
   the moved value out of `config.el` (or re-evaluate the form from `config.org`),
   and have it confirmed in a *fresh* Emacs — the user tests that way. The value
   in the current session comes from whatever custom.el held when it started, so
   it proves nothing. To see what a retangle actually changed, tangle to a scratch
   file and compare: `emacs -Q --batch --eval '(org-babel-tangle-file "config.org" "/tmp/tangled.el")'`.
6. Delete `custom.el` (`rm`), then report what moved where. Nothing else needs
   cleaning up: the file is gitignored, and it will not be recreated until
   something writes a customisation again.
