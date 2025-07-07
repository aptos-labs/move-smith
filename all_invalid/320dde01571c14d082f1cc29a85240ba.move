//# publish
module 0x100::DependencyModule {
    use std::string;

    #[skip(incorrect_rule, another_lint)]
    struct R has key {
        val: u64,
    }

    public fun create_r(): R {
        R { val: 0 }
    }

    public fun update_r(r: &mut R, v: u64) {
        // If v is even, add v to r.val, else subtract v
        if (v % 2 == 0) {
            r.val = r.val + v;
        } else {
            r.val = r.val - v;
        }
    }

    public fun get_val(r: &R): u64 {
        r.val
    }

    public fun runner() {
        let mut r = create_r();
        update_r(&mut r, 42);
        update_r(&mut r, 33);
        // No assertions needed
    }
}
//# run 0x100::DependencyModule::runner

//# publish
module 0x100::MainModule {
    use 0x100::DependencyModule;
    use std::string;

    #[skip(memory_empty_check, deprecated_usage)]
    struct RContainer has key {
        r: DependencyModule::R,
        description: vector<u8>,
        big_num: u128,
        byte_str: vector<u8>,
        hex_str: vector<u8>,
    }

    /// Function demonstrating decimal literals with underscores,
    /// string literals starting with b" and x".
    public fun do_(account: &signer, v: u64) {
        let big_number: u128 = 1_000_000_000_000_000; // decimal literal with underscores

        // byte-string literal: b"hello"
        let byte_literal: vector<u8> = b"hello";

        // hex literal: x"48656c6c6f" (hex for "Hello")
        let hex_literal: vector<u8> = x"48656c6c6f";

        let mut r = DependencyModule::create_r();
        DependencyModule::update_r(&mut r, v);

        let container = RContainer {
            r,
            description: byte_literal,
            big_num: big_number,
            byte_str: byte_literal,
            hex_str: hex_literal,
        };

        // no assertions, just exercising different value use
        let _val = DependencyModule::get_val(&container.r);
    }

    public fun runner(account: &signer) {
        do_(account, 100u64);
        do_(account, 55u64);
    }
}
//# run 0x100::MainModule::runner --signers 0x100

//# run
script {
    use 0x100::MainModule;

    fun main(account: signer) {
        // Run do_ with some decimal literal with underscores
        MainModule::do_(&account, 1_234_567u64);

        // Run do_ with odd number to test conditional branch
        MainModule::do_(&account, 7u64);
    }
}