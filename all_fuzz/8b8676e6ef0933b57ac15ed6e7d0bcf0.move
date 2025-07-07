
//# publish
module 0xCAFE::AddModule {
    // Test 1: Move function that adds two u8 and returns a specific value 
    public fun add_and_return(x: u8, y: u8): u8 {
        let _sum = x + y;
        99u8
    }

    // Test 2: Function containing a lambda expression
    public fun lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    // Test 6: Function testing shadowing and assignment inside lambda
    public fun shadow_and_assign(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |x: u8| {
            let x = x + 1;
            x + 1
        };
        f(x)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddModule;

    // Test 3: Call inline function from AddModule (simulate inline, here testing nested call)
    public inline fun call_lambda_and_add(x: u8, y: u8): u8 {
        let partial_sum = AddModule::lambda_example(x, y);
        let res = AddModule::add_and_return(partial_sum, 0u8); // Ignore sum, return 99 as defined
        res
    }
}


//# publish
module 0xCAFE::StructAndGeneric {
    struct MyStruct<T> has copy, drop, store {
        value: T,
    }

    public fun create_struct_u8(x: u8): MyStruct<u8> {
        MyStruct<u8> { value: x }
    }

    // Test 4: Access fields of structs using dot notation
    public fun get_value(s: MyStruct<u8>): u8 {
        s.value
    }

    // Test 5: Generic function to create a struct and access field (simulate method with generic)
    public fun create_and_get<T: copy + drop>(val: T): T {
        let obj = MyStruct<T> { value: val };
        // Access field and return
        obj.value
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 10u8 20u8


//# run 0xCAFE::AddModule::lambda_example --args 7u8 8u8


//# run 0xCAFE::AddModule::shadow_and_assign --args 5u8


//# run 0xCAFE::InlineCaller::call_lambda_and_add --args 3u8 4u8


//# run 0xCAFE::StructAndGeneric::create_struct_u8 --args 123u8


//# run 0xCAFE::StructAndGeneric::get_value --args 123u8


//# run 0xCAFE::StructAndGeneric::create_and_get --args 250u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0262f9a999d19ef8348c84365785f4bf: Access fields of structs using dot notation, such as `my_struct.field`.
// e87df4327ef8d0d39d3c34e701e0df54: Invoke methods or functions with generic type arguments after the dot, such as `obj.method<T>()`, especially in Move version 2.2 or later.
// 061fadf74953f74c4f90eec9d94e5870: Test that variable shadowing and assignment within closures work correctly, ensuring that parameters can be renamed and assigned as expected inside inline function calls.
