# notes
These are my notes, written in `org-mode` and published to HTML using `org-publish`.

## Configuration
This is the `org-publish` configuration used to publish these notes:

```elisp
;; Custom preamble with navigation and breadcrumbs
(defun my-org-html-preamble (plist)
  "Generate custom preamble with search bar, navigation, and breadcrumbs."
  (let* ((file (plist-get plist :input-file))
         (base-dir (plist-get plist :base-directory))
         (breadcrumbs nil))
    (when (and file base-dir)
      (let* ((base-dir-clean (file-name-as-directory base-dir))
             (rel-file (file-relative-name file base-dir-clean)))
        (setq breadcrumbs (my-generate-breadcrumbs rel-file base-dir-clean))))
    (concat
     ;; This div is where the Pagefind search bar will be rendered
     "<div id=\"search\"></div>"
     ;; Your existing breadcrumbs
     (when breadcrumbs
       (concat "<div class=\"breadcrumb\">" breadcrumbs "</div>")))))

;; Helper function to clean up directory names for display
(defun my-clean-directory-name (dir-name)
  "Clean up DIR-NAME for display by replacing underscores with spaces."
  (replace-regexp-in-string "_" " " dir-name))

;; Generate breadcrumbs
(defun my-generate-breadcrumbs (rel-file base-dir)
  "Generate breadcrumb navigation for REL-FILE relative to BASE-DIR."
  (let* ((dir-path (file-name-directory rel-file))
         (parts (when dir-path (split-string dir-path "/" t)))
         (current-path "")
         (breadcrumbs '()))
    (push "<a href=\"/\">Home</a>" breadcrumbs)
    (when parts
      (dolist (part parts)
        (setq current-path (concat current-path part "/"))
        (let ((index-file (concat base-dir current-path "index.org"))
              (display-name (my-clean-directory-name part)))
          (if (file-exists-p index-file)
              (push (format "<a href=\"/%sindex.html\">%s</a>" 
                           current-path display-name) breadcrumbs)
            (push display-name breadcrumbs)))))
    (when (> (length breadcrumbs) 1)
      (mapconcat 'identity (reverse breadcrumbs) " <span>→</span> "))))

(defun my-org-html-postamble (plist)
  "Generate custom postamble with last modified date."
  (let* ((file (plist-get plist :input-file))
         (mod-time (format-time-string "%Y-%m-%d %H:%M" 
                                       (nth 5 (file-attributes file)))))
    (format "<div class=\"footer\">
               <p>Author: Lin Jiang</p>
             </div>
             <div class=\"last-modified\">
               Last modified: %s
             </div>" mod-time)))

(defun my-org-html-postamble-with-search (plist)
  "Combines original postamble with Pagefind JS initialization."
  (concat
   (my-org-html-postamble plist)
   "<script>
     window.addEventListener('DOMContentLoaded', (event) => {
         new PagefindUI({
            element: '#search',
            showSubResults: true,
            bundlePath: '/pagefind/'
         });
     });
    </script>"))

(defun my-run-pagefind-indexer ()
  "Run the Pagefind indexer on the published site."
  (interactive)
  (let* ((project (assoc "lnjng-notes" org-publish-project-alist))
         (publishing-dir (plist-get (cdr project) :publishing-directory)))
    (when publishing-dir
      (message "Running Pagefind indexer on %s..." publishing-dir)
      (shell-command
       (format "/home/lnjng/.nvm/versions/node/v23.5.0/bin/pagefind --site %s"
               (shell-quote-argument publishing-dir))
       "*Pagefind Output*" "*Pagefind Errors*")
      (message "Pagefind indexing complete. See *Pagefind Output* / *Pagefind Errors*."))))

(defun my-org-sitemap-format-entry (entry style project)
  "Format sitemap entries with cleaned directory names and linked directory headings."
  (cond ((not (directory-name-p entry))
         ;; Regular file - use default behavior
         (format "[[file:%s][%s]]"
                 entry
                 (org-publish-find-title entry project)))
        (t
         ;; Directory - make it a link to the index file
         (let* ((dir-path (substring entry 0 -1)) ; Remove trailing slash
                (clean-name (my-clean-directory-name (file-name-nondirectory dir-path)))
                (index-link (concat dir-path "/index.html")))
           (format "[[file:%s][%s]]" index-link clean-name)))))

;; Use htmlize for syntax highlighting
(use-package htmlize
  :ensure t
  :init (setq org-html-htmlize-output-type 'css))

;; More blocks
(use-package org-special-block-extras
  :ensure t
  :init (org-special-block-extras-mode))
    
;; Main publish configuration
(setq org-publish-project-alist
      '(("lnjng-notes"
         :recursive t
         :base-directory "/home/lnjng/Org/notes"
         :publishing-directory "/home/lnjng/Projects/dev/notes/"
         :publishing-function org-html-publish-to-html
         :exclude "index\\.org$" 
         
         ;; HTML export options
         :html-extension "html"
         :with-toc t
         :html-preamble my-org-html-preamble
         :html-postamble my-org-html-postamble-with-search
         :html-head "<link href=\"/pagefind/pagefind-ui.css\" rel=\"stylesheet\">
                     <script src=\"/pagefind/pagefind-ui.js\"></script>
                     <link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"
         :html-head-include-default-style nil
         
         ;; Sitemap generation
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-format-entry my-org-sitemap-format-entry
         :sitemap-style tree
         :sitemap-title "Sitemap"
         :sitemap-sort-files anti-chronologically
         :sitemap-ignore-case t)
    
        ("lnjng-indices"
         :recursive t
         :base-directory "/home/lnjng/Org/notes"
         :publishing-directory "/home/lnjng/Projects/dev/notes/"
         :publishing-function org-html-publish-to-html
         
         ;; HTML export options
         :html-extension "html"
         :with-toc t
         :html-preamble my-org-html-preamble
         :html-postamble my-org-html-postamble-with-search
         :html-head "<link href=\"/pagefind/pagefind-ui.css\" rel=\"stylesheet\">
                     <script src=\"/pagefind/pagefind-ui.js\"></script>
                     <link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"
         :html-head-include-default-style nil)

        ("lnjng-static"
         :base-directory "/home/lnjng/Org/notes"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "/home/lnjng/Projects/dev/notes/"
         :recursive t
         :publishing-function org-publish-attachment)))

(setq org-export-with-sub-superscripts nil)

;; Simple function to create directory index files
(defun my-create-directory-indices ()
  "Create simple index.org files for each directory."
  (interactive)
  (let ((base-dir "/home/lnjng/Org/notes/"))
    (my-create-indices-recursive base-dir base-dir)))

(defun my-create-indices-recursive (current-dir base-dir)
  "Recursively create index files for directories."
  (let ((dirs (directory-files current-dir t "^[^.]" t)))
    (dolist (item dirs)
      (when (file-directory-p item)
        (let* ((dir-name (file-name-nondirectory item))
               (clean-name (my-clean-directory-name dir-name))
               (index-file (concat item "/index.org"))
               (rel-path (file-relative-name item base-dir)))
          
          ;; Create index file for this directory
          (my-write-simple-index index-file clean-name item base-dir)
          
          ;; Recurse into subdirectories
          (my-create-indices-recursive item base-dir))))))
    
(defun my-write-simple-index (index-file clean-name dir-path base-dir)
  "Write a simple index file for a directory."
  (let ((content (format "#+TITLE: %s\n#+OPTIONS: toc:nil\n\n" clean-name))
        (files (directory-files dir-path nil "\\.org$" t))
        (subdirs (seq-filter (lambda (f) 
                              (and (file-directory-p (concat dir-path "/" f))
                                   (not (string-match "^\\." f))))
                            (directory-files dir-path nil nil t))))
    
    ;; Add subdirectories
    (when subdirs
      (setq content (concat content "**Subdirectories:**\n\n"))
      (dolist (subdir subdirs)
        (let ((clean-subdir (my-clean-directory-name subdir)))
          (setq content (concat content 
                               (format "- [[file:%s/index.html][%s]]\n" 
                                      subdir clean-subdir))))))
    
    ;; Add org files (excluding index.org itself)
    (let ((org-files (seq-remove (lambda (f) (string= f "index.org")) files)))
      (when org-files
        (when subdirs (setq content (concat content "\n"))) ; Add spacing if we had subdirs
        (setq content (concat content "**Notes:**\n\n"))
        (dolist (file org-files)
          (let ((title (or (my-get-org-title (concat dir-path "/" file))
                          (file-name-sans-extension file))))
            (setq content (concat content 
                                 (format "- [[file:%s][%s]]\n" 
                                        file title)))))))
    
    ;; Write the file
    (with-temp-file index-file
      (insert content))))

(defun my-get-org-title (file-path)
  "Extract title from org file, return nil if not found."
  (when (file-readable-p file-path)
    (with-temp-buffer
      (insert-file-contents file-path)
      (goto-char (point-min))
      (when (re-search-forward "^#\\+TITLE: *\\(.+\\)" nil t)
        (match-string 1)))))

;; Publish function
(defun my-publish-site ()
  "Publish the entire site and run the search indexer."
  (interactive)
  (my-create-directory-indices)
  (dolist (buffer (buffer-list))
    (when (and (buffer-file-name buffer)
               (string-match "index\\.org$" (buffer-file-name buffer)))
      (with-current-buffer buffer
        (revert-buffer t t t))))
  (org-publish-all)
  (my-run-pagefind-indexer))
  ```
