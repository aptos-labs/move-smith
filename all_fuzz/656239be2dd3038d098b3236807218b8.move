
//# publish
module 0xCAFE::MyModule {
    // Add a public function f1 to fix the missing function error
    public fun f1(x: u8, flag: bool): u8 {
        // example implementation: if flag is true, return x + 1, else x
        if (flag) {
            x + 1
        } else {
            x
        }
    }
}

//# publish
module 0xCAFE::NestedModule {
    // A inline function that adds two u8 numbers and returns u8
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun with_lambda(x: u8): u8 {
        // Lambda to multiply by two
        let multiply_by_two = |v: u8| { v * 2 };
        multiply_by_two(x)
    }

    // Function that wraps inline add call from itself and from MyModule
    public fun nested_calls(x: u8, y: u8): u8 {
        let sum1 = add_u8(x, y);
        let sum2 = 0xCAFE::MyModule::f1(sum1, true);
        sum2
    }

    // Function creating a variable from parsing name, just simulate by naming
    public fun parse_var_simulation(): u8 {
        let parsed_var = 42u8;
        parsed_var
    }

    // version = 1]
    // id = 0xCAFE::NestedModule]
    public fun annotated_function(): u8 {
        5u8
    }
}



//# run 0xCAFE::NestedModule::with_lambda --args 10u8



//# run 0xCAFE::NestedModule::nested_calls --args 4u8 5u8



//# run 0xCAFE::NestedModule::parse_var_simulation



//# run 0xCAFE::NestedModule::annotated_function
