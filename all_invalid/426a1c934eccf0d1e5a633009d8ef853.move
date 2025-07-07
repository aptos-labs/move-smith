// #publish
//# publish
module 0xCAFE::ShadowTest {

    // Let's define a dummy `f1` function here instead of importing from MyModule,
    // since 0xCAFE::MyModule does not exist.
    // This matches the signature u8, bool -> u8 as used in the test.
    public fun f1(x: u8, y: bool): u8 {
        if (y) {
            x + 1
        } else {
            x
        }
    }

    // shadow_lambda takes a u8 and a lambda |u8|u8, and calls the lambda,
    // no shadowing of f is needed here other than being parameter.
    public fun shadow_lambda(x: u8, f: |u8| u8): u8 {
        f(x)
    }

    public fun test_shadow() {
        // Define a lambda shadowing the module function f1 (now local f1)
        let f1: |u8, bool| u8 = |x: u8, y: bool| {
            let _shadowed = f1(x, y); // call local module function
            x + 10
        };

        let res = f1(2u8, true);

        // Call shadow_lambda with a lambda parameter that shadows any f1 name (no conflict here)
        let r2 = shadow_lambda(5u8, |x: u8| {
            x * 2
        });

        // Explicit call to local f1 function
        let _ = f1(3u8, false);

        // No assertions — just test call structure and shadows
    }

    public fun runner() {
        test_shadow();
    }
}

// #run 0xCAFE::ShadowTest::runner
