
//# publish
module 0xCAFE::TestModule1 {
    use std::vector;

    // Test 1: simple add function returning u8
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        let final_value = sum + 5;
        final_value
    }

    // Test 2: function containing lambda
    public fun lambda_usage(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b + 1
        };
        lambda(x, y)
    }

    // Test 3: inline function
    public inline fun inline_inc(x: u16): u16 {
        x + 1
    }

    // Test 4: recognize pipe type - union/variant type
    // We'll define a variant enum with some variants, including a type with a pipe in the name (simulate)
    enum U has copy, drop {
        A,
        B(u8),
        C { d: u16 }
    }

    // Test 5: function test creating a vector initialized with initial value of p
    public fun test(p: u8): vector<u8> {
        let vec = vector::empty<u8>();
        vector::push_back(&mut vec, p);
        vector::push_back(&mut vec, p + 1);
        vector::push_back(&mut vec, p + 2);
        vector::push_back(&mut vec, p + 3);
        vec
    }

    // Test 6: function to return full name with address of this function (mock)
    public fun get_full_name_with_address(): (address, vector<u8>) {
        // returns address and bytes of full func name string
        let addr = @0xCAFE;
        // full name including module and function name as bytes vector
        // "0xCAFE::TestModule1::get_full_name_with_address"
        let name_bytes: vector<u8> = b"0xCAFE::TestModule1::get_full_name_with_address";
        (addr, name_bytes)
    }
}



//# run 0xCAFE::TestModule1::add_and_return --args 10u8 20u8



//# run 0xCAFE::TestModule1::lambda_usage --args 4u8 5u8



//# publish
module 0xCAFE::TestModule2 {
    use std::vector;
    use 0xCAFE::TestModule1;

    // Calls inline function in TestModule1 and nests another call
    public fun nested_inline_calls(x: u16): u16 {
        let inc1 = TestModule1::inline_inc(x);
        let inc2 = TestModule1::inline_inc(inc1);
        inc2
    }

    // Calls test function from TestModule1 to get a vector<u8>
    public fun vector_from_test(p: u8): vector<u8> {
        let v = TestModule1::test(p);
        v
    }
}



//# run 0xCAFE::TestModule2::nested_inline_calls --args 10u16



//# run 0xCAFE::TestModule2::vector_from_test --args 7u8



//# run 0xCAFE::TestModule1::get_full_name_with_address
