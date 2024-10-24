;;; Summary --- Beginning of my Emacs init file: Commentary:
;; 
;; //////////////////////////////// Startup & style
;; inhibit splash screen
(setq inhibit-splash-screen t)

;; load path
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; default directory when opening
(setq default-directory "W:\\")

(global-hl-line-mode 1)
(set-face-background 'hl-line "c1a256")

;; add en dash character to the word constituent syntax class
(modify-syntax-entry ?– "w")
(global-superword-mode)

;; displays column and line position info in the mode-line
(setq column-number-mode t)

;; disables mouse middle click
(global-unset-key [mouse-2])

;; turn on electric pair mode
(electric-pair-mode 1)

;; maximaise screen on startup
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; Startup windowing
(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
;; (setq truncate-partial-width-windows nil)
(split-window-horizontally)

;; disable tools on startup
(tool-bar-mode -1)

;; smooth scrolling
(setq scroll-step 2)

;; set high limit for undo history
(setq undo-limit 2000000)
(setq undo-strong-limit 4000000)
;; (setq max-specpdl-size 13000)

;; insert timd of the day
(defun insert-timeofday ()
(interactive "*")
(insert (format-time-string "---------------- %a, %d %b %y: %I:%M%p"))
)
;; //////////////////////////////// End of Startup & style

;; //////////////////////////////// Start of "From Casey Muratori (C/C++ style and compilation)"
; Determine the underlying operating system
(setq system-aquamacs (featurep 'aquamacs))
(setq system-linux (featurep 'x))
(setq system-win32 (not (or system-aquamacs system-linux)))

(setq todo-file "w:/me_handmadehero/code/todo.txt")
(setq log-file "w:/me_handmadehero/code/log.txt")

(setq compilation-directory-locked nil)

(when system-win32 
  (setq build-script "build.bat")
)

(when system-aquamacs 
  (cua-mode 0) 
  (osx-key-mode 0)
  (tabbar-mode 0)
  (setq mac-command-modifier 'meta)
  (setq x-select-enable-clipboard t)
  (setq aquamacs-save-options-on-quit 0)
  (setq special-display-regexps nil)
  (setq special-display-buffer-names nil)
  (define-key function-key-map [return] [13])
  (setq mac-command-key-is-meta t)
  (scroll-bar-mode nil)
  (setq mac-pass-command-to-system nil)
  (setq build-script "./build.macosx")
)

(when system-linux
  (setq build-script "./build.linux")
  (display-battery-mode 1)
)

(load-library "view")
;; (require 'cc-mode)
(require 'ido)
(require 'compile)
(ido-mode t)

(defun ediff-setup-windows (buffer-A buffer-B buffer-C control-buffer)
  (ediff-setup-windows-plain buffer-A buffer-B buffer-C control-buffer)
)
(setq ediff-window-setup-function 'ediff-setup-windows)
(setq ediff-split-window-function 'split-window-horizontally)

;; C/C++ mode handling
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
  '((c-electric-pound-behavior   . nil)
    (c-tab-always-indent         . t)
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
                                    (label                 . -4)
                                    (access-label          . -4)
                                    (substatement-open     .  0)
				                            (statement-case-intro  .  4)
                                    (statement-block-intro .  c-lineup-for)
                                    (case-label            .  4)
                                    (block-open            .  4)
                                    (inline-open           .  0)
                                    (topmost-intro-cont    .  0)
                                    (knr-argdecl-intro     . -4)
                                    (brace-list-open       .  0)
                                    (brace-list-intro      .  4)))
      (c-echo-syntactic-information-p . t))
    "Big Fun C++ Style."
    )

(defun big-fun-c-hook ()
  ;; Set my style for the current buffer
  (c-add-style "BigFun" c-default-style t)

  ;; 4-space tabs
  (setq tab-width 4
        indent-tabs-mode nil)

  ;; Newline indents, semi-colon wont
  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))
  
  ;; Additional style stuff
  (c-set-offset 'member-init-intro '++)

  ;; No hungry backspace
  (c-toggle-auto-hungry-state -1)
  
  ;; Abbrevation expansion
  ;; (abbrev-mode 1)

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
    (insert "   $Creator: OOOO $\n")
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
    (insert "   $Creator: OOOO $\n")
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
  (define-key c++-mode-map "\e." 'find-corresponding-file)
  (define-key c++-mode-map "\e>" 'find-corresponding-file-other-window)
  (define-key c++-mode-map [C-tab] 'indent-region)
  (define-key c++-mode-map "\C-y" 'indent-for-tab-command)
  (define-key c++-mode-map "^[  " 'indent-region)
)

(add-hook 'c-mode-common-hook 'big-fun-c-hook)

;; add en dash word "hyphenated compound word" as word constituents in the syntax table
(add-hook 'c++-mode-hook 'superword-mode)
(add-hook 'c++-mode-hook (lambda () (modify-syntax-entry ?- "w")))

;; C/C++ compilation
(setq compilation-context-lines 0)
(setq compilation-error-regexp-alist
    (cons '("^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:fatal error\\|warnin\\(g\\)\\) C[0-9]+:" 2 3 nil (4))
     compilation-error-regexp-alist))

;; (add-to-list 'compilaton-error-regexp-alist 'amgun-devenv)
 ;; (add-to-list 'compilation-error-regexp-alist-alist '(amgun-devenv
 ;; "*\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) :
 ;; \\(?:see declaration\\|\\(?:warnin\\(g\\)\\|[a-z ]+\\) C[0-9]+:\\)"
 ;; 2 3 nil (4)))

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p build-script) t
      (cd "../")
      (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (switch-to-buffer-other-window "*compilation*")
  (if compilation-directory-locked (cd last-compilation-directory)
  (cd find-project-from-directory)
  (find-project-directory-recursive)
  (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile build-script))
  (other-window 1))
(define-key global-map [f5] 'make-without-asking)

; Commands
(set-variable 'grep-command "grep -irHn ")
(when system-win32
    (set-variable 'grep-command "findstr -s -n -i -l "))
;; //////////////////////////////// End of "From Casey Muratori (C/C++ style and compilation)"

;; ///////////////////////////////// Start of Unknown terriotry
;; Prevent consecutive marks activating bloody `transient-mark-mode'.
(defadvice set-mark-command (after no-bloody-t-m-m activate)
  (if transient-mark-mode (setq transient-mark-mode nil)))

;; Prevent mouse commands activiating bloody `transient-mark-mode'.
(defadvice mouse-set-region-1 (after no-bloody-t-m-m activate)
  (if transient-mark-mode (setq transient-mark-mode nil)))

;; Replace a string without moving point
(defun replace-string (FromString ToString)
  (interactive "sReplace: \nsReplace: %s With: ")
  (save-excursion
    (replace-string FromString ToString)
    ))

;; Perform a replace-string in the current region
(defun replace-in-region (old-word new-word)
  (interactive "sReplace: \nsReplace: %s With: ")
  (save-excursion (save-restriction
        (narrow-to-region (mark) (point))
        (beginning-of-buffer)
        (replace-regexp-in-region old-word new-word)
        ))
  )
;; ///////////////////////////////// End of Unknown terriotry

;; ////////////////////////////// Start of Configuration by external packages
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

(require 'yasnippet)
(yas-global-mode 1)

(require 'color-theme-modern)
(load-theme 'ample t t)
(enable-theme 'ample)

; auto-commplete
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

;; Magit
(use-package magit
  :ensure t
  :init
  (progn
    (bind-key "C-x g" 'magit-status)))

;; C++ compilation
;; (defun code-compile ()
 ;; (interactive)
 ;; (unless (file-exists-p "Makefile")
   ;; (set (make-local-variable 'compile-command)
    ;; (let ((file (file-name-nondirectory buffer-file-name)))
      ;; (format "%s -o %s %s"
          ;; (if  (equal (file-name-extension file) "cpp") "clang++ -o *.exe"  )
          ;; (file-name-sans-extension file)
          ;; file)))
   ;; (compile compile-command)))

;; (global-set-key [f5] 'code-compile)
;; ////////////////////////////// End of Configuration by external packages

;; ////////////////////////////// Start of Customised keybindings
(define-key global-map "\ew" 'kill-region)
(define-key global-map "\ep" 'yank)
(define-key global-map "\eC" 'copy-region-as-kill)
(global-set-key "\ee" 'move-end-of-line)
(global-set-key "\ea" 'beginning-of-line-text)
(define-key global-map "\ej" 'next-line)
(define-key global-map "\ef" 'previous-line)
(define-key global-map "\eG" 'find-file)
(define-key global-map "\eH" 'find-file-other-window)
(global-set-key (read-kbd-macro "\eb") 'ido-switch-buffer)
(global-set-key (read-kbd-macro "\eB") 'ido-switch-buffer-other-window)
(define-key global-map "\eS" 'save-buffer)
(define-key global-map "\eL" 'kill-whole-line)
(define-key global-map "\eR" 'replace-in-region)
(define-key global-map "\e " 'set-mark-command)
(define-key global-map "\eq" 'keyboard-escape-quit)
(define-key global-map [home] 'forward-sentence)
(define-key global-map [end] 'backward-sentence)
(define-key global-map "\ei" 'other-window)
(define-key global-map "\em" 'forward-word)
(define-key global-map "\ev" 'backward-word)
(define-key global-map "\eh" 'forward-char)
(define-key global-map "\eg" 'backward-char )
(define-key global-map "\e:" 'view-back-to-mark)
(define-key global-map "\e[" 'exchange-point-and-mark)
(define-key global-map [f9] 'first-error)
(define-key global-map [f10] 'previous-error)
(define-key global-map [f11] 'next-error)
(define-key global-map "\en" 'next-error)
(define-key global-map "\eN" 'previous-error)
(define-key global-map "\eu" 'undo)
(define-key global-map "\e6" 'upcase-word)
(define-key global-map "\e^" 'captilize-word)
(define-key global-map "\e." 'fill-paragraph)
(define-key global-map "\eD" 'open-line)
(define-key global-map "\er" 'query-replace)
(define-key global-map "\377" 'backward-kill-word)
(define-key global-map "\e'" 'call-last-kbd-macro)
(define-key global-map "\ek" 'next-buffer)
(define-key global-map "\eK" 'previous-buffer)
(define-key global-map "\eX" 'kill-this-buffer)
(define-key global-map "\ey" 'delete-backward-char)
(define-key global-map [C-right] 'forward-word)
(define-key global-map [C-left] 'backward-word)
(define-key global-map [C-up] 'previous-blank-line)
(define-key global-map [C-down] 'next-blank-line)
(define-key global-map [pgup] 'forward-page)
(define-key global-map [pgdown] 'backward-page)
(define-key global-map [M-down] 'scroll-other-window)
(define-key global-map [M-up] 'scroll-other-window-down)
(define-key global-map "\e?" 'comment-line)
(define-key global-map "\eJ" 'imenu)
(define-key global-map "\e>" 'beginning-of-buffer)
(define-key global-map "\e," 'end-of-buffer)
(define-key global-map "\es" 'isearch-forward)
(define-key global-map "\eV" 'recenter-top-bottom)
(define-key global-map "\e/" 'forward-paragraph)
(define-key global-map "\e'" 'backward-paragraph)
;; (define-key global-map "\e[" 'start-kbd-macro)
;; (define-key global-map "\e]" 'end-kbd-macro)
;; (define-key global-map "\er" 'revert-buffer)

;; Insert new line below current line
(defun end-of-line-and-indent-new-line ()
  (interactive)
  (end-of-line)
  (newline-and-indent))

(global-set-key (kbd "\eo") 'end-of-line-and-indent-new-line)

;; Insert new line above current line
(defun beginning-of-line-and-indent-new-line ()
  (interactive)
  (beginning-of-line)
  (newline-and-indent)
  (previous-line)
  (indent-relative))

(global-set-key (kbd "\eO") 'beginning-of-line-and-indent-new-line)

;; Copy words and lines
    (defun get-point (symbol &optional arg)
      "get the point"
      (funcall symbol arg)
      (point))
     
    (defun copy-thing (begin-of-thing end-of-thing &optional arg)
      "Copy thing between beg & end into kill ring."
      (save-excursion
        (let ((beg (get-point begin-of-thing 1))
              (end (get-point end-of-thing arg)))
          (copy-region-as-kill beg end))))
     
    (defun paste-to-mark (&optional arg)
      "Paste things to mark, or to the prompt in shell-mode."
      (unless (eq arg 1)
        (if (string= "shell-mode" major-mode)
            (comint-next-prompt 25535)
          (goto-char (mark)))
        (yank)))

;; Copy word
     (defun copy-word (&optional arg)
      "Copy words at point into kill-ring"
       (interactive "P")
       (copy-thing 'forward-word 'backward-word arg)
       ;;(paste-to-mark arg)
       )

(global-set-key "\ec" 'copy-word)

;; Copy Line
     (defun copy-line (&optional arg)
      "Save current line into Kill-Ring without mark the line "
       (interactive "P")
       (copy-thing 'beginning-of-line-text 'end-of-line arg)
       ;; (paste-to-mark arg)
       )

(global-set-key "\el" 'copy-line)
;; ////////////////////////////// End of Customised keybindings

;; ////////////////////////////// Start of Modline Configuration
;; modeline configuration
;; (setq-default mode-line-format nil)
(setq-default mode-line-format
	      '("%e"
		"  "
		(:eval (format "%s" (buffer-file-name)))
		"  "
		(:eval (format "%s" (propertize (symbol-name major-mode) 'face 'bold)))
		"  "
		mode-line-position
		))


;; (add-to-list 'global-mode-string '(" %i"))
;; ////////////////////////////// End of Modline Configuration

;; ////////////////////////////// Auto-generated by emacs.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(auto-save-interval 0)
 '(auto-save-list-file-prefix nil)
 '(auto-save-timeout 0)
 '(auto-show-mode t t)
 '(custom-enabled-themes '(ample))
 '(custom-safe-themes
   '("01d390d8bc36d5e484352e5534223af750d2761ec81eae01057b7c49ce14b149" "defba66aff0811c7d63e643c6defeb9d6b9ffb53eaf120efdfc97f27624b98c4" "9d5f90ba8e0af0af78d61284577829bd96fa8d4fca6ec207078cd71dbca4f4f7" "419746ff7bc64bed65f3098540ac51efa2072fbc660da26f0789c0ebf8a34b6a" "9d6db28e1463ffd1bba96456e37c80bbe78d118749b0b319fa8b21bd0be60120" "f673fcb252373cc618097e29647325c7afa0bc586a34588f8a6603651ba3f789" "ad8c549b7a99f6e8d24355baf57efdbb273aaf24ebf5c011bace16bc45f93088" "6f49b774cc8ded22c4c4b78dfe5cc6198ea0ebf21bf740f5e202c1975955ba3e" "3e99fcf183bcc5240138a5fd5984addf18983ca8e12f955597d9adb8dfffa8f6" "d63097e5458242ae1f4ea85a4000f126f5112789c5e4c28bad0086f74d1d387e" "991de67579c67c1eb7160601048676358c001883dcf5a968f41d6a04bf260f52" "d6b4f832e8f7a702206c233cf813ff6011e90adb5532e6ca1fee15330065f9d7" "bb55929dc689afc7264f7b177c47d19ca1b955569fd84dd5c168d0f3a17e8977" "7e0f3481838a0edf460d11e44c2bbc5f4cda85a6528caa9737e49db4794206d7" "f4f8ac538fb5df1b706a5a96254afba08982ebb63a6ad05f633e44e0498afbde" "ee3eb912d37c6628d2ffac29f39d9165f5f5aff101a6f60fe01893387a0cb874" "1dc284cb398776cbe7c76212e3fb551ec5c484db47a0daaed92c5aa4390afd39" "51d115c45f7d98771c483fa5b55db191a5bf9168e71018e48bb7fa3e69fd5f50" "41100b6e7f88e41cc81940dc54607636525bbf74f8e580ee7ab99486e186d921" "1442e9746e5e7c8291d9f7dbf60b69a68631079a74e8b24edfd3008cc1ad276f" "45af7302d123a303dcdf7bf0dd738753c464fdfcf8f2fab1bd7cecf1f5e64a77" "8ef15701c0f2453d232d60bfa0b81074f832b884c2e149ec2ae4c1a89c374b86" "f4149b740f1695d6912c253b94077044218818300af67f7ad7d5671c02104bf9" "2e35cbad10e9e5c379fcd083ad227f6450a06d567ac7d258b862b36c41f7f256" "b384aa2409c8f69c5294f151b8e77c1bcf3f52da076f3c706848088c27d541e9" "e8b6c9c9372f2e3a7fed3887497987dacf9952a75681c3aeabbbad044499e067" "1410247339e4acdfcf170dc3d7cba13cf6b75e920b867e6b850f68066f1edf43" "2facef45426ec4cc4557de75dc79257aa1d43ba1a41318d93559029dae6539e6" "0f24d8b040c4d99f364c1f4bddb1402cc327d2c7f4151d369401aaf8d25cd5f8" "696532e9091ad69d9b7fc01ad176826ab9b175285a6801ce227760f0ab68c842" "bb7a7b2b5a49aa0485a4e46855334dc6cf1f16cb6f7e674d7edf2ed2e03531f5" "011e5acf8327c380a9bae9e4281ec8509e3d1139ed136672635467e3c4ca09c7" "00901612c648ea9a388514a6f5258a7cdd84c7ae6bd25ce77c514205b78febf1" "490667b52caea0cfbab1aae5f57b3a6c4abca0149e68a1157829ff01cfdb5298" "847c2471758ccf5e05baea345e2354e8ad6b4bc48a7059fa9b73d23a1f205a5d" "3bc4c852a03c439cb78a044b55228749c1a03ce01a728500339749f4a7b6f0c1" "0d52158c373eaacefdab10191926c021ee99164ada2f4e4020b68c2293397b2f" "d20676cc62ddfb3da01035b525fbf6da26760ff48c08f0a15dc573f4738ecbd7" "4ba4e0423607b82429ec0bd4873f484766370a944559564ba78220f060604a43" "dd19f4039f34d527579f856d3c4b43efdb8e579d342268a814e923eb6fee4f4a" "5bb3cbe6acae048708aec99b8ce152a5cd29db5b8723f9900136ca3877c37b39" "09354e8cdee4d7f0fe0c0ad817c41324f36dc7d093f0f72f57969e55977764e0" "e1fd72b4cebe772a10425c2d9cda97150b8d449adcfe293afeb5d81926bd21c4" "89b9c7589d34ca00c01e4a5cacef56c95a36705903dfde9706301517c1f65874" "ad6ffaa4c10d555f54b1c3fe4ae8ecec66c516e2f1ba460eb6b591dcd2e40090" "5883d42d1f5be2d2ee502b6f77efb05aea5cca7e775cb14d13395e4c3f56b1dc" "2d16738941db41d3bf9b293b7afbcefc4adcf15d4baef6ac95a9185724bea3ba" "6f215350ccf35ea64956e0b87111dc43e4cfb0ce0ea28f8010918d767c3e4e9a" "982fb05996c9af2359bc50d43f404bec670e9166d7ca40a231f893933a0cef8a" "f765affb8f94200a58a53c9ad7458de5fbda12c823ca0ab83efd9188c3f402ae" "b00cc2256e10038afabfb9a6052eb8c14d6c642ebacce00531645cb0589d0f81" "b59fa0bfc7fa0d81ab0c00b9ad6e272e164678fc770e4c735e3cd2ed3a7b8705" "040f66ab94a03df748df53de9e3c729145a6c70508c7f729e1a7cfcf5e2ac28f" "1c96aa7a8f3ffa83d02ea0be4a572d2f8f66e7bb440b060e7f2fb0e2081078d9" "917ce3095099ba4757f60ed7a4ece1b26c8d820afe33a3b578cc46c1dedbff08" "2b4b734833f7f1b59a4c0040989e9fa1ef8ee9df39ce746da981a7b4933e71bc" "cfc78b5d7914401997c8f4c9b446a90efa8966ebd8faa41ffb16b5c13a65e802" "929a676c1d97d205298a8547b7f622da01003fde78deb077c21929ec6cb3d2a4" "58d8950cae7041a900f08dc8be4699a9cd0f13b6df8a91f9f59a0bf1f5320c5f" "477e5e132dc3ca232c613e390f04dc3f66aead8cf34a90f6955fcec7ab98108e" "91609d929d3852bed1e56b6af8e21db4cbf548b04888c70b510e200e4ecfe8ee" "ae228d52d174b134798e5b28ba9513f454c1c92943afb7e9e1f93e24544bf05a" "b54b7032974d55884e2107ea5e99c8b0bb16515e643a0e5d367026a34e973646" "a0cab6058d99f6e8b3a36b8498721662b9d531d5bdd3cea0abdb496bf5c364dd" "56e7eb6ba5dbe81bad46f22f6eb74682caf69dc652e57f1538ea52de93d44289" "f17c59304e718f3455d28cbaf39b37684a0e20e09e45de77751bc9b9884abcae" "9633601997e54835595c3acfcc0e51f5c3c287646ea4c7482cbf80f9b095d30b" "d2c18b27125e7319c0abaf829e282e1cd83dfa8d810302842ed665f2703d87bc" "b42f29befd2a39bf1f246a7c111bf226588988901c18b3d4de18eb565a545ba0" "f8a254cf3ffdc2989d79313c72620e81ba3f9d976915fa34ebffcd8e9cc804b5" "24e91b7ca67b83439b2875e9d97925f27e41a44d383ad4f3e57eff293fffc783" "e52261fa9b93e0d058393b933595971085e9c25e5507fbb2cb4b441ecef3c1db" "103b4cc7fb9063c614f0413828ae7c223dba14b8ce987746b6416de05d99dacf" "4b93ef0ed10715e0d3c3bdf735db394ca098df92f1bd68afde1662515e3b5a17" "b27fe4349491601643abd64299ee901f9381bd6cc962c2588b3f272c34bebec0" "bdf76a886a40d7bf014d2a5453acfff5c5d1ce25c39e9d011f7bf5c9adc85b17" "f4f420a53932aad6d3246d4519dd9dfc94f17d95e41fffaf056fc5c0307ea12e" "85024dad36e7fc17103087047990013f36ac6d3081f0ff73692852abf6bba943" "c9254818ae4dbe40fdcf100a380ab42def18d22d1b4366d9059630bde0bde165" "885488552855eb50536260f792912f2066227443fea2a487af0437f525018ab4" "f04bb0f66d366877940b80c2db522934127a0ed40343c560e5ddd2281149ef3f" "9b367ddf7dac200dc3ff9994ef1add6f5cf4f332566415b4d54d8bc7d0d57fd8" "e7c33a10a4494a4f3ca8acfdf174cd83e91b4cb401246d78f406aec0d960f847" "dc4ef9f45ff89b6e39b6949d7e8529dd78ddcb766dc3a7122498b6b43dafe808" "87113683fa3d4b2622bf6c976f4729cb4ef4a06af94bede814bed1b219c75bfa" "acbcabc1a02827b86775a0abc440223fb58e9d98568ab6f70dfe262718762de9" "895adb3b36a4764f39c5665996984a9fd78571069c0a43d259c65abc08145340" "cd0be7158ada1340c046ba259a69130b753ee39d3ebbdfb2a1157af4ae8a1f17" "f6fb035d75c77f7f33b9255cafc7e313b5377bd5c7bba1b7f77f7cecfa0d97ba" "379dfdfb8d81433068f8b472745eb9f5e79a651fd79909e4865b9fd718b0d008" "f9f7fe512eedf7f0054755a39fbbc1b166789fd1ee89e944bbcb6fb2f930b7a5" "930243b929e5886e97390710218558ab346b31f6d04c6320d5182a81761ce9ed" "1524ee33541a025ea700dfcd9e275646488d210b374783425f1664454f266183" "130b5ffe307e65f48f6820177e890253b3e5783d07ba6175378d99ac58a1bc57" "70755427a482cf762b032172eda8e042e2aca58e9cb9542f251067142aacfa26" "48b54c5eb3a9ac1d81ffec4c9f6aaf68511dc0b601b256b62483f390c0219dc7" "05dd3c709da9cdcdeebe212f427866952a2c604688b0213ae6cbc8b306becc22" "8d9915384e65ab0bc14919983c4f17ff5b0dc1a4db28159eefd9cd76c2a8e7a8" "aeec1dc9460220d6f10fdb2870c39556fc05d7ffe11ee4283722f04a93a51998" "7fcf9978d9cabe73109eecbbcdc488ae953cac9e5aaa4e9c8f50f61662c74864" "153ccd3bbf6eb2d02211ab5a6afa5e995b0709033411b8d560e0e2ca0a4d91a6" "6ac71d4a6f5909204adf102fa64dfc1647b8db90d369d02b466635cc52d18fb0" "fe1293faa6f41dff98cb65d1a876b8b94f6de099e26b704d0abde8e11a1b905e" "36b724581d2f3227ac4f4defa1a2f5bc76e7b539e381abee7c7ea524cbf2c442" "13bd95b605d4415176da8feb6e58e077017f3d41489d2cb1aaae4db1584727ed" "75a517da7fc9d93a21de9a484a66a07fb932e1a2bb52b385e3886920f44187c0" "c3b79f9c858c509d2f38529ec230ef981e4e1bb7042027fa89ad2528be9d4b7b" "3f64893685082a6af2c99ba3bfe29238d5e6ad7ba03ec738b7ae439531995016" "5f6d28da9406ae386018b53436ab1397714a54a6e81e9d836b82e551c5ed93fd" "fc3ac8aa92ad0d472aafbb3d9e0830fcb1f37d9fdc97af4c7fc65df162429dcb" "5219ca6c3213e7f148831b15759edf43ed5dc6a9c63c2aaef2e5a1808dad1cc0" "\0125219ca6c3213e7f148831b15759edf43ed5dc6a9c63c2aaef2e5a1808dad1cc0" "\12\0125219ca6c3213e7f148831b15759edf43ed5dc6a9c63c2aaef2e5a1808dad1cc0" "\12\0124480a982e1db2aa509c2de8b05fe5fa295ef3e7338a9411c94c75d62bc4b1443" "\12\12f3f88f69b800f1d010b1533080650ef45fc813ac3cf0a6b007be795d9023a8cb" "\12\0127da57f796645c3277049df3195934b14e88e34b517fa6a76f99a031f8bebd91e" "\12\12d9871b56dd9151c0cbbccee9385c6e1670bbda5da4e3b30b58cb456792b29511" "\12\12f9cad8c375c78493243651c99a9d53317a702e2537cc57034b1c4443a7e3255d" "\12\12ee5e691ed0054ac41dc80c06765d3ab68640d64486631be84c796b6ff52bad1f" "\12\012729267e9b4bdbefeae5b316bd86bc41a532b08c62a87f95a269ff7951ea802c2" "\12\012379041523d033ee1d2ed479e519d01ea94ba08bb6b57d7b589995414584f2bf6" "\12\0126bdbd8cc485d400466a33b9592e7452daa1f12246030ef24909d72af9589ed35" "\12\12bf798e9e8ff00d4bf2512597f36e5a135ce48e477ce88a0764cfb5d8104e8163" "\12\12c9ddf33b383e74dac7690255dd2c3dfa1961a8e8a1d20e401c6572febef61045" "\12\01236ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "\12\12f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7" "\12\0121c7635fd451cc7834a4ec6ff92bf656d846cf75d9153ff01618f0d3e80323f04" default))
 '(delete-auto-save-files nil)
 '(delete-old-versions 'other)
 '(fit-frame-to-buffer-margins '(5 nil nil nil))
 '(gdb-many-windows t)
 '(global-display-line-numbers-mode t)
 '(imenu-auto-rescan t)
 '(imenu-auto-rescan-maxout 500000)
 '(kept-new-versions 5)
 '(kept-old-versions 5)
 '(kill-whole-line nil)
 '(make-backup-file-name-function 'ignore)
 '(make-backup-files nil)
 '(mosue-wheel-follow-mouse nil)
 '(package-selected-packages
   '(color-theme-modern visual-fill-column fill-column-indicator zenburn-theme yasnippet-snippets which-key use-package try modern-cpp-font-lock magit flycheck busybee-theme auto-complete ample-theme))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Cascadia Code" :weight normal :height 110 :width normal))))
 '(hl-line ((t (:extend t :background "blue"))))
 '(mode-line ((t (:weight normal :height 1.2))))
 '(mode-line-active ((t (:background "gray27" :height 1.2 :width normal))))
 '(mode-line-highlight ((t nil)))
 '(mode-line-inactive ((t (:background "gray14" :weight normal :height 1.2)))))
(put 'upcase-region 'disabled nil)
