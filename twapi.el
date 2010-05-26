(provide 'twapi)

;; Search Methods
(defun twitter-search (query &optional since)
  (twitter-request "GET" (twitter-url (format "%s" "search"))
		   :parameters '("since" since)))

(defun twitter-trends ()
  (twitter-request "GET" (twitter-url (format "%s" "trends"))
		   :parameters '()))

(defun twitter-trends-current (since)
  (twitter-request "GET" (twitter-url (format "%s/%s" "statuses" "user_timeline"))
		   :parameters '("since" since)))

(defun twitter-trends-daily (since)
  (twitter-request "GET" (twitter-url (format "%s/%s" "statuses" "user_timeline"))
		   :parameters '("since" since)))

(defun twitter-trends-weekly (since)
  (twitter-request "GET" (twitter-url (format "%s/%s" "statuses" "user_timeline"))
		   :parameters '("since" since)))

;; Timeline Methods
(defun twitter-public-timeline (since)
  (twitter-request "GET" (twitter-url (format "%s/%s" "statuses" "public_timeline"))
		   :parameters '("since" since)))

(defun twitter-friends-timeline (since)
  (twitter-request "GET" (twitter-url (format "%s/%s" "statuses" "friends_timeline"))
		   :parameters '("since" since)))

(defun twitter-user-timeline (&optional since)
  (twitter-request "GET" (twitter-url (format "%s/%s" "statuses" "user_timeline"))
		   :parameters '("since" since)))

(defun twitter-mentions (&optional since)
  (twitter-request "GET" (twitter-url (format "%s/%s" "statuses" "mentions"))
		   :parameters '("since" since)))

;; Status Methods
(defun twitter-show-status (status)
    (twitter-request "GET" (twitter-url (format "%s/%s" "statuses" "show"))
		     :parameters '("status" status)))

(defun twitter-update-status (status)
    (twitter-request "GET" (twitter-url (format "%s/%s" "statuses" "update"))
		     :parameters '("status" status)))

(defun twitter-destroy-status (status)
    (twitter-request "DELETE" (twitter-url (format "%s/%s" "statuses" "destroy"))
		     :parameters '("status" status)))

;; User Methods
(defun twitter-show-user (screen-name)
    (twitter-request "GET" (twitter-url (format "%s/%s" "users" "show"))
		     :parameters '("screen_name" screen-name)))

(defun twitter-show-friends (search-term)
    (twitter-request "GET" (twitter-url (format "%s/%s" "users" "show"))
		     :parameters '("search_term" search-term)))

;; Account Methods

;; Favorite Methods

;; Notification Methods

;; Block Methods

;; Saved Searches Methods

;; OAuth Methods
(defun twitter-oauth-request-token ()
    (twitter-request "GET" (twitter-url (format "%s/%s" "oauth" "request_token"))
		     :parameters '()))

(defun twitter-oauth-authorize ()
    (twitter-request "GET" (twitter-url (format "%s/%s" "oauth" "authorize"))
		     :parameters '()))

(defun twitter-oauth-authenticate ()
    (twitter-request "GET" (twitter-url (format "%s/%s" "oauth" "authenticate"))
		     :parameters '()))

(defun twitter-oauth-access-token ()
    (twitter-request "POST" (twitter-url (format "%s/%s" "oauth" "access_token"))
		     :parameters '()))

;; Help Methods
