(defun go-gopath-gb-env-line (name)
  (unless (eq buffer-file-name nil)
    (let ((gbe-env (split-string (shell-command-to-string "gb env") "\n")))
      (car (remove-if-not (lambda (e) (string-prefix-p name e)) gbe-env)))))

(defun go-gopath-gb-env-value (name)
  (let ((env-line (go-gopath-gb-env-line name)))
    (unless (eq env-line nil)
      (substring env-line (+ (length name) 2) -1))))

(defun go-gopath-gb-root ()
  (if (executable-find "gb")
      (go-gopath-gb-env-value "GB_PROJECT_DIR")))

(defun go-gopath-projectile-root ()
  (if (fboundp 'projectile-project-p)
      (if (projectile-project-p)
          (projectile-project-root))))

(defun go-gopath-root ()
  (or
   (go-gopath-gb-root)
   (go-gopath-projectile-root)
   (getenv "GOPATH")
   default-directory))

(defun go-gopath-expand-gopath (gopath)
  (let* ((expanded-gopath (expand-file-name "." gopath))
         (expanded-vendor-gopath (expand-file-name "vendor" gopath)))
    (if (file-exists-p expanded-vendor-gopath)
        (concat expanded-gopath ":" expanded-vendor-gopath)
      expanded-gopath)))

(defun go-gopath-set-gopath (gopath)
  (interactive
   (list
    (read-directory-name "GOPATH=" (expand-file-name "." (go-gopath-root)))))
  (setenv "GOPATH" (go-gopath-expand-gopath gopath)))


(provide 'go-gopath)
