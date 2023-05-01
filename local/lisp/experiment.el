;;; local/lisp/experiment.el -*- lexical-binding: t; -*-

(url-retrieve (biblio-zbmath--url "kleiman piene")
              (lambda (status)
                (message "The request is completed in %s seconds" status)
                (display-buffer (current-buffer))))
