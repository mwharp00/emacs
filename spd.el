;; spd.el --- Select one of two planner-diretories
;; By Raymond Zeitler
;; Time-stamp: "2005-11-21 12:25:56 svenkloppenburg"
;; $Revision: 0.3 $
;; This is free software

;; This package works with planner.el by John Wiegley <johnw@gnu.org>.

;; Usage:
;; M-x select-planner-project to set planner-project to spd-planner-work-directory.
;; or
;; C-u M-x select-planner-project to set planner-project to spd-planner-personal-directory.


;; add to your .emacs:
;; (setq spd-planner-work-directory "D:/path/to/work/directory"
;;      spd-planner-personal-directory "D:/path/to/personal/directory"
;;      spd-save-buffers-before-kill t)
;; The last variable is optional.
;; 
;;  06/29/04  Created.
;;  06/30/04  Substantially fixed.
;;  07/15/04  Somehow managed to make spd-kill-buffers work.
;;  07/21/04  Added spd-save-buffers-before-kill option.
;;
(defun select-planner-project (&optional arg)
  "Change `planner-project' to either a Work or a Personal directory.
Use \\[universal-argument] to set `planner-project' to `spd-planner-personal-directory'.
Otherwise set it to `spd-planner-work-directory'.
Setting `spd-save-buffers-before-kill' forces a save of all planner buffers
before killing them.  If nil, user is prompted before unsaved buffers are killed."
  (interactive "*P")
  (let ((spd spd-planner-work-directory))
    (if arg
	(setq spd spd-planner-personal-directory))
    (if (eq spd planner-project)
	(message "Planner is already using %s." spd)
      (if spd-save-buffers-before-kill
	  (planner-save-buffers))
      (spd-kill-buffers)
      (setq planner-project spd)
      (message "Planner is switching to %s." spd)
      (planner-goto (planner-today)))))

(defun spd-kill-buffers ()
  "Kill all planner buffers.
Copied from `planner-save-buffers'."
  (interactive)
  (let ((buffers (delq nil
                  (mapcar
                   (lambda (buf)
                     (with-current-buffer buf
                       (when (and (planner-derived-mode-p 'planner-mode)
                                  (planner-page-name))
                         buf)))
                   (buffer-list)))))
    (while buffers
      (when (buffer-live-p (car buffers))
        (kill-buffer (car buffers)))
      (setq buffers (cdr buffers)))))
(provide 'spd)
;;; spd.el ends here
