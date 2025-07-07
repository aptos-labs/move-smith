
//# publish
module 0xCAFE::TestReturnAndDelimitedLists {
    fun test_return_skips_code(): u8 {
        let x = 0;
        if (true) {
            return 42;
            // code after return should be skipped
            x = 99;
        }
        x
    }

    fun test_delimited_lists(): vector<u8> {
        let start_token = b"<list>";
        let end_token = b"</list>";
        let result: vector<u8> = vector::empty();
        vector::append(&mut result, start_token);
        vector::append(&mut result, b"item1");
        vector::append(&mut result, b"item2");
        vector::append(&mut result, end_token);
        result
    }
}


//# run 0xCAFE::TestReturnAndDelimitedLists::test_return_skips_code

//# run 0xCAFE::TestReturnAndDelimitedLists::test_delimited_lists


//# publish
module 0xCAFE::AccessorRules {
    resource struct MyResource { value: u64 }

    public fun no_acquire_function(): u64 {
        // This function does not specify 'acquires'
        123
    }

    public fun acquire_resource(r: &MyResource): u64 {
        r.value
    }

    public fun test_resource_access() acquires MyResource {
        let res = move_to<MyResource>(0xCAFE);
        let val = acquire_resource(&res);
        move_from<MyResource>(0xCAFE);
        val
    }
}


//# run 0xCAFE::AccessorRules::no_acquire_function

//# run 0xCAFE::AccessorRules::test_resource_access --signers 0xCAFE

// Attempt to define a function that accesses a resource without the 'acquires' annotation
// Expect a compile error (not shown as a comment, but illustrating the test purpose)
// The below code should cause an error if uncommented:

/*
module 0xCAFE::InvalidAccess {
    resource struct Dummy { data: u64 }

    fun access_resource_without_acquires() {
        let dummy = move_from<Dummy>(0xCAFE);
        // missing 'acquires Dummy' annotation, should cause compiler error
        // dummy.data;
    }
}
*/

// Featurres:
// ac5b2ce1637a68d652b7a919e4be010c: Test that code after a return statement in a code block is properly skipped and does not affect the result of an expression.
// ed9c2f1bfc799d0f11d5ae37c6155865: Require specific starting and ending tokens to delimit lists.
// dc1da8d900c95d61ef4f1d8b18e8e32b: Receive compiler errors if a function accesses resources not listed in its 'acquires' annotation when inference is not available.
