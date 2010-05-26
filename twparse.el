;;;; twparse.el -- Tweet parsing library
;;;; This file is part of Twitel (http://github.com/artagnon/twitel)

;; Copyright (C) 2009 Ramkumar R <artagnon@gmail.com>

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING. If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

(provide 'twparse)

(defvar *tweet-hashtable-select-keys*
  ;; Design based on Gravity
  (list "id"
        "favorited"
        "created_at"
        "source"
        "text"
        "in_reply_to_status_id"))

(defvar *user-hashtable-select-keys*
  ;; Design based on Gravity
  (list "id"
        "screen_name"
        "profile_image_url"
        "following"))

(defun master-parser (response-object)
  "Master response-object parser"
  (if (vector-or-char-table-p response-object)
      (loop for hashtable in vector-of-hashtables
         do (hashtable-parser hashtable))
      (hashtable-parser hashtable)))

(defun hashtable-parser (response-hashtable)
  "Crops, sanitizes, and enriches hashtable"
  (let* ((selected-hashtable (hashtable-parser-expander response-hashtable *tweet-hashtable-select-keys*))
         (user-entry (gethash "user" selected-hashtable)))
    ;; if the hashtable contains another "user" hashtable, parse that also
    (when user-entry
      (setf (gethash "user" selected-hashtable)
            (hashtable-parser-expander user-entry *user-hashtable-select-keys*)))
    selected-hashtable))

(defun hashtable-parser-expander (hashtable select-keys-list)
  (let ((hashtable (crop-hashtable hashtable select-keys-list)))
    (maphash (lambda (k v) (setf (gethash k hashtable) (decode-html-entities v))) hashtable)
    (enrich-hashtable hashtable)
    hashtable))

(defun crop-hashtable (hashtable select-keys)
  (let ((cropped-hashtable (make-hash-table :test 'equal)))
    (loop
       for crop-key in select-keys
       do (cond
            ((or (gethash crop-key hashtable) (nth-value 1 (gethash crop-key hashtable)))
             (setf (gethash crop-key cropped-hashtable)
                   (gethash crop-key hashtable)))))
    cropped-hashtable))

(defun enrich-hashtable (hashtable)
  nil)

(defun make-clickable (text-snippet begin end target-uri custom-face)
  ;; make screen-name clickable
  (add-text-properties
   begin end
   `(mouse-face highlight
                face custom-face
                uri ,target-uri)
   text-snippet))

(defun screen-name-handler (screen-name)
  (make-clickable (screen-name 0 (length screen-name)
                               (concat "http://twitter.com/" screen-name)
                               twittering-username-face)))

(defun source-handler (source-text)
  (if (string-match "<a href=\"\\(.*\\)\">\\(.*\\)</a>" source)
      (let ((uri (match-string-no-properties 1 source))
            (caption (match-string-no-properties 2 source)))
        (setq source caption)
        (make-clickable source 0 (length source) uri twittering-uri-face))))

(defun status-handler (text)
  (setq regex-index 0)
  (while regex-index
    (setq regex-index
          (string-match "@\\([_a-zA-Z0-9]+\\)\\|\\(https?://[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]+\\)"
                        text
                        regex-index))
    (when regex-index
      (let* ((matched-string (match-string-no-properties 0 text))
             (screen-name (match-string-no-properties 1 text))
             (uri (match-string-no-properties 2 text)))
        (add-text-properties
         (if screen-name
             (make-clickable text (+ 1 (match-beginning 0)) (match-end 0)
                             (concat "http://twitter.com/" screen-name)
                             twittering-uri-face)
             (make-clickable text (match-beginning 0) (match-end 0)
                             uri
                             twittering-uri-face))))
      (setq regex-index (match-end 0))))
  text)

(defmacro list-push (value listvar)
  `(setq ,listvar (cons ,value ,listvar)))

(defun decode-html-entities (encoded-str)
  (if encoded-str
      (let ((cursor 0)
            (found-at nil)
            (result '()))
        (while (setq found-at
                     (string-match "&\\(#\\([0-9]+\\)\\|\\([A-Za-z]+\\)\\);"
                                   encoded-str cursor))
          (when (> found-at cursor)
            (list-push (substring encoded-str cursor found-at) result))
          (let ((number-entity (match-string-no-properties 2 encoded-str))
                (letter-entity (match-string-no-properties 3 encoded-str)))
            (cond (number-entity
                   (list-push
                    (char-to-string
                     (twittering-ucs-to-char
                      (string-to-number number-entity))) result))
                  (letter-entity
                   (cond ((string= "gt" letter-entity) (list-push ">" result))
                         ((string= "lt" letter-entity) (list-push "<" result))
                         (t (list-push "?" result))))
                  (t (list-push "?" result)))
            (setq cursor (match-end 0))))
        (list-push (substring encoded-str cursor) result)
        (apply 'concat (nreverse result)))
      ""))
