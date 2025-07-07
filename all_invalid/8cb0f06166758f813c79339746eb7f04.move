//# publish
module 0x1::ValidAccessIdentifiers {
    use std::signer;

    #[test_only] // example attribute with simple name
    public fun runner(_signer: &signer) {
        // This function demonstrates modifying a mutable reference with a loop
        let mut x = 0;
        modify_ref(&mut x);
        assert!(x == 10, 100);
    }

    // This function takes a mutable reference and loops as many times as it returns
    public fun modify_ref(x: &mut u64): u64 {
        let n = 10;
        let mut i = 0;
        while (i < n) {
            *x = *x + 1;
            i = i + 1;
        }
        n
    }
}
//# run 0x1::ValidAccessIdentifiers::runner --signers 0x1

//# publish
module 0x1::AccessDemo {
    #[test_only]
    friend fun dummy() {}

    #[test_only]
    public fun runner() {
        // Empty runner just to trigger run command
    }
}
//# run 0x1::AccessDemo::runner

//# run
script {
    use std::signer;
    use 0x1::ValidAccessIdentifiers;

    fun main(acct: signer) {
        ValidAccessIdentifiers::runner(&acct);
    }
}