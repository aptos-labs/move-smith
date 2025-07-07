
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        42u8
    }

    public fun with_lambda_example(x: u8, y: u8): (u8, u8) {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let mul_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        (add_lambda(x, y), mul_lambda(x, y))
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun call_inline_increment_twice(a: u8): u8 {
        let b = inline_increment(a);
        inline_increment(b)
    }
}


//# publish
module 0xCAFE::FriendModule {
    friend 0xCAFE::AddModule;

    public fun access_add_module_inline(a: u8): u8 {
        0xCAFE::AddModule::inline_increment(a)
    }
}


//# publish
module 0xCAFE::ApplyModule {
    public fun apply(f: |u8, u8| u8, a: u8, b: u8): u8 {
        f(a, b)
    }

    public fun nested_application(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };
        let res1 = apply(add, x, y);
        let res2 = apply(mul, x, y);
        res1 + res2
    }
}

//// The following module attempts to import non-existent members to test errors:
//// This is intended to receive errors on compile/import.


//# publish
module 0xCAFE::NonExistentImport {
    use 0xCAFE::NoModule; // error: module does not exist
    use 0xCAFE::AddModule::{no_function}; // error: member does not exist
}
 

//# run 0xCAFE::AddModule::add_and_return_fixed --args 7u8 8u8


//# run 0xCAFE::AddModule::with_lambda_example --args 5u8 6u8


//# run 0xCAFE::AddModule::call_inline_increment_twice --args 10u8


//# run 0xCAFE::FriendModule::access_add_module_inline --args 15u8


//# run 0xCAFE::ApplyModule::apply --args 7u8 8u8

//# run 0xCAFE::ApplyModule::nested_application --args 4u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// cbd14c6ce574279b30fa3a898b01f9e0: Use `Friend` relationships to declare friend modules for controlled module access.
// 435fb7fba4dab8a288cac18225732b04: Test that the `apply` function correctly executes a provided binary function on given inputs and returns the combined result, demonstrating nested function applications.
// 8a52e53179eaf73ebe0e390d10c6133d: Receive errors if you attempt to import a non-existent module or a non-existent member in a 'use' statement.
