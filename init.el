;; Summary --- Beginning of my Emacs init file: Commentary:
; ///////////////////////////////// Startup & style
; inhibit splash screen
;(setq inhibit-splash-screen t)

; load path
(add-to-list 'load-path "~/.emacs.d/lisp/")

; Default find path
;(setq default-directory "D:/personal_projects/programming")

; change the font
;(set-face-attribute 'default t :font "Ubuntu Mono-17" :weight 'bold)
;(set-face-attribute 'default nil :font "Ubuntu Mono-17" :weight 'bold)
;(set-frame-font "Ubuntu Mono Bold 17")
;(add-to-list 'default-frame-alist '(font . "Ubuntu Mono Bold-17"))

(global-hl-line-mode 1)
(set-face-background 'hl-line "c1a256")

; add en dash character to the word constituent syntax class
(modify-syntax-entry ?– "w")
(global-superword-mode)

; load-theme
; (load-theme 'zenburn t)

; set the line spacing
(setq-default line-spacing 0.3)

;set cursor color
(set-cursor-color "green")

; Disabling middle mouse click
(global-unset-key [mouse-2])

; turn on electric pair mode
(electric-pair-mode 1)

; set 80 characters line-wrap
(add-hook 'c++-mode-hook (lambda () (interactive) (column-marker-1 80)))

; maximaise screen on startup
;(add-hook 'window-setup-hook 'toggle-frame-maximized t)

; set inital window width/height
; QHD mointor
;(setq default-frame-alist
;      '((top . 5) (left . 0) (width . 175) (height . 50)))

; QHD monitor(laptop) - Display scale (%175)
(setq default-frame-alist
      '((top . 5) (left . 0) (width . 92) (height . 41)))

;  FHD montior
;(setq default-frame-alist
;     '((top . 5) (left . 0) (width . 175) (height . 65)))

;(setq default-frame-alist
;      '((top . 5) (left . 0) (width . 85) (height . 49)))

; Startup windowing
(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)
;(split-window-horizontally)

; disable menu on startup
; (menu-bar-mode -1)

; disable tools on startup
(tool-bar-mode -1)

; disable scroll bar on startup
;(scroll-bar-mode -1)

; Enabling line number mode
(global-display-line-numbers-mode)

; Powerful info mini-menu
;(setq frame-title-format
;      (list (format"%s %%s: %%j " (system-name))
;      '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

; Smooth scrolling
(setq scroll-step 3)

; Display time
;(display-time)

; Always syntax highlighting
 (global-font-lock-mode 1)

; Highlight brackets/parenthesis
 (setq show-paren-delay 0
      show-paren-style 'parenthesis)
 (show-paren-mode 1)

; Set high limit for undo history
(setq undo-limit 2000000)
(setq undo-strong-limit 4000000)
;(setq max-specpdl-size 13000)

; Insert timd of the day
;(defun insert-timeofday ()
;  (interactive "*")
;  (insert (format-time-string "---------------- %a, %d %b %y: %I:%M%p"))
;  )
; //////////////////////////////// End of Startup & style

; //////////////////////////////// Customised keybining

; Prevent consecutive marks activating bloody `transient-mark-mode'.
(defadvice set-mark-command (after no-bloody-t-m-m activate)
  (if transient-mark-mode (setq transient-mark-mode nil)))

; Prevent mouse commands activiating bloody `transient-mark-mode'.
(defadvice mouse-set-region-1 (after no-bloody-t-m-m activate)
  (if transient-mark-mode (setq transient-mark-mode nil)))

; Replace a string without moving point
(defun replace-string (FromString ToString)
  (interactive "sReplace: \nsReplace: %s With: ")
  (save-excursion
    (replace-string FromString ToString)
    ))

; Perform a replace-string in the current region
(defun replace-in-region (old-word new-word)
  (interactive "sReplace: \nsReplace: %s With: ")
  (save-excursion (save-restriction
        (narrow-to-region (mark) (point))
        (beginning-of-buffer)
        (replace-regexp-in-region old-word new-word)
        ))
  )

; Navigaiton
; Moves to the previous line containing nothing but whitespace
(defun previous-blank-line ()
  (interactive)
  (search-backward-regexp "^[ \t]*\n")
  )

; Moves to the next line containing nothing but whitespace
(defun next-blank-line ()
  (interactive)
  (forward-line)
  (search-forward-regexp "^[ \t]*\n")
  (forward-line -1)
  )


; /////////////////////////////// End of customised keybinding

; //////////////////////////////// C/C++ style
; C/C++ mode handling
; Unique comments style
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

; Accepted file extensions and their appropriate modes
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

; C++ indentation style
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
  ; Set my style for the current buffer
  (c-add-style "BigFun" c-default-style t)

  ; 4-space tabs
  (setq tab-width 4
        indent-tabs-mode nil)

  ; Newline indents, semi-colon wont
  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))
  
  ; Additional style stuff
  (c-set-offset 'member-init-intro '++)

  ; No hungry backspace
  (c-toggle-auto-hungry-state -1)
  
  ; Abbrevation expansion
  (abbrev-mode 1)

  ; Format the given file as a header file
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

  ; Format the given file as a source file
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
  (define-key c++-mode-map "\ec" 'find-corresponding-file)
  (define-key c++-mode-map "\eC" 'find-corresponding-file-other-window)
  (define-key c++-mode-map [C-tab] 'indent-region)
  (define-key c++-mode-map "\C-y" 'indent-for-tab-command)
  (define-key c++-mode-map "^[  " 'indent-reg ion)


;(add-to-list 'compilation-error-regexp-alist 'amgun-devenv)
;  (add-to-list 'compilation-error-regexp-alist-alist '(amgun-devenv
;  "*\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) :
;  \\(?:see declaration\\|\\(?:warnin\\(g\\)\\|[a-z ]+\\) C[0-9]+:\\)"
;  2 3 nil (4)))
)



(add-hook 'c-mode-common-hook 'big-fun-c-hook)

; add en dash word "hyphenated compound word" as word constituents in the syntax table
(add-hook 'c++-mode-hook 'superword-mode)
(add-hook 'c++-mode-hook (lambda () (modify-syntax-entry ?- "w")))

; set "gnu" style indenting for c
  ; (setq c-default-style "Linux"
  ; c-basic-offset 4)
; //////////////////////////////// End of C/C++ style

; //////  C++ configuration by external packages
; Enabling melpa package archiver
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(use-package try :ensure t)
(use-package which-key :ensure t :config (which-key-mode))

(require 'column-marker)

(require 'yasnippet)
(yas-global-mode 1)

; auto-commplete
(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

; flycheck
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

; C++ font
;(use-package modern-cpp-font-lock
;  :ensure t)

; Magit
(use-package magit
  :ensure t
  :init
  (progn
    (bind-key "C-x g" 'magit-status)))

; C++ compilation
;(defun code-compile ()
;  (interactive)
;  (unless (file-exists-p "Makefile")
;    (set (make-local-variable 'compile-command)
;     (let ((file (file-name-nondirectory buffer-file-name)))
;       (format "%s -o %s %s"
;           (if  (equal (file-name-extension file) "cpp") "clang++ -o *.exe"  )
;           (file-name-sans-extension file)
;           file)))
;    (compile compile-command)))

;(global-set-key [f8] 'code-compile)

; Casey C/C++ Compilation (setq compilation-context-lines 0) (setq
;compilation-error-regexp-alist (cons
;'("^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) :
;\\(?:fatal error\\|warnin\\(g\\)\\) C[0-9]+:" 2 3 nil (4))
;compilation-error-regexp-alist))

(setq amgun-makescript "build.bat")
(setq compilation-directory-locked nil)


(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p amgun-makescript) t
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
  (if (find-project-directory) (compile amgun-makescript))
  (other-window 1))
(define-key global-map "\ev" 'make-without-asking)
; ///// End of C++ configuration //////

; ///////////////////////// Customised keybinds
;(define-key global-map "\ee" 'move-end-of-line)
;(define-key global-map "\ea" 'move-beginning-of-line)
;(define-key global-map [C-e] 'c-end-of-statement)
;(define-key global-map [C-a] 'c-beginning-of-statement)
(define-key global-map "\ef" 'find-file)
(define-key global-map "\eF" 'find-file-other-window)
(global-set-key (read-kbd-macro "\eb") 'ido-switch-buffer)
(global-set-key (read-kbd-macro "\eB") 'ido-switch-buffer-other-window)
(define-key text-mode-map "\es" 'save-buffer)
(define-key global-map "\e " 'set-mark-command)
(define-key global-map "\eq" 'copy-region-as-kill)
(define-key global-map "\er" 'kill-region)
(define-key global-map "\eh" 'next-line)
(define-key global-map "\eH" 'previous-line)
(define-key global-map "\em" 'forward-word)
(define-key global-map "\eM" 'backward-word)
(define-key global-map "\e;" 'exchange-point-and-mark)
(define-key global-map [f9] 'first-error)
(define-key global-map [f10] 'previous-error)
(define-key global-map [f11] 'next-error)
(define-key global-map "\en" 'next-error)
(define-key global-map "\eN" 'previous-error)
(define-key global-map "\eg" 'goto-line)
(define-key global-map "\ej" 'imenu)
; (define-key global-map "^Q" 'copy-region-as-kill)
; (define-key global-map "^F" 'yank)
; (define-key global-map "^Y" 'nil)
; (define-key global-map "^E" 'rotate-yank-pointer)
(define-key global-map "\eu" 'undo)
(define-key global-map "\e6" 'upcase-word)
(define-key global-map "\e^" 'captilize-word)
(define-key global-map "\e." 'fill-paragraph)
(define-key global-map "\el" 'replace-in-region)
(define-key global-map "\eo" 'query-replace)
(define-key global-map "\eO" 'replace-string)
; \377 is alt+backspace
(define-key global-map "\377" 'backward-kill-word)
(define-key global-map [M-delete] 'kill-word)
(define-key global-map "\e[" 'start-kbd-macro)
(define-key global-map "\e]" 'end-kbd-macro)
(define-key global-map "\e'" 'call-last-kbd-macro)
(define-key global-map "\er" 'revert-buffer)
(define-key global-map "\ek" 'kill-this-buffer)
(define-key global-map "\es" 'save-buffer)
(define-key global-map [C-right] 'forward-word)
(define-key global-map [C-left] 'backward-word)

; ///// End of C++ configuration //////

; ///////////////////////// Customised keybinds
(define-key global-map "\ef" 'find-file)
(define-key global-map "\eF" 'find-file-other-window)
(global-set-key (read-kbd-macro "\eb") 'ido-switch-buffer)
(global-set-key (read-kbd-macro "\eB") 'ido-switch-buffer-other-window)
(define-key text-mode-map "\es" 'save-buffer)
(define-key global-map "\e " 'set-mark-command)
(define-key global-map "\eq" 'copy-region-as-kill)
(define-key global-map [home] 'forward-sentence)
(define-key global-map [end] 'backward-sentence)
;(define-key global-map "\ez" ')
(define-key global-map "\em" 'forward-word)
(define-key global-map "\eM" 'backward-word)
(define-key global-map "\e:" 'view-back-to-mark)
(define-key global-map "\e;" 'exchange-point-and-mark)
(define-key global-map [f9] 'first-error)
(define-key global-map [f10] 'previous-error)
(define-key global-map [f11] 'next-error)
(define-key global-map "\en" 'next-error)
(define-key global-map "\eN" 'previous-error)
(define-key global-map "\eg" 'goto-line)
(define-key global-map "\ej" 'imenu)
; (define-key global-map "^Q" 'copy-region-as-kill)
; (define-key global-map "^F" 'yank)
; (define-key global-map "^Y" 'nil)
; (define-key global-map "^E" 'rotate-yank-pointer)
(define-key global-map "\eu" 'undo)
(define-key global-map "\e6" 'upcase-word)
(define-key global-map "\e^" 'captilize-word)
(define-key global-map "\e." 'fill-paragraph)
(define-key global-map "\el" 'replace-in-region)
(define-key global-map "\eo" 'query-replace)
(define-key global-map "\eO" 'replace-string)
; \377 is alt+backspace
(define-key global-map "\377" 'backward-kill-word)
(define-key global-map [M-delete] 'kill-word)
(define-key global-map "\e[" 'start-kbd-macro)
(define-key global-map "\e]" 'end-kbd-macro)
(define-key global-map "\e'" 'call-last-kbd-macro)
(define-key global-map "\er" 'revert-buffer)
(define-key global-map "\ek" 'kill-this-buffer)
(define-key global-map "\es" 'save-buffer)
(define-key global-map [C-right] 'forward-word)
(define-key global-map [C-left] 'backward-word)
(define-key global-map [C-up] 'previous-blank-line)
(define-key global-map [C-down] 'next-blank-line)
;(define-key global-map "\ea" 'beginning-of-line)
;(define-key global-map "\eA" 'end-of-line)
(define-key global-map [pgup] 'forward-page)
(define-key global-map [pgdown] 'backward-page)
;(define-key global-map [M-down] 'scroll-other-window)
;(define-key global-map [M-up] 'scroll-other-window-down)
(define-key global-map [M-left] 'previous-buffer)
(define-key global-map [M-right] 'next-buffer)
(define-key global-map "\ew" 'other-window)
(define-key global-map "\ep" 'yank)

; Insert new line below current line
; and move cursor to new line
; it will also indent newline
(global-set-key (kbd "<C-return>") (lambda ()
                   (interactive)
                   (end-of-line)
                   (newline-and-indent)))
; Insert new line above current line
; and move cursor to previous line (newly inserted line)
; it will also indent newline
(global-set-key (kbd "<C-S-return>") (lambda ()
                       (interactive)
                       (beginning-of-line)
                       (newline-and-indent)
                       (previous-line)))
; //////////////////////////////////////// End of Customised keybinds

; //////////////////////////////////////// External packages

; modeline configuration
(setq-default mode-line-format nil)
(setq-default mode-line-format
	      '("%e"
		"  "
		(:eval (format "%s" (buffer-file-name)))
		"  "
		(:eval (format "%s" (propertize (symbol-name major-mode) 'face 'bold)))
		))

; //////////////////////////////////////// Auto-generated after first running.
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
 '(custom-enabled-themes '(amgun+tango-dark))
 '(custom-safe-themes
   '("5219ca6c3213e7f148831b15759edf43ed5dc6a9c63c2aaef2e5a1808dad1cc0" "\0125219ca6c3213e7f148831b15759edf43ed5dc6a9c63c2aaef2e5a1808dad1cc0" "\12\0125219ca6c3213e7f148831b15759edf43ed5dc6a9c63c2aaef2e5a1808dad1cc0" "\12\0124480a982e1db2aa509c2de8b05fe5fa295ef3e7338a9411c94c75d62bc4b1443" "\12\12f3f88f69b800f1d010b1533080650ef45fc813ac3cf0a6b007be795d9023a8cb" "\12\0127da57f796645c3277049df3195934b14e88e34b517fa6a76f99a031f8bebd91e" "\12\12d9871b56dd9151c0cbbccee9385c6e1670bbda5da4e3b30b58cb456792b29511" "\12\12f9cad8c375c78493243651c99a9d53317a702e2537cc57034b1c4443a7e3255d" "\12\12ee5e691ed0054ac41dc80c06765d3ab68640d64486631be84c796b6ff52bad1f" "\12\012729267e9b4bdbefeae5b316bd86bc41a532b08c62a87f95a269ff7951ea802c2" "\12\012379041523d033ee1d2ed479e519d01ea94ba08bb6b57d7b589995414584f2bf6" "\12\0126bdbd8cc485d400466a33b9592e7452daa1f12246030ef24909d72af9589ed35" "\12\12bf798e9e8ff00d4bf2512597f36e5a135ce48e477ce88a0764cfb5d8104e8163" "\12\12c9ddf33b383e74dac7690255dd2c3dfa1961a8e8a1d20e401c6572febef61045" "\12\01236ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "\12\12f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7" "\12\0121c7635fd451cc7834a4ec6ff92bf656d846cf75d9153ff01618f0d3e80323f04" default))
 '(delete-auto-save-files nil)
 '(delete-old-versions 'other)
 '(gdb-many-windows t)
 '(global-display-line-numbers-mode t)
 '(imenu-auto-rescan t)
 '(imenu-auto-rescan-maxout 500000)
 '(kept-new-versions 5)
 '(kept-old-versions 5)
 '(kill-whole-line nil)
 '(make-backup-file-name-function 'ignore)
 '(make-backup-files nil)
 '(mode-line-compact 'long)
 '(mosue-wheel-follow-mouse nil)
 '(package-selected-packages
   '(visual-fill-column fill-column-indicator zenburn-theme yasnippet-snippets which-key use-package try modern-cpp-font-lock magit flycheck busybee-theme auto-complete ample-theme))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "outline" :slant
 normal :weight bold :height 143 :width normal))))
 '(hl-line ((t (:extend t :background "blue"))))
 '(mode-line ((t (:background "#d3d7cf" :foreground "#2e3436"
 :box (:line-width (3 . 3) :color "blue") :weight normal :height
 0.8))))
 '(mode-line-buffer-id ((t (:slant italic :weight bold))))
 '(mode-line-inactive ((t (:background "#555753" :foreground "
#eeeeec" :weight normal :height1 0.8)))))
(put 'upcase-region 'disabled nil)
