(use-package pretty-mode :ensure t)
;; https://wjmn.github.io/posts/j-can-look-like-apl/
(use-package j-mode :ensure t :defer t
  :init
   (add-to-list 'auto-mode-alist '("\\.ij[rstp]$" . j-mode)
  :config
   ; (add-hook 'inferior-j-mode-hook 'turn-off-smartparens-mode)
   ; (add-hook 'j-mode-hook 'turn-off-smartparens-mode)
   
   ;; symbols
   (setq j-symbols
   '(("=\\."     . ?←)
     ("=:"       . ?⤆)
     ("_:"       . ?∞)
     ("<:"       . ?≤)
     (">:"       . ?≥)
     (">\\."     . ?⌈)
     ("<\\."     . ?⌊)
     ("\\*"      . ?×)
     ("%"        . ?÷)
     ("\\+\\."   . ?∨)
     ("-\\."     . ?¬)
     ("*\\."     . ?∧)
     ("%\\."     . ?⌹)
     ("\\+:"     . ?⍱)
     ("-:"       . ?≡)
     ("*:"       . ?⍲)
     ("%:"       . ?√)
     ("\\^\\."   . ?⍟)
     ("\\^:"     . ?⍣)
     ("\\$"      . ?⍴)
     ("\\$\\."   . ?ς)
     ("\\$:"     . ?∇)
     ("~"        . ?⍨)
     ("~\\."     . ?∪)
     ("~:"       . ?≠)
     ("|\\."     . ?⌽)
     ("|:"       . ?⍉)
     (",\\."     . ?⍪)
     (",:"       . ?⍿)
     (";:"       . ?⍧)
     ("#\\."     . ?⊥)
     ("#:"       . ?⊤)
     ("/\\."     . ?⍁)
     ("\\\\\\."  . ?⍂)
     ("/:"       . ?⍋)
     ("\\\\:"    . ?⍒)
     ("\\]"      . ?⊢)
     ("\\["      . ?⊣)
     ("\\[:"     . ?⍅)
     ("{\\."     . ?↑)
     ("}\\."     . ?↓)
     ("{:"       . ?⍏)
     ("}:"       . ?⍖)
     ("\""       . ?⍤)
     ("\"\\."    . ?⍎)
     ("\":"      . ?⍕)
     ("`"        . ?⍮)
     ("@"        . ?⍛)
     ("@\\."     . ?⌼)
     ("@:"       . ?⍜)
     ("\\&"      . ?∘)
     ("\\&\\."   . ?↺)
     ("\\&\\.>"  . ?¨)
     ("\\&:"     . ?⌾)
     ("\\?\\."   . ?⍰)
    ))

(defun prettify-j ()
  (progn
    (push '("a." . ?æ) prettify-symbols-alist)
    (push '("a:" . ?⍬) prettify-symbols-alist)
    (push '("A:" . ?⅍) prettify-symbols-alist)
    (push '("C." . ?ℂ) prettify-symbols-alist)
    (push '("d." . ?δ) prettify-symbols-alist)
    (push '("D." . ?Δ) prettify-symbols-alist)
    (push '("D:" . ?⌳) prettify-symbols-alist)
    (push '("e." . ?∊) prettify-symbols-alist)
    (push '("E." . ?⍷) prettify-symbols-alist)
    (push '("f." . ?ℱ) prettify-symbols-alist)
    (push '("i." . ?⍳) prettify-symbols-alist)
    (push '("i:" . ?ᵼ) prettify-symbols-alist)
    (push '("I." . ?⍸) prettify-symbols-alist)
    (push '("j." . ?ⅉ) prettify-symbols-alist)
    (push '("L." . ?ℒ) prettify-symbols-alist)
    (push '("NB." . ?⍝) prettify-symbols-alist)
    (push '("p." . ?ℙ) prettify-symbols-alist)
    (push '("p:" . ?⅌) prettify-symbols-alist)
    (push '("q:" . ?ℚ) prettify-symbols-alist)
    (push '("r." . ?∡) prettify-symbols-alist)
    (push '("y" . ?ω) prettify-symbols-alist)
    (push '("x" . ?α) prettify-symbols-alist)
    (push '("u" . ?⍶) prettify-symbols-alist)
    (push '("v" . ?⍹) prettify-symbols-alist)
    (prettify-symbols-mode)))

    (pretty-add-keywords 'inferior-j-mode j-symbols)
    (pretty-add-keywords 'j-mode j-symbols)
    
    (add-hook 'inferior-j-mode-hook 'turn-on-pretty-mode)
    (add-hook 'inferior-j-mode-hook 'prettify-j)
    (add-hook 'j-mode-hook 'turn-on-pretty-mode)
    (add-hook 'j-mode-hook 'prettify-j)
)
