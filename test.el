(defun master-test ()
  "Testcase: Tree"
  (setf response-hashtable (make-hash-table :test 'equal))
  (setf user-hashtable (make-hash-table :test 'equal))
  (setf (gethash "text" response-hashtable) "RT @aditya \"Do not try and bend the list. It's impossible. Instead, only try to realize the truth\" \"What truth?\" \"There is no list\" http:\/\/is.gd\/1ihyb @ghoseb @aatifh")
  (setf (gethash "screen_name" user-hashtable) "artagnon")
  (setf (gethash "junk_key" response-hashtable) "morejunk")
  (setf (gethash "source" response-hashtable) "<a href=\"http:\/\/mobileways.de\/gravity\">Gravity<\/a>")
  (setf (gethash "user" response-hashtable) user-hashtable)
  (hashtable-parser response-hashtable))

(defun test-web-source ()
  "Testcase: Tree"
  (setf response-hashtable (make-hash-table :test 'equal))
  (setf user-hashtable (make-hash-table :test 'equal))
  (setf (gethash "text" response-hashtable) "RT @aditya \"Do not try and bend the list. It's impossible. Instead, only try to realize the truth\" \"What truth?\" \"There is no list\" http:\/\/is.gd\/1ihyb")
  (setf (gethash "screen_name" user-hashtable) "artagnon")
  (setf (gethash "junk_key" response-hashtable) "morejunk")
  (setf (gethash "source" response-hashtable) "web")
  (setf (gethash "user" response-hashtable) user-hashtable)
  (hashtable-parser response-hashtable))

(defun test-without-tree ()
  "Testcase: No tree"
  (setf response-hashtable (make-hash-table :test 'equal))
  (setf user-hashtable (make-hash-table :test 'equal))
  (setf (gethash "text" response-hashtable) "\"Do not try and bend the list. It's impossible. Instead, only try to realize the truth\" \"What truth?\" \"There is no list\" http:\/\/is.gd\/1ihyb")
  (setf (gethash "screen_name" user-hashtable) "artagnon")
  (setf (gethash "junk_key" response-hashtable) "morejunk")
  (hashtable-parser response-hashtable))

(defun test-master-parser ()
  "Testcase: List of hashtables"
  (let ((list-of-hashtables '()))
    (setf response-hashtable (make-hash-table :test 'equal))
    (setf user-hashtable (make-hash-table :test 'equal))
    (setf (gethash "text" response-hashtable) "RT @aditya \"Do not try and bend the list. It's impossible. Instead, only try to realize the truth\" \"What truth?\" \"There is no list\" http:\/\/is.gd\/1ihyb @ghoseb @aatifh")
    (setf (gethash "screen_name" user-hashtable) "artagnon")
    (setf (gethash "junk_key" response-hashtable) "morejunk")
    (setf (gethash "source" response-hashtable) "<a href=\"http:\/\/mobileways.de\/gravity\">Gravity<\/a>")
    (setf (gethash "created_at" response-hashtable) "Mon Jul 04 10:56:41 +0000 2009")
    (setf (gethash "user" response-hashtable) user-hashtable)
    (push response-hashtable list-of-hashtables)
    (master-parser list-of-hashtables)))

(defun test-master-parser-dp ()
  "Testcase: List of hashtables with DP"
  (let ((list-of-hashtables '()))
    (setf response-hashtable (make-hash-table :test 'equal))
    (setf user-hashtable (make-hash-table :test 'equal))
    (setf (gethash "text" response-hashtable) "RT @aditya \"Do not try and bend the list. It's impossible. Instead, only try to realize the truth\" \"What truth?\" \"There is no list\" http:\/\/is.gd\/1ihyb @ghoseb @aatifh")
    (setf (gethash "junk_key" response-hashtable) "morejunk")
    (setf (gethash "source" response-hashtable) "<a href=\"http:\/\/mobileways.de\/gravity\">Gravity<\/a>")
    (setf (gethash "created_at" response-hashtable) "Tue Jul 07 04:56:41 +0000 2009")
    (setf (gethash "id" response-hashtable) "2391590544")
    (setf (gethash "screen_name" user-hashtable) "artagnon")
    (setf (gethash "profile_image_url" user-hashtable) "http:\/\/s3.amazonaws.com\/twitter_production\/profile_images\/79367886\/artagnon_normal.jpg")
    (setf (gethash "id" user-hashtable) "14888753")
    (setf (gethash "user" response-hashtable) user-hashtable)
    (push response-hashtable list-of-hashtables)
    (master-parser list-of-hashtables)))
