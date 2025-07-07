
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

    public fun call_inline_from_other_module(x: u16): (u16, u16) {
        // Call f2 from MyModule
        0xCAFE::MyModule::f2(x)
    }
}


//# publish
module 0xCAFE::AliasTest {
    // Rename imported module MyModule to MM and use an aliased function

    use 0xCAFE::MyModule as MM;

    public fun call_aliased_f1(x: u8, b: bool): u8 {
        MM::f1(x, b)
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


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// eceb808e13346e13246ad6072fc7a2ed: Rename imported modules or members using an alias in the 'use' statement.
// f3548b79e73653c5b121e1a813240c85: Annotate module members with the visibility modifiers: public, friend, or package.
