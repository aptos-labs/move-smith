
//# publish
module 0xCAFE::NamedAddrSpecTest1 {
    use std::signer;

    // Native spec function declaration (no body)
    spec native fun native_spec_fn(x: u8): u8;

    // Defined spec function with body and statement sequence
    spec fun defined_spec_fn(x: u8): u8 {
        let y = x + 1;
        y
    }

    public fun f_add_one(x: u8): u8 {
        let r = x + 1;
        r
    }

    // Spec for f_add_one that uses native spec function and succeeds_if
    spec f_add_one {
        // We expect result equal to native_spec_fn applied to input
        succeeds_if result == native_spec_fn(input);
    }

    // Spec with defined spec function and succeeds_if
    spec f_add_one {
        succeeds_if result == defined_spec_fn(input);
    }

    // Input parameter alias for spec
    spec input: u8;
    spec result: u8;
}


//# publish
module 0xDEAD::NamedAddrSpecTest2 {
    use std::signer;

    // Native spec function on this named addr
    spec native fun native_spec_mul(x: u8, y: u8): u8;

    // Defined spec function with body that multiplies x and y
    spec fun defined_spec_mul(x: u8, y: u8): u8 {
        let prod = x * y;
        prod
    }

    public fun mul(x: u8, y: u8): u8 {
        x * y
    }

    spec mul {
        succeeds_if result == native_spec_mul(input_0, input_1);
    }
    spec mul {
        succeeds_if result == defined_spec_mul(input_0, input_1);
    }

    spec input_0: u8;
    spec input_1: u8;
    spec result: u8;
}


//# publish
module 0xBEEF::NamedAddrUser {
    use std::signer;
    use 0xCAFE::NamedAddrSpecTest1;
    use 0xDEAD::NamedAddrSpecTest2;

    public fun caller_fn1(x: u8): u8 {
        // Calls module at 0xCAFE
        NamedAddrSpecTest1::f_add_one(x)
    }

    public fun caller_fn2(x: u8, y: u8): u8 {
        // Calls module at 0xDEAD
        NamedAddrSpecTest2::mul(x, y)
    }

    spec caller_fn1 {
        // We expect the result to be equal to defined_spec_fn of NamedAddrSpecTest1
        succeeds_if result == NamedAddrSpecTest1::defined_spec_fn(input);
    }
    spec caller_fn2 {
        // We expect the result to be equal to defined_spec_mul of NamedAddrSpecTest2
        succeeds_if result == NamedAddrSpecTest2::defined_spec_mul(input_0, input_1);
    }

    spec input: u8;
    spec input_0: u8;
    spec input_1: u8;
    spec result: u8;
}


//# run 0xCAFE::NamedAddrSpecTest1::f_add_one --args 10u8


//# run 0xDEAD::NamedAddrSpecTest2::mul --args 5u8 4u8


//# run 0xBEEF::NamedAddrUser::caller_fn1 --args 7u8


//# run 0xBEEF::NamedAddrUser::caller_fn2 --args 3u8 2u8


// Featurres:
// 1e5d2305b264af31c3fdc80e4a2bc9cc: Use named addresses for module definitions.
// d2c40146156c397fcaabfbbfe969e2af: Use 'succeeds_if' specifications to define detailed success conditions.
// 40dd5f2d2d0593977243d4dde78a926d: Choose between native spec functions (no body) and defined spec functions (with a statement sequence body).
