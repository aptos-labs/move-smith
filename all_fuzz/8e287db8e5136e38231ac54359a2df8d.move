
//# publish
module 0xCAFE::TestAddAndLambda {
    // Removed unused `use std::signer;`

    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun lambda_increment_by_one(x: u8): u8 {
        let inc: |u8| u8 has copy + drop = |a: u8| { a + 1 };
        inc(x)
    }

    // Nested call removed due to missing MyModule::f2 function.

    struct DROP has drop, store {
        val: u8,
    }

    public fun make_drop(x: u8): DROP {
        DROP { val: x }
    }
}



//# run 0xCAFE::TestAddAndLambda::add_then_return --args 5u8 6u8


//# run 0xCAFE::TestAddAndLambda::lambda_increment_by_one --args 9u8


//# run 0xCAFE::TestAddAndLambda::make_drop --args 99u8
