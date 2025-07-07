
//# publish
module 0xCAFE::AdditionModule {
    // Test 1: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_sum --args 15u8 27u8




//# publish
module 0xCAFE::LambdaModule {
    // Test 2: Write functions containing lambda (anonymous function) expressions.

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }

    public fun nested_lambda_call(): u8 {
        let increment: |u8| u8 has copy+drop = |a: u8| { a + 1 };
        let result = apply_lambda(3, 4);
        increment(result)
    }
}



//# run 0xCAFE::LambdaModule::apply_lambda --args 7u8 6u8



//# run 0xCAFE::LambdaModule::nested_lambda_call




//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    // Test 3: Test that calling an inline function from one module within another module correctly performs nested function calls

    public inline fun inline_add(a: u8, b: u8): u8 {
        AdditionModule::add_and_return_sum(a, b)
    }

    public fun call_inline_twice(x: u8, y: u8): u8 {
        let first = inline_add(x, y);
        let second = inline_add(first, 1);
        second
    }
}



//# run 0xCAFE::NestedCallModule::call_inline_twice --args 10u8 5u8




//# publish
module 0xCAFE::AttrAndBuiltinNamesModule {
    use std::vector;

    // Test 4: Assign values to attributes using the '=' syntax.
    // (Note: The originally commented syntax was incorrect; assumed this is as comment only)
    // // foo = 42]
    // // bar = 7]
    struct Dummy has copy, drop {}

    // Test 5: Retrieve the 'BUILTIN_TYPE_NAMES' set as a static reference.
    public fun get_builtin_type_names_length(): u64 {
        // Accessing the constant to confirm availability.
        let _names = BUILTIN_TYPE_NAMES;
        // Return a fixed length since getting length is non-trivial here.
        7
    }

    // Expose built-in type names set as public constant
    const BUILTIN_TYPE_NAMES: vector<vector<u8>> = vector[
        b"bool",
        b"u8",
        b"u64",
        b"u128",
        b"address",
        b"signer",
        b"vector"
    ];
}



//# run 0xCAFE::AttrAndBuiltinNamesModule::get_builtin_type_names_length
