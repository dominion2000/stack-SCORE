 stack-SCORE

A simple Clarity smart contract for tracking and managing user points on the Stacks blockchain. This contract allows an admin to add or subtract points for users, and users to transfer points between each other.

 Features

- **Admin-controlled points management:** Only the admin can add or subtract points for users.
- **User-to-user transfers:** Users can transfer points to other users.
- **Admin role management:** The admin can transfer admin rights to another principal.
- **Read-only queries:** Anyone can check the points balance of any user.

 Contract Functions

 Read-only

- `get-points (user principal)`  
  Returns the points balance for the specified user.

 Public

- `add-points (user principal) (amount int)`  
  Admin only. Adds points to a user's balance.

- `subtract-points (user principal) (amount int)`  
  Admin only. Subtracts points from a user's balance (cannot go negative).

- `transfer-points (recipient principal) (amount int)`  
  Allows a user to transfer points to another user.

- `set-admin (new-admin principal)`  
  Admin only. Transfers admin rights to another principal.

 Usage

1. **Deploy the contract** to the Stacks blockchain.
2. **Set the admin** (automatically set to the deployer on contract creation).
3. **Admin can add or subtract points** for any user.
4. **Users can transfer points** to other users if they have sufficient balance.
5. **Admin can transfer admin rights** to another principal.

 Error Codes

- `u100`: Amount must be positive.
- `u102`: Points cannot go negative.
- `u103`: Insufficient points for transfer.
- `u401`: Unauthorized (not admin).

 Example

```clarity
;; Add points to a user (admin only)
(add-points 'SP123... 50)

;; Subtract points from a user (admin only)
(subtract-points 'SP123... 10)

;; Transfer points from sender to recipient
(transfer-points 'SP456... 20)

;; Get points for a user
(get-points 'SP123...)

;; Change admin
(set-admin 'SP789...)
```
