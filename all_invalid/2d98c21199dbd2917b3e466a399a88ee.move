
//# publish
module 0xCAFE::TestReturnAndDelimitedLists {
    fun test_return_skips_code(): u8 {
        let x = 0;
        if (true) {
            return 42;
            // code after return should be skipped
            // In Move, code after return in the same block is invalid, so remove the line:
            // x = 99;
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
    struct MyResource has key, store {
        value: u64,
    }

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
/*
module 0xCAFE::InvalidAccess {
    struct Dummy has key, store {
        data: u64,
    }

    fun access_resource_without_acquires() {
        let dummy = move_from<Dummy>(0xCAFE);
        // missing 'acquires Dummy' annotation, should cause compiler error
        // dummy.data;
    }
}
*/