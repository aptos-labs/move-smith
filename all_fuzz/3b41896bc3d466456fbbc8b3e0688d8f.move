
//# publish
module 0xCAFE::Adder {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            // Just do nothing special here.
        } else {
            // no-op
        };
        sum
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        sum_lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_adder_add(a: u8, b: u8): u8 {
        Adder::add_two_values(a, b)
    }

    public fun call_adder_lambda(a: u8, b: u8): u8 {
        Adder::with_lambda(a, b)
    }

    public fun call_adder_inline(a: u8, b: u8): u8 {
        Adder::inline_add(a, b)
    }
}


//# publish
module 0xCAFE::DeprecatedMod {
    public fun greet(): u8 {
        0x1u8
    }
}


//# run 0xCAFE::Adder::add_two_values --args 20u8 22u8


//# run 0xCAFE::Adder::with_lambda --args 15u8 12u8


//# run 0xCAFE::Caller::call_adder_add --args 5u8 6u8


//# run 0xCAFE::Caller::call_adder_lambda --args 7u8 8u8


//# run 0xCAFE::Caller::call_adder_inline --args 9u8 10u8


//# run 0xCAFE::DeprecatedMod::greet


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// bb3122414df008b55b2402f42fbd31d6: Use identifiers to refer to named types.
// d491b3262bf132a6ae19acd528b3d2fe: Deprecate entire modules using annotation attributes
// b2081e928f636305e3be6e682bcc0741: Get notifications about the use of deprecated items with specific diagnostic codes.
