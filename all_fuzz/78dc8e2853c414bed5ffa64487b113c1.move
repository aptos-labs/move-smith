
//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::LambdaModule {
    use std::signer;

    struct Container has store {
        value: u8,
    }

    enum Status has copy, drop {
        Idle,
        Busy(u8),
        Done { success: bool }
    }

    public fun add_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun run_lambda_with_capture(x: u8): u8 {
        let captured = 5u8;
        let lambda: |u8| u8 has copy + drop = |y: u8| {
            y + captured
        };
        lambda(x)
    }

    public fun call_inline_and_lambda(x: u8): u8 {
        let inline_result = 0xCAFE::InlineModule::inline_add(x, 2u8);
        let lambda: |u8| u8 has copy + drop = |z: u8| {
            z * 2u8
        };
        lambda(inline_result)
    }

    public fun create_status_busy(level: u8): Status {
        Status::Busy(level)
    }

    public fun create_container(value: u8): Container {
        Container { value }
    }

    public fun process_address(s: signer): address {
        signer::address_of(&s)
    }
}


//# publish
module 0xCAFE::ImportUseModule {
    use std::vector;
    use 0xCAFE::LambdaModule;

    public fun call_imported_add_funcs(x: u8, y: u8): u8 {
        let sum = LambdaModule::add_values(x, y);
        sum
    }

    public fun use_vector_append(): vector<u8> {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 1u8);
        vector::push_back(&mut v, 2u8);
        vector::push_back(&mut v, 3u8);
        v
    }
}



//# run 0xCAFE::LambdaModule::add_values --args 10u8 15u8



//# run 0xCAFE::LambdaModule::run_lambda_with_capture --args 7u8



//# run 0xCAFE::LambdaModule::call_inline_and_lambda --args 3u8



//# run 0xCAFE::LambdaModule::create_status_busy --args 99u8



//# run 0xCAFE::LambdaModule::create_container --args 42u8



//# run 0xCAFE::LambdaModule::process_address --signers 0xDEAD



//# run 0xCAFE::ImportUseModule::call_imported_add_funcs --args 11u8 29u8



//# run 0xCAFE::ImportUseModule::use_vector_append
