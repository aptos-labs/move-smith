
//# publish
module 0xCAFE::AddAndReturn {
    // A simple function adds two u8 and returns 42u8
    public fun add_then_return_42(a: u8, b: u8): u8 {
        let _sum = a + b;
        42u8
    }

    // A function using a lambda that multiplies input by 2 and adds 10
    public fun lambda_example(x: u8): u8 {
        let double_and_add_10: |u8| u8 has copy+drop = |v: u8| {
            v * 2 + 10u8
        };
        double_and_add_10(x)
    }

    // Inline function returning a u16 value
    public inline fun inline_inc(a: u16): u16 {
        a + 1u16
    }

    // Runner function to test inline function locally
    public fun runner_inline_inc(): u16 {
        inline_inc(5u16)
    }
}



//# run 0xCAFE::AddAndReturn::add_then_return_42 --args 15u8 27u8



//# run 0xCAFE::AddAndReturn::lambda_example --args 7u8



//# run 0xCAFE::AddAndReturn::runner_inline_inc




//# publish
module 0xCAFE::CallInlineFromOther {
    use 0xCAFE::AddAndReturn;

    // Call inline_inc inside AddAndReturn module and multiply result by 2
    public fun call_inline_and_double(x: u16): u16 {
        let inced = AddAndReturn::inline_inc(x);
        inced * 2u16
    }
}



//# run 0xCAFE::CallInlineFromOther::call_inline_and_double --args 10u16




//# publish
module 0xCAFE::StructRegistry {
    use std::vector;

    struct RegisteredStruct has store, key {
        id: u64,
        name: vector<u8>,
    }

    struct Registry has store {
        names: vector<vector<u8>>,
    }

    public fun new_registry(): Registry {
        Registry {
            names: vector::empty<vector<u8>>(),
        }
    }

    // Add a name to registry if it does not already exist (avoid duplicates)
    public fun add_name_if_missing(registry: &mut Registry, name: vector<u8>) {
        let found = false;  // made mutable since we assign to it inside loop
        let len = vector::length(&registry.names);
        let i = 0;
        while (i < len) {
            if (vector::borrow(&registry.names, i) == &name) {
                found = true;
                break;
            };
            i = i + 1;
        };
        if (!found) {
            vector::push_back(&mut registry.names, name);
        };
    }

    // Runner function to test adding duplicate names
    public fun runner_add_names(): Registry {
        let reg = new_registry();
        add_name_if_missing(&mut reg, b"first");
        add_name_if_missing(&mut reg, b"second");
        add_name_if_missing(&mut reg, b"first"); // duplicate should not be added
        reg
    }
}



//# run 0xCAFE::StructRegistry::runner_add_names
