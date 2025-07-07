
//# publish
module 0xCAFE::DeprecationModule {
    use std::vector;

    // Annotate the entire module with a deprecated attribute
    // deprecated]
    struct DeprecatedStruct has copy, drop, store, key {
        a: u8,
        b: u8,
    }

    // Function with attribute indicating it is deprecated
    // deprecated]
    public fun deprecated_function(x: u8): u8 {
        if (x > 0) {
            let _temp = x + 1;
        } else {
            let _temp = x + 2;
        };
        while (x < 5) {
            // Use the implicit x in the loop condition
            let _ = x + 1;
        };
        // Compose complex expressions with sub-expressions
        let (sum1, sum2) = (
            (x + 3),
            (x * 2 + 1),
        );
        // Use nested expressions with type assertions
        let result: u8 = if (sum1 > sum2) { sum1 } else { sum2 };
        result
    }

    // Functions with different attribute annotations
    // doc = "This function is not deprecated"]
    public fun active_function(y: u8): u8 {
        y
    }

    // Inline function with an attribute
    // inline]
    public fun inline_func(a: u16): u16 {
        a + 10
    }

    // Function that creates sub-expressions for type testing
    public fun complex_expression_test() {
        let a: u8 = 2;
        let b: u8 = 3;
        let c: u8 = (a + b) * (a + 1);
        let d: u16 = (c as u16) + (0x10);
        let e: vector<u8> = b"Test";
        let _ = vector::length(&e);
    }
}


//# run 0xCAFE::DeprecationModule::deprecated_function --signers 0xBADD --args 4u8


//# run 0xCAFE::DeprecationModule::active_function --signers 0xBADD --args 5u8


//# run 0xCAFE::DeprecationModule::inline_func --signers 0xBADD --args 20u16


//# run 0xCAFE::DeprecationModule::complex_expression_test


// Featurres:
// d491b3262bf132a6ae19acd528b3d2fe: Deprecate entire modules using annotation attributes
// 34183dbe62dabfa8fcd639e71d83badf: Add functions to a module with associated attributes and kind annotations.
// 7f56308f09eac863aef51416f87aeccb: Create test expressions with sub-expressions and types.
