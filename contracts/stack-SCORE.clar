;; ------------------------------------------------------------
;; User Points System - A simple Clarity smart contract
;; Tracks points for users, allows admin updates and transfers.
;; ------------------------------------------------------------

(define-data-var admin principal tx-sender)

(define-map user-points
  { user: principal }
  { points: int }
)

;; -------------------------------
;; Read-only functions
;; -------------------------------

(define-read-only (get-points (user principal))
  (default-to { points: 0 } (map-get? user-points { user: user }))
)

;; -------------------------------
;; Private helper
;; -------------------------------

(define-private (is-admin (sender principal))
  (is-eq sender (var-get admin))
)

;; -------------------------------
;; Public functions
;; -------------------------------

(define-public (add-points (user principal) (amount int))
  (begin
    (asserts! (> amount 0) (err u100)) ;; amount must be positive
    (asserts! (is-admin tx-sender) (err u401)) ;; only admin can add points
    (let (
      (current (get-points user))
      ;; <CHANGE> Fixed: changed (get current points) to (get points current)
      (new-amount (+ (get points current) amount))
    )
      (map-set user-points { user: user } { points: new-amount })
      (ok new-amount)
    )
  )
)

(define-public (subtract-points (user principal) (amount int))
  (begin
    (asserts! (> amount 0) (err u100))
    (asserts! (is-admin tx-sender) (err u401))
    (let (
      (current (get-points user))
      ;; <CHANGE> Fixed: changed (get current points) to (get points current)
      (new-amount (- (get points current) amount))
    )
      (asserts! (>= new-amount 0) (err u102)) ;; cannot go negative
      (map-set user-points { user: user } { points: new-amount })
      (ok new-amount)
    )
  )
)

(define-public (transfer-points (recipient principal) (amount int))
  (begin
    (asserts! (> amount 0) (err u100))
    (let (
      (sender-points (get-points tx-sender))
      (recipient-points (get-points recipient))
    )
      (asserts! (>= (get points sender-points) amount) (err u103))
      ;; subtract from sender
      (map-set user-points
        { user: tx-sender }
        { points: (- (get points sender-points) amount) }
      )
      ;; add to recipient
      (map-set user-points
        { user: recipient }
        { points: (+ (get points recipient-points) amount) }
      )
      (ok true)
    )
  )
)

(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-admin tx-sender) (err u401))
    (var-set admin new-admin)
    (ok new-admin)
  )
)