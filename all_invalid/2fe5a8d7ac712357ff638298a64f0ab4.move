
//# publish
module 0xCAFE::TestModule {
    public inline fun inline_add(x: u64, y: u64): u64 {
        x + y
    }

    public fun call_inline_add(): u64 {
        let result = inline_add(10, 20);
        result
    }

    public fun test_chain_access() {
        let vector = vector[1u8, 2u8, 3u8];
        let first_elem = vector[0];
        let second_elem = vector[1];

        let struct_instance = {
            f1: 42u64,
            f2: vector
        };

        let field_value = struct_instance.f1;
        let vector_field = struct_instance.f2;
        let second_vector_elem = vector_field[1];

        // Chain access: struct_instance.f2[1]
        let chain_result = vector_field[1];
        // This function is just to exercise chain field and index access.
        // No assertion needed.
        ()
    }

    public fun get_address(): address {
        @0xCAFE
    }
}



//# run 0xCAFE::TestModule::call_inline_add --signers 0xCAFE


//# run 0xCAFE::TestModule::test_chain_access --signers 0xCAFE


//# run 0xCAFE::TestModule::get_address