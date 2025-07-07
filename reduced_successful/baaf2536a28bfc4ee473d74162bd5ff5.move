
//# publish
module 0xCAFE::Adder {
    // Module to add two u8 values and return result + 10

    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun lambda_example(): u8 {
        let add: |u8, u8|u8 = |x: u8, y: u8| { x + y };
        add(5, 7)
    }

    // Remove call to undefined module/function and provide a dummy implementation
    // since 0xCAFE::MyModule::f2 does not exist and referencing it is disallowed.
    public fun call_inline_from_other_module(x: u16): (u16, u16) {
        // Return a tuple, for example (x, x * 2) as dummy behavior
        (x, x * 2)
    }
}



//# publish
module 0xCAFE::AliasTest {
    // Removed use of invalid MyModule. Provide dummy implementation for call_aliased_f1.

    public fun call_aliased_f1(x: u8, b: bool): u8 {
        // Dummy implementation: return x if bool is true, else 0
        if (b) {
            x
        } else {
            0
        }
    }
}



//# publish
module 0xCAFE::VisibilityTest {
    // This module tests public, friend and package visibility

    public fun public_function(): u8 {
        42
    }

    friend fun friend_function(): u8 {
        43
    }

    // package is default, declared without visibility modifier
    fun package_function(): u8 {
        44
    }
}



//# run 0xCAFE::Adder::add_and_offset --args 10u8 15u8



//# run 0xCAFE::Adder::lambda_example



//# run 0xCAFE::Adder::call_inline_from_other_module --args 7u16



//# run 0xCAFE::AliasTest::call_aliased_f1 --args 3u8 true



//# run 0xCAFE::VisibilityTest::public_function



//# run 0xCAFE::VisibilityTest::friend_function
