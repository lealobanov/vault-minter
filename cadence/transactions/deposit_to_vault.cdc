import "ExampleToken"

// This transaction mints tokens and deposits them into the caller's vault
transaction {

    // Local variable for storing the reference to the minter resource
    let mintingRef: &ExampleToken.VaultMinter

    // Local variable for storing the receiver capability of the caller
    var receiver: Capability<&{ExampleToken.Receiver}>

    prepare(acct: auth(Storage, Capabilities) &Account) {
        // Borrow a reference to the stored, private minter resource
        let minter = acct.storage.borrow<&ExampleToken.VaultMinter>(
            from: /storage/CadenceFungibleTokenTutorialMinter
        ) ?? panic("Could not borrow a reference to the minter")
        self.mintingRef = minter
        
        // Issue a Receiver capability for the caller's Vault
        let receiverCap = acct.capabilities.storage.issue<&{ExampleToken.Receiver}>(
            /storage/CadenceFungibleTokenTutorialVault
        )
        self.receiver = receiverCap
    }

    execute {
        // Mint 30 tokens and deposit them into the caller's Vault
        self.mintingRef.mintTokens(amount: 30.0, recipient: self.receiver)

        log("30 tokens minted and deposited to the caller's account")
    }
}