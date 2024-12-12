import "ExampleToken"

// This transaction mints tokens and deposits them into account 0x02's vault
transaction {

    // Local variable for storing the reference to the minter resource
    let mintingRef: auth(MintEntitlement) &ExampleToken.VaultMinter

    // Local variable for storing the reference to the Vault of
    // the account that will receive the newly minted tokens
    var receiver: Capability<&ExampleToken.Vault{ExampleToken.Receiver}>

    prepare(acct: auth(Storage, Capabilities) &Account) {
        // Borrow a reference to the stored, private minter resource
        self.mintingRef = acct.capabilities.storage.borrow<&ExampleToken.VaultMinter>(
            from: /storage/MainMinter
        ) ?? panic("Could not borrow a reference to the minter")
        
        // Get the public account object for account 0x02
        let recipient = getAccount(0x02)

        // Get their public receiver capability
        self.receiver = recipient.capabilities.borrow<&ExampleToken.Vault{ExampleToken.Receiver}>(
            /public/MainReceiver
        ) ?? panic("Could not borrow the receiver capability from account 0x02")
    }

    execute {
        // Mint 30 tokens and deposit them into the recipient's Vault
        self.mintingRef.mintTokens(amount: 30.0, recipient: self.receiver)

        log("30 tokens minted and deposited to account 0x02")
    }
}
