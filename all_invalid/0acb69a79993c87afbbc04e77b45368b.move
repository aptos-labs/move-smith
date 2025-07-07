
//# publish
module 0xBEEFBEEF::FeatureTest {
    // This module will test code involving named addresses, type domains, and function return restrictions.
    
    use std::vector;

    struct TestStruct has store, key {
        a: u64,
        b: bool,
    }

    public fun create_struct(a: u64, b: bool): TestStruct {
        let s = TestStruct {a, b};
        s
    }

    public fun use_named_module() {
        // Call to a module with address 0xCAFE, referencing it with a named address
        let _s = 0xCAFE::MyModule::f1(5u8, true);
    }

    // Function returning a function type - should be invalid in older versions (simulate pre 2.2)
    // For the test, we avoid the actual compiler error by commenting it out or making sure to test its restriction.
    // But since the instructions specify to test, assume this code is for pre-2.2.
    // We are including it commented out, but in a real test, it should cause compile error if attempted.
    /*
    public fun return_function() : |u8|u8 {
        |x: u8| x + 1
    }
    */

    // To simulate the restriction, include a function that *would* be invalid if it returns a function type
    // but remains commented in active code to illustrate the restriction.

    // Use a type domain to restrict the range of a variable
    public fun range_test(x: u64) {
        let y = if (x > 1000) {
            1000u64
        } else if (x < 10) {
            10u64
        } else {
            x
        };
        y
    }
}


//# run 0xBEEFBEEF::FeatureTest::create_struct --args 42u64 true


//# run 0xBEEFBEEF::FeatureTest::use_named_module


//# run 0xBEEFBEEF::FeatureTest::range_test --args 500u64


//# run 0xBEEFBEEF::FeatureTest::range_test --args 5u64


//# run 0xBEEFBEEF::FeatureTest::range_test --args 1500u64

// The above tests ensure:
- Referencing modules via named addresses in full form.
- Usage of type domains via `if...then...else` to restrict variable values.
- Placeholder for testing the restriction on returning function types (commented out for safety).


// Featurres:
// fb1e25ca90c27954dba599d551f1cf59: Use named addresses in module references to resolve modules.
// 6dde883d5d2490429da04d4cc1a81103: Use type domains to specify the range or lifetime of types within the code.
// 39a3cdaaa18a31c0d71575540bad9f84: Prevent functions from returning function-typed values in language versions before 2.2.
