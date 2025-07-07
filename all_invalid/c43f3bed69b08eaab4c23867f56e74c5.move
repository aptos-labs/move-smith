//# publish
module 0x1::AccessControlModule {
    // Private function: valid module identifier usage
    fun private_function(): u64 {
        42
    }

    public fun public_function(): u64 {
        100
    }

    public(entry) fun entry_function(account: &signer): u64 {
        let x: u64 = Self::private_function();
        let y = Self::public_function();
        x + y
    }

    // Runner function for test calls
    public fun runner(account: &signer) {
        let _ = Self::entry_function(account);
    }
}
//# run 0x1::AccessControlModule::runner --signers 0x1


//# publish
module 0x1::LocalBindingsModule {
    public fun runner() {
        // let with initializer and type annotation
        let a: u64 = 10;

        // let with initializer, no type annotation
        let b = 20u64;

        // let with type annotation, no initializer (should error normally, but here we can use TODO)
        // Move doesn't allow uninitialized variable in function scope, so always initialize

        // Rebinding variables
        let mut c: u64 = 5;
        c = c + a + b;

        // Use c to avoid unused warning
        let _ = c;
    }
}
//# run 0x1::LocalBindingsModule::runner


//# publish
module 0x1::LoopInvariantModule {
    public fun runner() {
        let mut i: u64 = 0;

        while (i < 5)
            invariant i <= 5
        {
            i = i + 1;
        }

        let mut j: u64 = 10;
        while (j > 0)
            invariant j <= 10
            invariant j > 0
        {
            j = j - 1;
        }
    }
}
//# run 0x1::LoopInvariantModule::runner


//# run
script {
    use 0x1::AccessControlModule;
    use 0x1::LocalBindingsModule;
    use 0x1::LoopInvariantModule;

    fun main(account: &signer) {
        AccessControlModule::runner(account);
        LocalBindingsModule::runner();
        LoopInvariantModule::runner();
    }
}