(require 'json)
(require 'url)
(require 'parse-twresponse)
(require 'twhelper)
(require 'twinterface)
(require 'twhttp)

(defvar twitter-host "twitter.com")
(defvar twitter-search-host "search.twitter.com")
(defvar twitter-port 80)
(defvar twitter-user-agent "twitel")
(defvar twitter-proxy-use nil)
(defvar twitter-proxy-server nil)
(defvar twitter-proxy-port nil)
(defvar twitter-request-headers
  "HTTP headers to be used with corresponding HTTP requests"
  '(("GET" ("Accept" . "application/json, image/png"))
    ("POST" ("Content-type" . "application/json"))
    ("PUT" ("Content-type" . "application/json"))
    ("DELETE")))

(defun twitel-network-buffer ()
  "The network buffer in which twitel-proc runs"
  (get-or-generate-buffer "*twitel-network-buffer*"))

(defun twitel-proc-sentinel (proc stat &optional success-message)
  (condition-case err-signal
      (let ((header (twittering-get-response-header))
	    (status nil))
	(string-match "HTTP/1\.1 \\([a-z0-9 ]+\\)\r?\n" header)
	(setq status (match-string-no-properties 1 header))
	(case-string status
		     (("200 OK")
		      (message (if success-message success-message "Success: Post")))
		     (t (message status))))
    (error (message (prin1-to-string err-signal)))))

(defun twitel-init ()
  "Open a network stream, set process sentinel, and create cache directory"
  (if (twitter-proxy-use)
      (setq server twitter-proxy-server
	    port (if (integerp twitter-proxy-port)
		     (int-to-string twitter-proxy-port)
		     twittering-proxy-port))
      (setq server "twitter.com"
	    port 80))

  (setq twitel-proc
	(open-network-stream
	 "twitel-connection" (twitel-network-buffer) server port))
  (set-process-sentinel twitel-proc twitel-proc-sentinel)
  (if (file-directory-p "~/.twitel")
      nil
      (make-directory "~/.twitel"))

(defun twitel-authenticate ()
  "Twitter authentication interface. TODO: OAuth"
  (interactive (list (read-from-minibuffer "Twitter username: " twitter-username)
		     (read-from-minibuffer "Twitter password: " twitter-password)))))

(defun twitter-url (&optional (search nil) relative)
  "Generate a Twitter URL with an optional relative"
  (format "http://%s:%d/%s" (if search 'twitter-search-host 'twitter-host) twitter-port (or relative "")))

(defun twitter-response ()
  "Parsing the Twitter response returned in JSON")

(defun url-percent-encode (str &optional coding-system)
  (if (or (null coding-system)
	  (not (coding-system-p coding-system)))
      (setq coding-system 'utf-8))
  (mapconcat
   (lambda (c)
     (cond
      ((twittering-url-reserved-p c)
       (char-to-string c))
      ((eq c ? ) "+")
      (t (format "%%%x" c))))
   (encode-coding-string str coding-system)
   ""))

(defun twitter-request (http-method url &optional parameters)
  "Use HTTP METHOD to request URL with some optional parameters"
  (process-send-string twitel-proc
		       (concat http-method url (build-url-parameters parameters))))
