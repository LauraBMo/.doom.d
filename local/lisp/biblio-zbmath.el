;;; zbmath.el --- ZBMath backend for biblio.el

;; Copyright (C) 2022 Your Name

;; Author: Your Name <your@email.com>
;; Maintainer: Your Name <your@email.com>
;; URL: https://github.com/your-username/zbmath
;; Version: 0.1.0
;; Package-Requires: ((biblio "0.2"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a backend for the biblio.el package that searches ZBMath for
;; BibTeX entries.

;;; Code:

(require 'biblio-core)

;;; Variables

(defconst zbmath-api-base-url "https://api.zbmath.org/"
  "Base URL for the ZBMath API.")

;;; Functions

(defun zbmath-search (query)
  "Search ZBMath for BibTeX entries matching QUERY.
Returns a list of biblio-entry records."
  (let* ((url-request-method "GET")
         (url-request-extra-headers
          '(("Content-Type" . "application/x-www-form-urlencoded")))
         (url (concat zbmath-api-base-url "search/bibtex?q=" (url-encode-url query)))
         (response (url-retrieve-synchronously url))
         (results (with-current-buffer response
                    (goto-char (point-min))
                    (search-forward-regexp "\n\n")
                    (json-read)))
         (entries (alist-get 'items results)))
    (mapcar (lambda (entry)
              (make-biblio-entry
               :type (alist-get 'type entry)
               :format 'bibtex
               :data (alist-get 'bibtex entry)))
            entries)))

;;; Backend

;;;###autoload
(biblio-backend 'zbmath
  :name "ZBMath"
  :author '("Your Name")
  :version "0.1.0"
  :description "Search ZBMath for BibTeX entries."
  :url "https://zbmath.org/"
