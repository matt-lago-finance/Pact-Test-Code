(namespace "free")
(define-keyset "admin-lagot"
  (read-keyset "admin-lagot")
)

(module vote-system GOVERNANCE
  @doc " Vote on Proposal #1 - Should Grant Funding Be Provided to Dev A? "

  (defcap GOVERNANCE ()
    "Only admin can update this module"
    (enforce-keyset 'admin-lagot))

  (defschema votes-schema
    "Votes table schema"
    option:string
    count:integer)

  (deftable votes:{votes-schema})

  (defun vote (key:string)
    "Submit a vote for Proposal #1"
    (enforce (contains key ["Yes" "No"]) "You can only vote for Yes or No")
    (with-read votes key { "count" := count }
      (update votes key { "count": (+ count 1) })
    )
    (format "Voted {}!" [key])
  )

  (defun getVotes:integer (key:string)
    "Get the votes count by key"
    (at 'count (read votes key ['count]))
  )

  (defun init ()
    "Initialize the rows in votes table"
    (insert votes "Yes" { "option": "Yes", "count" : 0 })
    (insert votes "No" { "option": "No", "count" : 0 })
  )

  (defun get-keys (table-name)
    (keys votes))
)

;--------------------------------------------------------------------------
; Create table and initialize
;--------------------------------------------------------------------------
; (create-table votes)
; (free.vote-system.init)

