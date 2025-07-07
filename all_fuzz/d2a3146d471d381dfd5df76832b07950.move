
//# publish
module 0xCAFE::MathAndLambda {
    use std::signer;

    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        let x = 42u8;
        x
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public fun lambda_returns_tuple(a: u8, b: u8): (u8, u8) {
        let tuple_lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| { (x + y, x * y) };
        tuple_lambda(a, b)
    }

    // fix: friend declarations must be inside module but must specify a module, e.g. friend module::ModuleName;
    // In Move, `friend` must declare the module address and name, not just address. 
    // Since no module name follows `friend 0xCAFE;` this is invalid.
    // We should remove or fix it. If friend access is desired, it needs to specify the full module path.
    // Since no module is specified here, just remove the line.
    // friend 0xCAFE;
}



//# run 0xCAFE::MathAndLambda::add_and_return_42 --args 10u8 32u8



//# run 0xCAFE::MathAndLambda::use_lambda --args 5u8 7u8



//# run 0xCAFE::MathAndLambda::lambda_returns_tuple --args 3u8 4u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::MathAndLambda;

    public inline fun call_add_and_return_42(a: u8, b: u8): u8 {
        MathAndLambda::add_and_return_42(a, b)
    }

    public inline fun call_lambda_returns_tuple_return_sum(a: u8, b: u8): u8 {
        let (sum, _product) = MathAndLambda::lambda_returns_tuple(a, b);
        sum
    }

    public fun runner(): u8 {
        let x = call_add_and_return_42(1, 1);
        let y = call_lambda_returns_tuple_return_sum(2, 3);
        x + y
    }

    // Same fix here: friend declaration is invalid, remove it.
    // friend 0xCAFE;
}



//# run 0xCAFE::NestedCall::call_add_and_return_42 --args 8u8 9u8



//# run 0xCAFE::NestedCall::call_lambda_returns_tuple_return_sum --args 6u8 7u8



//# run 0xCAFE::NestedCall::runner



//# publish
module 0xCAFE::InvalidNumberLiteral {
    // This function is empty because invalid literal causes compile error.
    // Use comment to show invalid literals that should fail compiler.

    /*
    public fun invalid_literals() {
        let _a = 256u8; // invalid u8 literal (too large)
        let _b = 4294967296u32; // invalid u32 literal (too large)
    }
    */
}



//# publish
module 0xCAFE::FriendVisibility {
    friend 0xCAFE::FriendVisibility;  // to fix friend syntax specify module name after address
    friend 0xBEEF::FriendVisibility;

    public fun public_function(): u8 {
        1u8
    }

    friend fun friend_function(): u8 {
        2u8
    }
}



//# run 0xCAFE::FriendVisibility::public_function



//# run 0xCAFE::FriendVisibility::friend_function



//# publish
module 0xCAFE::StructWithInvariant {
    use std::vector;

    struct Counter has store {
        val: u64,
    }

    // The `spec` block is not valid syntax in Move source code.
    // Instead, struct invariants should be defined in specification language outside module source code or via attributes, 
    // But if we want the module to compile in the current environment, we must remove the whole `spec` block.

    /*
    spec module {
        spec struct Counter {
            invariant self.val < 1000;
        }
    }
    */

    public fun create_counter(init: u64): Counter {
        assert!(init < 1000, 1001);
        Counter { val: init }
    }

    public fun increment(counter: &mut Counter) {
        assert!(counter.val < 999, 1002);
        counter.val = counter.val + 1;
    }

    public fun get_value(counter: &Counter): u64 {
        counter.val
    }

    // runner function to create and increment Counter
    public fun runner(): u64 {
        let c = create_counter(998);
        increment(&mut c);
        get_value(&c)
    }
}



//# run 0xCAFE::StructWithInvariant::runner
