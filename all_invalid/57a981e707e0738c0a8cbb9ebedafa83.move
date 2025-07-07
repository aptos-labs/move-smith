
//# publish
module 0xCAFE::AddModule {
    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
        // Need to explicitly return the value, not just a semi-colon block
    }
}



//# publish
module 0xCAFE::UseInlineModule {
    use 0xCAFE::AddModule;

    public inline fun inline_wrapper(x: u8, y: u8): u8 {
        AddModule::add_two(x, y) + 5
    }
}



//# publish
module 0xCAFE::NestedResourceManager {
    use std::signer;

    struct Resource has key, store {
        val: u8
    }

    public fun create_resource(s: signer, val: u8) {
        let res = Resource { val };
        move_to<Resource>(&s, res);
    }

    public fun update_resource(s: signer, val: u8) {
        let res_ref = borrow_global_mut<Resource>(signer::address_of(&s));
        res_ref.val = val;
    }

    public fun nested_work(s: signer, val1: u8, val2: u8) {
        // Create or update resource in this module
        if (exists<Resource>(signer::address_of(&s))) {
            Self::update_resource(s, val1);
        } else {
            Self::create_resource(s, val1);
        };

        // The originally failing code calls AddModule::f1 which doesn't exist.
        // Instead, call AddModule::add_two as a representative external call.
        let _ = 0xCAFE::AddModule::add_two(1u8, 9u8);
        // We just invoke an unrelated function to test nested call without conflicts
    }

    public fun read_resource_val(s: signer): u8 {
        let res_ref = borrow_global<Resource>(signer::address_of(&s));
        res_ref.val
    }
}



//# publish
module 0xCAFE::VarNameCheck {
    struct Data has store {
        _underscore: u8,
        lowercase: u16,
        UppercaseStart: u32,
    }

    public fun make_data(): Data {
        Data {
            _underscore: 5,
            lowercase: 10,
            UppercaseStart: 15,
        }
    }

    public fun get_sum(): u32 {
        let d = make_data();
        // Data does not have the drop ability, so we must consume d to avoid implicit drop
        let Data { _underscore, lowercase, UppercaseStart } = d;
        (_underscore as u32) + (lowercase as u32) + UppercaseStart
    }
}



//# run 0xCAFE::AddModule::add_two --args 5u8 6u8



//# run 0xCAFE::AddModule::add_two --args 3u8 4u8



//# run 0xCAFE::UseInlineModule::inline_wrapper --args 3u8 4u8



//# run 0xCAFE::NestedResourceManager::nested_work --signers 0xBEEF --args 7u8 8u8



//# run 0xCAFE::NestedResourceManager::read_resource_val --signers 0xBEEF



//# run 0xCAFE::VarNameCheck::get_sum
