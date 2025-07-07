
//# publish
module 0xCAFE::NamedImports {
    use std::signer;
    use std::vector;
    use std::option;
    
    struct Container<T> has store {
        value: T
    }

    public fun create_container<T>(val: T): Container<T> {
        Container<T> { value: val }
    }

    public fun get_value<T>(c: &Container<T>): &T {
        &c.value
    }

    public fun nested_if_else(x: u8): u8 {
        if (x < 10) {
            if (x < 5) {
                1
            } else {
                if (x == 7) {
                    2
                } else {
                    3
                };
            }
        } else {
            4
        };
    }
}


//# run 0xCAFE::NamedImports::nested_if_else --args 3u8


//# run 0xCAFE::NamedImports::nested_if_else --args 6u8


//# run 0xCAFE::NamedImports::nested_if_else --args 7u8


//# run 0xCAFE::NamedImports::nested_if_else --args 11u8


//# run 0xCAFE::NamedImports::create_container --args 42u64


// Featurres:
// a49b8e82c01c39e09dcc85474f787b58: Use named imports (use declarations) within modules.
// a891707b80970a1938797437ba7a174b: Verify that nested if-else statements correctly execute and that the function completes without triggering assertions or errors.
// 1d224cd473501aa415dc18790f5c282a: Define generic parameters for functions, structs, or modules using angle-bracket (<...>) syntax.
