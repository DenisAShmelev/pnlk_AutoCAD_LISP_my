;;;
;;;  Copyright 2022 Autodesk, Inc.  All rights reserved.
;;;
;;;  Use of this software is subject to the terms of the Autodesk license 
;;;  agreement provided at the time of installation or download, or which 
;;;  otherwise accompanies this software in either electronic or hard copy form.
;;;
;;;
;;; DESCRIPTION: 
;;;  Sample profile manipulation utilities. All functions return T on success and nil 
;;  on failure. See comments above each function for additional details.
;;;
;;; EXAMPLES:
;;;   
;;; - Set active profile: 
;;;     (sample-profile-set-active "MyProfile")
;;;
;;; - Import a profile:
;;;     (sample-profile-import "c:\\myExportedProfile.arg" "MyFavoriteProfile" T)
;;;
;;; - Delete a profile:
;;;     (sample-profile-delete "unwanted")
;;;
;;;
;;; - Import a profile, even if it already exists, and set it active.
;;;
;;;    (sample-profile-import "c:\\CompanyProfile.arg" "MyProfile" T)
;;;    (sample-profile-set-active "MyProfile")
;;;
;;;
;;; - Import a profile, if not already present, and set it active
;;;
;;;    (if (not (sample-profile-exists "myProfile"))
;;;        (progn
;;;         (sample-profile-import "c:\\CompanyProfile.arg" "MyProfile" T)
;;;         (sample-profile-set-active "MyProfile")
;;;        )
;;;    )
;;;
;;;
;;; - Import a profile and set it active when AutoCAD is first started.
;;;  Place the following code in acaddoc.lsp with the desired ".arg" filename 
;;;  and profile name...
;;;
;;;    (defun s::startup ()
;;;      (if (not (vl-bb-ref ':sample-imported-profile)) ;; have we imported the profile yet?
;;;          (progn
;;;  
;;;            ;; Set a variable on the bulletin-board to indicate that we've been here before.
;;;            (vl-bb-set ':sample-imported-profile T) 
;;;          
;;;            ;; Import the profile and set it active
;;;            (sample-profile-import "c:\\CompanyProfile.arg" "MyProfile" T)
;;;            (sample-profile-set-active "MyProfile")
;;;   
;;;          );progn then
;;;      );if
;;;    );defun s::startup
;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This helper function gets the profiles object.
;;
(defun sample-get-profiles-object ( / app pref profs )
 (vl-load-com)
 (and
  (setq   app (vlax-get-acad-object))
  (setq  pref (vla-get-preferences app))
  (setq profs (vla-get-profiles pref))
 )
 profs
);defun sample-get-profiles-object

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Determine if a profile exists. Returns T if the specified profile name exists, and nil if not.
;;
(defun sample-profile-exists ( name / profs )
 (and name
      (setq names (sample-profile-names))
      (member (strcase name) (mapcar 'strcase names))
 )
);defun sample-profile-exists

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set the active profile. 
;; NOTES: 
;;  - If the specified profile name is already active then the function returns T and makes no additional 
;;    changes.
;;
;;  - The specified profile must exist. (You can import a profile using the  'sample-profile-import' 
;;    function.) If the specified profile does not exist, the function returns nil.
;;
(defun sample-profile-set-Active ( name / profs )
 (and
  name
  (setq profs (sample-get-profiles-object))
  (or (equal (strcase name) (strcase (getvar "cprofile")))
      (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-put-activeProfile (list profs name))))
  )
 );and
);defun sample-profile-set-Active

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Delete the specified profile. Fails if the specified profile is current.
;; 
(defun sample-profile-delete ( name / profs )
 (and
  name
  (setq profs (sample-get-profiles-object))
  (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-deleteprofile (list profs name))))
 )
);defun sample-profile-delete
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Copy profile.
;;
(defun acad-pref-profile-copy ( source target / profs )
 (and
  source
  target
  (setq profs (sample-get-profiles-object))
  (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-CopyProfile (list profs source target))))
 )
);defun sample-profile-copy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Get a list of profile names
;;
(defun sample-profile-names ( / profs result )
 (and
  (setq profs (sample-get-profiles-object))
  (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-GetAllProfileNames (list profs 'result))))
  result
  (setq result (vlax-safearray->list result))
 )
 result
);defun sample-profile-names

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rename
;;
(defun sample-profile-rename ( oldName newName / profs )
 (and
  oldName
  newName
  (setq profs (sample-get-profiles-object))
  (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-RenameProfile (list profs oldName newName))))
 )
);defun sample-profile-rename

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Get a unique profile name. This function returns a unique profile name that is guaranteed 
;; to not be present in the current list of profiles.
;;
(defun sample-get-unique-profile-name ( / names n name )
 (setq names (sample-profile-names)
       names (mapcar 'strcase names)
        name "TempProfileName"
           n 1
 )
 (while (member (strcase (setq name (strcat name (itoa n)))) names)
  (setq n (+ n 1))
 )
 name
);defun sample-get-unique-profile-name

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Import
;; This function imports the specified .arg file and creates a new profile with the provided profile name.
;; If the specified profile already exists, it will be overwritten.
;; If the 'bUsePathInfo' parameter is non-nil then path information will be imported from the specified 
;; file. Otherwise, path information will be ignored.
;;
;; NOTES: 
;;  This function does not set the active profile. If you import a new profile 
;;  it will not become active unless it matches the name of the existing active profile. 
;;
;;  You can set the active profile by calling: 
;;    (sample-profile-set-active "ProfileName")
;;
(defun sample-profile-import ( filename profileName bUsePathInfo / sample-oldError profs isCProfile tempProfile result )

 ;; Set up an error handler so, if something goes wrong, we can put things back the way we found them
 (setq sample-oldError *error*)
 (defun *error* ( msg / )
  (if (and profileName
           tempProfile
           (equal tempProfile (getvar "cprofile"))
      )
      (progn
       ;; Something went wrong so put things back the way they were.
       (sample-profile-rename tempProfile profileName)
       (sample-profile-set-active profileName)
       (sample-profile-delete tempProfile)
      );progn then
  );if
  (setq *error* sample-oldError)
  (if msg
      (*error* msg)
      (princ)
  )
 );defun *error*

 (if (and bUsePathInfo
          (not (equal :vlax-false bUsePathInfo))
     )
     (setq bUsePathInfo :vlax-true)
     (setq bUsePathInfo :vlax-false)
 )
 (if (and filename
          (setq filename (findfile filename))
          profileName
          (setq profs (sample-get-profiles-object))
     );and
     (progn
      ;; We can't import directly to the current profile, so if the provided profile name matches 
      ;; the current profile, we'll need to:
      ;;  - rename the current profile to a unique name
      ;;  - import
      ;;  - set the new one current
      ;;  - delete the old one with the temp name
      (setq isCProfile (equal (strcase (getvar "cprofile")) (strcase profileName)))
      (if isCProfile
          (progn
           (setq tempProfile (sample-get-unique-profile-name))
           (sample-profile-rename (getvar "cprofile") tempProfile)
          );progn then
      );if

      ;; Import          
      (setq result (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-ImportProfile (list profs profileName filename bUsePathInfo)))))

      (if isCProfile
          (progn
           ;;  Handle current profile case...
           ;;  If the import was successful, then set the new profile active and delete the original
           ;;  else if something went wrong, then put the old profile back
           (if (and result
                    (setq result (sample-profile-set-Active profileName)) ;; set the newly imported profile active
               );and
               (sample-profile-delete tempProfile)            ;; then delete the old profile
               (sample-profile-rename tempProfile profileName);; else rename the original profile back to its old name
           );if
          );progn then
      );if
     );progn then
 );if

 (*error* nil) ;; quietly restore the original error handler
 result
);defun sample-profile-import

(princ)

;;;-----BEGIN-SIGNATURE-----
;;; UAoAADCCCkwGCSqGSIb3DQEHAqCCCj0wggo5AgEBMQ8wDQYJKoZIhvcNAQELBQAw
;;; CwYJKoZIhvcNAQcBoIIHaDCCB2QwggVMoAMCAQICEA4NuwSYzIKGkwcyf5wXD8sw
;;; DQYJKoZIhvcNAQELBQAwaTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0
;;; LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2lnbmlu
;;; ZyBSU0E0MDk2IFNIQTM4NCAyMDIxIENBMTAeFw0yMjA4MDUwMDAwMDBaFw0yMzA4
;;; MDUyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRMw
;;; EQYDVQQHEwpTYW4gUmFmYWVsMRcwFQYDVQQKEw5BdXRvZGVzaywgSW5jLjEXMBUG
;;; A1UEAxMOQXV0b2Rlc2ssIEluYy4wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
;;; AoICAQDi5pcIp9vO2hdmo2sLgbBQFaGobtbE1HyFCuRxFMeR124Yxnjddq/S1q6y
;;; SZeNFwA3+BC0Ba9ucDCcW2YibvH1I/c7En6PVTeO3+ioqGU08nB3Fe34E8w06Lra
;;; VE95uqyWI1Bin2GJ8gIICaoZEmf3euyYCnhgc28lF4LR8JEgD7ANh6JQ4a6VXMOP
;;; DwHMUKMSciIFTU0M+pWA28RAN/XzSHmO3jm9P3jK71p/pnr2EMJa36okS2518clo
;;; 3e/0B1TJUqZfYEiEFVATsKkrt/ExQ1OIGiDo/moah4Bv79aV8z1ZxQ5Q80znpRZp
;;; Sc3wM4RS29ZAPpNGd+xmBJZZa5Smbg4PDGE6buYQYP+lDdfyydxLacKXZX2p5snK
;;; RbV0QYL9QIKBOs1zBX50dqwlJv7JEZzZEpzFaGsPFlhRcjz6A00L2HoDN5qruQn2
;;; fgSvEyBu4tNgvgDTjfreVLFwxePz6a5ppZ9e6jfE6xd8KnPdy54eaRcIGpSHWP24
;;; LWT1lrgJDjJfEsM+mykhsDUWikVNOM4HxViuxn3TEb2ApX2TUtF6MO+OSsc/TnZz
;;; +lk6Wi0lCrp5XqvAPwQUFY0Im2ljNaqEG1XZ5lhqqZuKTYbuIf1LqDks28G6a1Bi
;;; VCWsuQW8Y1PLyK9gR3e4XyGPrLjiVVvOXKeqOLOyVY52rqmoOwIDAQABo4ICBjCC
;;; AgIwHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHQYDVR0OBBYEFFpg
;;; X3UHe8qo4A3YomDtyEKjjkq2MA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggr
;;; BgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRwOi8vY3JsMy5kaWdpY2Vy
;;; dC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JTQTQwOTZTSEEzODQy
;;; MDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lD
;;; ZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAyMUNBMS5jcmww
;;; PgYDVR0gBDcwNTAzBgZngQwBBAEwKTAnBggrBgEFBQcCARYbaHR0cDovL3d3dy5k
;;; aWdpY2VydC5jb20vQ1BTMIGUBggrBgEFBQcBAQSBhzCBhDAkBggrBgEFBQcwAYYY
;;; aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMFwGCCsGAQUFBzAChlBodHRwOi8vY2Fj
;;; ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JT
;;; QTQwOTZTSEEzODQyMDIxQ0ExLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEB
;;; CwUAA4ICAQCflGPavxEna7llFy4JcUGqAfYQxElzlwzF5AlzCEkkk0IcZwJAWxkV
;;; npL9sTFx4idVniRi7ZeTmX5dKNiNK9g1oRw0kDZOn1n49IpNZDXVIlsKnTuAKub9
;;; 8qR7okQ8pt7/2aXEqiXdN01vgH2WBKyr0Z10aWjjM6FrhryLW905jlSYtrpplr8n
;;; XEbWepiKR+X76myg/2mWkB1NLdk6OA9E6qFs8mi+vzBfdsj/pWMEucOEAOburpBt
;;; 92Nwgb3n+KFawxPWm8w4n1GjO/up8k/BuTooJNK0lnXXlMJVexGYytN4oBj3pQW9
;;; 0kH+vVkkbtm5QLi/ez1RT4qFCb3/Ejlm8dT17pzTg/fyL1tYbrgBLdnJWheub1Ak
;;; 3H0Z7PjCxqCt6dJEX6JrAV0bfyTdq4zaWccDx6QYsW6gLfXA7y+RAh8OoR0/IE5m
;;; 1LIC3gs5yr/00GSCEtS1LyzgNl7/dPN/WiGhOjLRN+Qpa0awwRbLjdRxp3ekt9A2
;;; wt44GLEBvdzkdViGx1c1o8I8U1i45wLILGj77ot2C08dVLyZo/5jSkobzzZAFZMK
;;; e0/UxFgj93IUauGInxxCTsbXOK87UTuTOQQwRPT5zn8NvH/bMCXgwOT3pFYg4e/x
;;; t7U0nyOmIi48VPo3PgLiiD/L5pe3zJJx/UPyF9TJSkLRJWYTFPg7QDGCAqgwggKk
;;; AgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEw
;;; PwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2lnbmluZyBSU0E0MDk2
;;; IFNIQTM4NCAyMDIxIENBMQIQDg27BJjMgoaTBzJ/nBcPyzANBgkqhkiG9w0BAQsF
;;; ADANBgkqhkiG9w0BAQEFAASCAgAKdyCRyPFfDA1ucrK1Fk5DlVYCpKeGcEKAST+q
;;; Re5Savxa1ppSYeua9YdSbUzVHOokGiJRyxmgoicuyMjYitWjE0xylDH+qG/Nlu5h
;;; nO4Gelc6WuE5zhm6dEntwE0jPxIAlHjmirYTp8Dss6P4KKjBO76bY2CxbP+8BjJu
;;; cWEQSHQ/ZVVFR5Mn0XKZEPo7ZQUdg9CGRbYpGMLvNQOn0UCihFMN9ZQulyvkQo6k
;;; q9Y3+7GQniCgrFXOtzeGFqaDfTp2yIxQtOtTmJmINDquvVUCL3p21PTJhhHbonT7
;;; SCzUC7icAX8i6KMJMp5ihNUSQVShlWRvMowrvMkX5g5RN6JAUukGisDm+3oX/242
;;; fDl8sTcKtnmhmqiTUnxLZdwwIYjLHUh0oWZ78XcAFiqVZnX9dd4aZRT0QoU0Qw3x
;;; qMhksv+d18Q7/8u/CEfIA6OdzcVQB43zp4F4syN+2JY7Q9q55nERSw0xhzoHFM0X
;;; ZSeuTm5oYj+7NUPbkO3dNruLGTUBLEgJmC4aisf4Gi35zdicKvK1RteG8wphKOk8
;;; oes6V8yK1DpFrikVNIUQTUs7VV2bFlz3YfT3km7f3wzV7WeLmq4PcXEgkYrQTD6I
;;; iUtMqXh6e2i+Nqc2RVPreVsNEwQFejnmIttyAceGYXV3K5lrNNWBq0IreZPH45ln
;;; xcXlJQ==
;;; -----END-SIGNATURE-----