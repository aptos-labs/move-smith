
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Define a module with an optional spec designation (simulated by a comment)
    // The module does not use `spec` keyword; just a normal module
    // Purpose: test that module without `spec` designation compiles and runs

    // Public function to test internal features
    public fun test_feature_x(value: u8): u8 {
        // Test control flow and basic operations
        if (value > 5) {
            let _ = 10;
        } else {
            let _ = 20;
        }; // Semicolon to end the if statement
        while (value < 10) {
            // Increment value, but since value is immutable, simulate with a dummy variable
            // or just use break to prevent an infinite loop
            break;
        }; // Semicolon to end the while loop
        value
    }
}



//# run 0xDEAD::TestModule::test_feature_x --args 7u8



//# publish
module 0xBADA::ComplexTest {
    use std::vector;

    // Define a module to test nested structs, enums, and generics
    // Implicit "non-spec" designation by being a normal module

    struct InnerStruct has copy, drop, store {
        a: u8,
        b: u16,
    }

    struct OuterStruct<T> has copy, drop, store {
        inner: T,
        count: u64,
    }

    enum InnerEnum has copy, drop {
        A,
        B(u8, u8),
        C { flag: bool }
    }

    public fun create_structs(): (OuterStruct<InnerStruct>, InnerEnum) {
        let inner = InnerStruct {a: 255, b: 65535};
        let outer = OuterStruct {inner: inner, count: 42};
        let enum_value = InnerEnum::B(1, 2);
        (outer, enum_value)
    }

    public fun use_generic_and_enum() {
        let (_outer, enum_variant) = create_structs();

        let value_from_enum = match (enum_variant) {
            InnerEnum::A => 0,
            InnerEnum::B(x, y) => x + y,
            InnerEnum::C { flag } => {
                if (flag) {1} else {0}
            }; // Semicolon after if expression
        }; // Semicolon after match expression
        // No assertions, just exercises features
        assert!(value_from_enum <= 255, 999);
    }
}



//# run 0xBADA::ComplexTest::use_generic_and_enum



//# publish
module 0xC0FFEE::SpecTest {
    // Simulate a module with a "spec" designation via comment and naming
    // As actual spec attribute is not supported in Move, this is for test coverage

    // Define a struct with pre/post conditions (they are simulated as comments, since not enforced here)
    struct S has copy, drop, store {
        p: u8,
        q: u16,
    }

    public fun create_spec_struct(p_value: u8): S {
        // Here, simulating a spec precondition: p_value should be less than 128
        // But in code, just create and return
        S { p: p_value, q: p_value as u16 }
    }

    public fun use_spec_struct() {
        let s = create_spec_struct(50);
        let _ = s.p;
        let _ = s.q;
    }
}



//# run 0xC0FFEE::SpecTest::use_spec_struct



//# publish
module 0xFADE::NegativeTest {
    // The following should cause a compilation error due to forbidden negative integers
    // but in Move, integers are unsigned, so simulation is that code with negative literals should be rejected
    // To simulate, just leave as comment or invalid code

    // public fun invalid_negative(): u8 {
    //     -1u8 // invalid in Move syntax, uncommenting should cause diagnostics
    // }
}
