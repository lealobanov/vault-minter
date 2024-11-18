// VaultMinter
//
// Resource object that an admin can control to mint new tokens
access(all)
resource VaultMinter {

    // Function that mints new tokens and deposits into an account's vault
    // using their 'Receiver' capability.
    // We say '&AnyResource{Receiver}' to specify that the recipient can be any resource
    // as long as it implements the Receiver interface
    access(all)
    fun mintTokens(amount: UFix64, recipient: Capability<&AnyResource{Receiver}>) {
        let recipientRef = recipient.borrow()
            ?? panic("Could not borrow a receiver reference to the vault")

        ExampleToken.totalSupply = ExampleToken.totalSupply + UFix64(amount)
        recipientRef.deposit(from: <-create Vault(balance: amount))
    }
}
