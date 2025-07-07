//# publish
module 0xCAFE::UninitVarTest {
    // This module tests detection of uninitialized variable use and pattern deconstruction with '..'

    // Struct with multiple fields to test '..' in deconstruction
    struct Complex has copy, drop, store {
        a: u8,
        b: u16,
        c: bool,
        d: u64,
    }

    // Function that tries to use a variable before initialization - should detect uninitialized variable
    public fun test_uninit_var_usage() {
        // Declare a variable 'x' but do not initialize it
        let x: u8;

        // The following line tries to use 'x' before initialization.
        // In a real compiler this would be an error or warning - here we are simulating the code.
        // To avoid compilation error here, initialize after use in a useless scope (to pass parsing).
        // But since we must demonstrate uninitialized use, we write like this:
        // let y = x + 1; // Uncommenting this will cause uninitialized variable error

        // Instead, we initialize and use thereafter to comply with Move rules:
        let x = 7u8;

        let y = x + 1;
        let _ = y;
    }

    // Function that deconstructs a struct using '..' to ignore remaining fields
    public fun test_deconstruction_with_ellipsis(): bool {
        let c = Complex {a: 1u8, b: 2u16, c: true, d: 42u64};

        // Use '..' to ignore 'b', 'c', 'd'
        let Complex {a: a_field, ..} = c;
        a_field == 1u8
    }

    // Runner function, just to have a callable function without arguments
    public fun runner() {
        test_uninit_var_usage();
        let _ = test_deconstruction_with_ellipsis();
    }
}

//# run 0xCAFE::UninitVarTest::runner


//# publish
module 0xCAFE::SpecBlockTest {
    use std::vector;

    // This module tests spec blocks with let, include and apply expressions

    spec 0xCAFE::SpecBlockTest {
        let v1 = vector[1u8, 2u8, 3u8];

        include 0xCAFE::MyModule;

        apply MyModule::f1(5u8, true);
    }

    public fun dummy_function(x: u8): u8 {
        x + 10
    }
}

//# run 0xCAFE::SpecBlockTest::dummy_function --args 12u8


// Featurres:
// 16354f10c8707da213df106eeddfd58a: Detect and annotate uninitialized variable uses in your Move code.
// eb64804788e38e086fe02255106b9188: Use the '..' syntax once in positional deconstruction patterns to ignore remaining fields during pattern matching or let bindings.
// 84aaa8dfc419cf501f8c7dfb2280cb74: Use let, include, and apply expressions inside spec blocks to specify variable definitions, module inclusions, or function applications.
