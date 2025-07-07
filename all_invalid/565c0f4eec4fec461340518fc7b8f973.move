//# publish
module 0xCAFE::FooBar {
    use std::signer;

    const CONST_VAL: u8 = 5 + 3;

    public fun bar(x: u8): u8 {
        if (x > 10) {
            2 * x
        } else {
            x + 1
        };
    }

    public fun foo(s: signer, val: u8): u8 {
        let result = bar(val);
        let assigned;
        if (val > 5) {
            assigned = val * 2;
        } else {
            assigned = val + 2;
        };
        result + assigned
    }

    public fun run() {
        let _ = bar(7u8);
        let _ = foo(signer::address_of(&signer::borrow(&signer::borrow_signer_for_testing())), 4u8);
        let _ = foo(signer::address_of(&signer::borrow(&signer::borrow_signer_for_testing())), 8u8);
    }
}

//# run 0xCAFE::FooBar::run

//# run 0xCAFE::FooBar::bar --args 13u8

//# run 0xCAFE::FooBar::foo --signers 0xBABE --args 7u8

//# run 0xCAFE::FooBar::foo --signers 0xBABE --args 3u8

// Featurres:
// fa7aeaedb78b1deb3914ab164798b74e: Refer to modules or addresses with 'Module::' or 'Address::' instead of 'Module.' or 'Address.'.
// 5ad335da8be1c3196ef5853fa8f1703a: Assign a value to the constant using '=' followed by an expression.
// e6d19f25828c485cf6faa0485162493f: Test that the functions correctly assign and multiply values based on conditional logic and invoke the bar function accordingly.
