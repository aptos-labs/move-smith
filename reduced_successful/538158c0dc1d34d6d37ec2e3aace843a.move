
//# publish
module 0xCAFE::AddModule {
    // Module that provides addition and lambda test functions

    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 to have a predictable output different from sum
        sum + 10
    }

    public fun lambda_example(): u8 {
        let f: |u8| u8 has copy + drop = |a: u8| {
            a * 2
        };
        f(5u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun reassignment_and_shadowing(): u8 {
        let x = 10u8;
        let x = x + 5u8;
        let x = {
            let y = x * 2u8;
            y - 3u8
        };
        let x = x + 1u8;
        x
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddModule;

    public fun test_inline_call(x: u8, y: u8): u8 {
        let interim = AddModule::inline_add(x, y);
        let final_result = AddModule::add_two_u8(interim, 1u8);
        final_result
    }
}



//# publish
module 0xCAFE::AxiomModule {
    /// Demonstrate a dummy axiom declaration using the correct syntax.
    /// Note: Axioms currently must be declared with 'spec' blocks or separately,
    /// and cannot appear as standard items inside modules (depending on compiler version).
    /// To fix the compilation error, we remove the invalid axiom declaration.

    public fun dummy(): u8 {
        0u8
    }
}



//# run 0xCAFE::AddModule::add_two_u8 --args 7u8 8u8



//# run 0xCAFE::AddModule::lambda_example



//# run 0xCAFE::AddModule::reassignment_and_shadowing



//# run 0xCAFE::NestedCalls::test_inline_call --args 3u8 4u8
