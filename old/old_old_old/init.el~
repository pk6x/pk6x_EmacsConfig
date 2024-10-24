;; ///////////////////////////////// Startup & style
;; inhibit splash screen
(setq inhibit-splash-screen t)

;; change the font
(set-face-attribute 'default nil :font "consolas-17" :weight 'bold)

;; (set-face-background 'hl-=line "midnight blue")

;; set cursor color
(set-cursor-color "green")

;; Disabling middle mouse click
(global-unset-key [mouse-2])

;; turn on electric pair mode
(electric-pair-mode 1)

;; maximaise screen on startup
;(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; Set inital window width/height
;; @monitor/1440p @Windows
(setq default-frame-alist
      '((top . 5) (left . 0) (width . 129) (height . 49)))

;; Startup windowing
(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)
(split-window-horizontally)

;; disable menu on startup
;; (menu-bar-mode -1)

;; disable tools on startup
(tool-bar-mode -1)

;; disable scroll bar on startup
(scroll-bar-mode -1)

;; Enabling line number mode
(global-linum-mode t)

;; Powerful info mini-menu
(setq frame-title-format
      (list (format"%s %%s: %%j " (system-name))
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Smooth scrolling
(setq scroll-step 3)

;; Display time
(display-time)

;; Always syntax highlighting
;; (global-font-lock-mode 1)

;; Highlight brackets/parenthesis
;; (setq show-paren-delay 0
;;      show-paren-style 'parenthesis)
;; (show-paren-mode 1)

;; Set high limit for undo history
(setq undo-limit 2000000)
(setq undo-strong-limit 4000000)

;; Insert timd of the day
(defun insert-timeofday ()
  (interactive "*")
  (insert (format-time-string "---------------- %a, %d %b %y: %I:%M%p"))
  )
;; //////////////////////////////// End of Startup & style

;; //////////////////////////////// Customised keybining
;; ////// ALT-alternatives

;; find files
(define-key global-map "\ef" 'find-file)
(define-key global-map "\eF" 'find-file-other-window)

(global-set-key (read-kbd-macro "\eb") 'ido-switch-buffer)
(global-set-key (read-kbd-macro "\eB") 'ido-switch-buffer-other-window)

;; save file
(define-key text-mode-map "\es" 'save-buffer)

;; Prevent consecutive marks activating bloody `transient-mark-mode'.
(defadvice set-mark-command (after no-bloody-t-m-m activate)
  (if transient-mark-mode (setq transient-mark-mode nil)))

;; Prevent mouse commands activiating bloody `transient-mark-mode'.
(defadvice mouse-set-region-1 (after no-bloody-t-m-m activate)
  (if transient-mark-mode (setq transient-mark-mode nil)))

;; Perform copy-region-as-kill as an append
(defun append-as-kill ()
  (interactive)
  (append-next-kill)
  (copy-region-as-kill (mark) (point))
  )

(define-key global-map "\e " 'set-mark-command)
(define-key global-map "\eq" 'append-as-kill)
(define-key global-map "\ea" 'yank)
(define-key global-map "\ez" 'kill-region)
(define-key global-map [M-up] 'previous-blank-line)
(define-key global-map [M-down] 'next-blank-line)
(define-key global-map [M-right] 'forward-word)
(define-key global-map [M-left] 'backward-word)

(define-key global-map "\e:" 'View-back-to-mark)
(define-key global-map "\e;" 'exchange-point-and-mark)

;; Error list navigation
(define-key global-map [f9] 'first-error)
(define-key global-map [f10] 'previous-error)
(define-key global-map [f11] 'next-error)

(define-key global-map "\eg" 'goto-line)
(define-key global-map "\ej" 'imenu)

;; Editing
;; (define-key global-map "^Q" 'copy-region-as-kill)
;; (define-key global-map "^F" 'yank)
;; (define-key global-map "^Y" 'nil)
;; (define-key global-map "^E" 'rotate-yank-pointer)
(define-key global-map "\eu" 'undo)
(define-key global-map "\e6" 'upcase-word)
(define-key global-map "\e^" 'captilize-word)
(define-key global-map "\e." 'fill-paragraph)

;; Perform a replace-string in the current region
(defun replace-in-region (old-word new-word)
  (interactive "sReplace: \nsReplace: %s With: ")
  (save-excursion (save-restriction
		    (narrow-to-region (mark) (point))
		    (beginning-of-buffer)
		    (replace-string old-word new-word)
		    ))
  )

;; Replace a string without moving point
(defun replace-string (FromString ToString)
  (interactive "sReplace: \nsReplace: %s With: ")
  (save-excursion
    (replace-string FromString ToString)
    ))

(define-key global-map "\el" 'replace-in-region)

(define-key global-map "\eo" 'query-replace)
(define-key global-map "\eO" 'replace-string)

;; \377 is alt+backspace
(define-key global-map "\377" 'backward-kill-word)
(define-key global-map [M-delete] 'kill-word)

(define-key global-map "\e[" 'start-kbd-macro)
(define-key global-map "\e]" 'end-kbd-macro)
(define-key global-map "\e'" 'call-last-kbd-macro)

;; Buffers
(define-key global-map "\er" 'revert-buffer)
(define-key global-map "\ek" 'kill-this-buffer)
(define-key global-map "\es" 'save-buffer)

;; Navigaiton
;; Moves to the previous line containing nothing but whitespace
(defun previous-blank-line ()
  (interactive)
  (search-backward-regexp "^[ \t]*\n")
  )

;; Moves to the next line containing nothing but whitespace
(defun next-blank-line ()
  (interactive)
  (forward-line)
  (search-forward-regexp "^[ \t]*\n")
  (forward-line -1)
  )

(define-key global-map [C-right] 'forward-word)
(define-key global-map [C-left] 'backward-word)
(define-key global-map [C-up] 'previous-blank-line)
(define-key global-map [C-down] 'next-blank-line)
(define-key global-map [home] 'beginning-of-line)
(define-key global-map [end] 'end-of-line)
(define-key global-map [pgup] 'forward-page)
(define-key global-map [pgdown] 'backward-page)
(define-key global-map [C-next] 'scroll-other-window)
(define-key global-map [C-prior] 'scroll-other-window-down)

;; /////////////////////////////// End of customised keybinding

;; //////////////////////////////// C/C++ style
;; C/C++ mode handling
(defun big-fun-c-hook ()
  ;; Set my style for the current buffer
  ;; (c-add-style "BigFun" big-fun-c-style t)

  ;; 4-space tabs
  ;; (setq tab-width 4)

  ;; Newline indents, semi-colon wont
  (define-key c++-mode-map "\C-m" 'newline-and-indent)
  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))
  
  ;; Additional style stuff
  (c-set-offset 'member-init-intro '++)

  ;; No hungry backspace
  (c-toggle-auto-hungry-state -1)
  

  ;; Accepted file extensions and their appropriate modes
  (setq auto-mode-alist
	(append
	 '(("\\.cpp$"    . c++-mode)
           ("\\.hin$"    . c++-mode)
           ("\\.cin$"    . c++-mode)
           ("\\.inl$"    . c++-mode)
           ("\\.rdc$"    . c++-mode)
           ("\\.h$"    . c++-mode)
           ("\\.c$"   . c++-mode)
           ("\\.cc$"   . c++-mode)
           ("\\.c8$"   . c++-mode)
           ("\\.txt$" . indented-text-mode)
           ("\\.emacs$" . emacs-lisp-mode)
           ("\\.gen$" . gen-mode)
           ("\\.ms$" . fundamental-mode)
           ("\\.m$" . objc-mode)
           ("\\.mm$" . objc-mode)
           ) auto-mode-alist))
  
;; C++ indentation style
  (defconst c-default-style
    '((c-electric-pound-behavior   . t)
      (c-tab-always-indent         . nil)
      (c-comment-only-line-offset  . 0)
      (c-hanging-braces-alist      . ((class-open)
                                      (class-close)
                                      (defun-open)
                                      (defun-close)
                                      (inline-open)
                                      (inline-close)
                                      (brace-list-open)
                                      (brace-list-close)
                                      (brace-list-intro)
                                      (brace-list-entry)
                                      (block-open)
                                      (block-close)
                                      (substatement-open)
                                      (statement-case-open)
                                      (class-open)))
      (c-hanging-colons-alist      . ((inher-intro)
                                      (case-label)
                                      (label)
                                      (access-label)
                                      (access-key)
                                      (member-init-intro)))
      (c-cleanup-list              . (scope-operator
                                      list-close-comma
                                      defun-close-semi))
      (c-offsets-alist             . ((arglist-close         .  c-lineup-arglist)
                                      (label                 .  0)
                                      (access-label          .  0)
                                      (substatement-open     .  0)
                                      (statement-case-intro  .  0)
                                      (statement-block-intro .  c-lineup-for)
                                      (case-label            .  4)
                                      (block-open            .  0)
                                      (inline-open           .  0)
                                      (topmost-intro-cont    .  0)
                                      (knr-argdecl-intro     .  0)
                                      (brace-list-open       .  0)
                                      (brace-list-intro      .  0)))
      (c-echo-syntactic-information-p . t))
    "Big Fun C++ Style."
    )

  ;; Format the given file as a header file
  (defun header-format ()
    (interactive)
    (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
    (insert "#if !defined(")
    (push-mark)
    (insert BaseFileName)
    (upcase-region (mark) (point))
    (pop-mark)
    (insert "_H)\n")
    (insert "/* ========================================================================\n")
    (insert "   $File: $\n")
    (insert "   $Date: $\n")
    (insert "   $Revision: $\n")
    (insert "   $Creator: Ahmad Almoughrabi $\n")
    (insert "   ======================================================================== */\n")
    (insert "\n")
    (insert "#define ")
    (push-mark)
    (insert BaseFileName)
    (upcase-region (mark) (point))
    (pop-mark)
    (insert "_H\n")
    (insert "#endif")
    )

  ;; Format the given file as a source file
  (defun source-format ()
    (interactive)
    (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
    (insert "/* ========================================================================\n")
    (insert "   $File: $\n")
    (insert "   $Date: $\n")
    (insert "   $Revision: $\n")
    (insert "   $Creator: Ahmad Almoughrabi $\n")
    (insert "   ======================================================================== */\n")
  )

  (cond ((file-exists-p buffer-file-name) t)
        ((string-match "[.]hin" buffer-file-name) (source-format))
        ((string-match "[.]cin" buffer-file-name) (source-format))
        ((string-match "[.]h" buffer-file-name) (header-format))
        ((string-match "[.]cpp" buffer-file-name) (source-format)))

  (defun find-corresponding-file ()
    "Find the file that corresponds to this one."
    (interactive)
    (setq CorrespondingFileName nil)
    (setq BaseFileName (file-name-sans-extension buffer-file-name))
    (if (string-match "\\.c" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".h")))
    (if (string-match "\\.h" buffer-file-name)
       (if (file-exists-p (concat BaseFileName ".c")) (setq CorrespondingFileName (concat BaseFileName ".c"))
	   (setq CorrespondingFileName (concat BaseFileName ".cpp"))))
    (if (string-match "\\.hin" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".cin")))
    (if (string-match "\\.cin" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".hin")))
    (if (string-match "\\.cpp" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".h")))
    (if CorrespondingFileName (find-file CorrespondingFileName)
       (error "Unable to find a corresponding file")))
  (defun find-corresponding-file-other-window ()
    "Find the file that corresponds to this one."
    (interactive)
    (find-file-other-window buffer-file-name)
    (find-corresponding-file)
    (other-window -1))
  
  (define-key c++-mode-map "\ec" 'find-corresponding-file)
  (define-key c++-mode-map "\eC" 'find-corresponding-file-other-window)


  ;; Unique comments style
  (setq fixme-modes '(c++-mode c-mode emacs-lisp-mode))
  (make-face 'font-lock-fixme-face)
  (make-face 'font-lock-note-face)
  (mapc (lambda (mode)
	  (font-lock-add-keywords
	   mode
	   '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
	     ("\\<\\(NOTE\\)" 1 'font-lock-note-face t))))
	fixme-modes)
  (modify-face 'font-lock-fixme-face "Red" nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face "Dark Green" nil nil t nil t nil nil)
)

;; set "gnu" style indenting for c
  (setq c-default-style "Linux"
	c-basic-offset 4)

;; //////////////////////////////// End of C/C++ style

;; //////  C++ configuration by external packages
;; Enabling melpa package archiver
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(use-package try :ensure t)
(use-package which-key :ensure t :config (which-key-mode))

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; auto-commplete
(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

;; flycheck
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;; C++ font
(use-package modern-cpp-font-lock
  :ensure t)

;; Magit
(use-package magit
  :ensure t
  :init
  (progn
    (bind-key "C-x g" 'magit-status)))

;; C++ compilation
(defun code-compile ()
  (interactive)
  (unless (file-exists-p "Makefile")
    (set (make-local-variable 'compile-command)
     (let ((file (file-name-nondirectory buffer-file-name)))
       (format "%s -o %s %s"
           (if  (equal (file-name-extension file) "cpp" "c") "clang++" "clang" )
           (file-name-sans-extension file)
           file)))
    (compile compile-command)))

(global-set-key [f8] 'code-compile)
;; ///// End of C++ configuration //////

(setenv "PATH" "D:\Program Files\Inkscape\bin:$PATH" t)
;; //////////////////////////////////////// Auto-generated after first running.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tsdh-dark))
 '(gdb-many-windows t)
 '(package-selected-packages '(yasnippet-snippets which-key try use-package))
 '(warning-suppress-types '((auto-save) (auto-save) (auto-save) (auto-save))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
