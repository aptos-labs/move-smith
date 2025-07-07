//# publish
module 0x1::Dep {
    use std::signer;
    use std::vector;

    #[skip(lint_arithmetic, lint_uninitialized)]
    struct R has key {
        value: u64,
    }

    // Initialize the resource R in the signer's account
    public fun init(account: &signer) {
        move_to(account, R { value: 0 });
    }

    // Function that modifies R depending on input v
    public fun do(account: &signer, v: u64) {
        let r_ref = borrow_global_mut<R>(signer::address_of(account));
        if (v % 2 == 0) {
            // Even v: increment value by v
            r_ref.value = r_ref.value + v;
        } else {
            // Odd v: decrement value by 1 if possible
            if (r_ref.value > 0) {
                r_ref.value = r_ref.value - 1;
            }
        }
    }

    // Runner function to test do() interaction on R
    public fun run_tests(account: &signer) {
        init(account);
        do(account, 10);  // Even - should increase value by 10
        do(account, 3);   // Odd - should decrease value by 1
        do(account, 0);   // Even - increase by 0 (no change)
        do(account, 15);  // Odd - decrease by 1
    }
}
//# run 0x1::Dep::run_tests --signers 0x1

//# publish
module 0x1::Main {
    use std::signer;
    use 0x1::Dep;

    #[skip(lint_unused_import)]
    public fun entry(account: &signer, v: u64) {
        // Call Dep::do to exercise interaction with resource R
        Dep::do(account, v);
    }
}
//# run 0x1::Main::entry --signers 0x1 --args 4u64

//# run 0x1::Main::entry --signers 0x1 --args 7u64

//# run
script {
    use std::signer;
    use 0x1::Dep;
    use 0x1::Main;

    fun main(account: &signer) {
        // Initialize the resource first
        Dep::init(account);

        // Directly test Dep::do with some values
        Dep::do(account, 2);
        Dep::do(account, 9);

        // Now test Main::entry as an alternative entry point
        Main::entry(account, 6);
        Main::entry(account, 11);
    }
}