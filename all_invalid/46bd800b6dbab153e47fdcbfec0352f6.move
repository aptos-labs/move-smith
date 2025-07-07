
//# publish
module 0xCAFE::NamedImports {
    // Removed unused `use` declarations:
    // use std::signer;
    // use std::vector;
    // use std::option;
    
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
                }
            }
        } else {
            4
        }
    }
}



//# run 0xCAFE::NamedImports::nested_if_else --args 3u8

//# run 0xCAFE::NamedImports::nested_if_else --args 6u8

//# run 0xCAFE::NamedImports::nested_if_else --args 7u8

//# run 0xCAFE::NamedImports::nested_if_else --args 11u8


//# run 0xCAFE::NamedImports::create_container --args 42u64
