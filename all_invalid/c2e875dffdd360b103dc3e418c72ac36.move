//# publish
module 0xCAFE::CommaListTest {
    use std::signer;

    struct S has store {
        x: u64,
        y: bool,
        z: address,
    }

    // A public entry function with comma-separated parameters enclosed in parentheses
    public entry fun entry_comma_params(s: signer, a: u8, b: bool, c: address) {
        // do nothing, just consume parameters
    }

    // A function with comma separated list of arguments enclosed in braces (like struct initialization)
    public fun create_s(addr: address): S {
        S { x: 42u64, y: true, z: addr }
    }

    // An example entry function that takes a function (lambda) as argument
    public entry fun entry_lambda(
        s: signer,
        f: &fun(u64, bool): address
    ) {
        let result = f(7u64, true);
        // just calls the lambda and ignores result
        let _ = result;
    }

    // An example entry function which takes a lambda that itself calls another lambda
    public entry fun entry_lambda_nested(
        s: signer,
        f_outer: &fun(u64, &fun() : bool): address,
        f_inner: &fun(): bool
    ) {
        let result = f_outer(100u64, f_inner);
        let _ = result;
    }

    spec module {
        // Define a spec schema for struct S using a spec block
        struct SSchema {
            x: u64,
            y: bool,
            z: address,
        }

        // Implement a spec schema for S that corresponds to its fields
        spec schema SSchema {
            exists(s: &S): SSchema {
                SSchema {
                    x: s.x,
                    y: s.y,
                    z: s.z,
                }
            }
        }
    }
}

//# run 0xCAFE::CommaListTest::entry_comma_params --signers 0xCAFE --args 12u8 true 0xCAFE

//# run 0xCAFE::CommaListTest::entry_lambda --signers 0xCAFE --args 0xCAFE::CommaListTest::helper_lambda

//# run 0xCAFE::CommaListTest::entry_lambda_nested --signers 0xCAFE --args 0xCAFE::CommaListTest::outer_lambda 0xCAFE::CommaListTest::inner_lambda

//# publish
module 0xCAFE::Helpers {
    use std::address;

    public fun helper_lambda(a: u64, b: bool): address {
        if (b) {
            address::from_u64(a)
        } else {
            address::from_u64(0)
        }
    }

    public fun inner_lambda(): bool {
        true
    }

    public fun outer_lambda(a: u64, f: &fun(): bool): address {
        if (f()) {
            address::from_u64(a + 1)
        } else {
            address::from_u64(0)
        }
    }
}

// Featurres:
// 9131b37f58fd482dcc6bfc9a83ea2737: Define comma-separated lists of items (such as function parameters, struct fields, or arguments) enclosed in delimiters (e.g., parentheses or braces).
// de61b048363c46864ca566f1bda1de66: Define specification schemas in a module via spec blocks targeting schemas
// 8c738cf5e5ee14fc926782c3f0f6d187: Test that lambda expressions (function values) can be passed as arguments to public entry functions, including using lambdas that call other lambdas as arguments.
