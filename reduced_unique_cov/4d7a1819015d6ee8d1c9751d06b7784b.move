
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let c = a + b;
        let d = c + 10u8;
        d
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 5u8 7u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add(a: u8, b: u8): u8 {
        AddModule::add_two_values(a, b)
    }
}


//# run 0xCAFE::CallerModule::call_add --args 2u8 3u8


//# publish
module 0xCAFE::ResourceTest {
    use std::signer;

    struct Counter has store, key {
        val: u64,
    }

    struct ResourceStruct has store, key {
        a: u8,
        b: u8,
    }

    public fun create_counter(s: signer) {
        let counter = Counter { val: 0 };
        move_to<Counter>(&s, counter);
    }

    public fun increment_counter(s: signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        counter_ref.val = counter_ref.val + 1;
    }

    public fun create_resource(s: signer, a: u8, b: u8) {
        let resource = ResourceStruct {a, b};
        move_to<ResourceStruct>(&s, resource);
        increment_counter(s);
    }

    public fun deconstruct_and_sum(s: signer): u8 {
        let resource = move_from<ResourceStruct>(signer::address_of(&s));
        let ResourceStruct {a, b} = resource;
        let counter_ref: &Counter = borrow_global<Counter>(signer::address_of(&s));
        a + b + (counter_ref.val as u8)
    }
}


//# run 0xCAFE::ResourceTest::create_counter --signers 0xD00D


//# run 0xCAFE::ResourceTest::create_resource --signers 0xD00D --args 3u8 4u8


//# run 0xCAFE::ResourceTest::deconstruct_and_sum --signers 0xD00D


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3b72fcb1a0591877b61b0a4829616ac8: Test that creating and deconstructing a resource struct with mutable fields correctly increments a shared value and computes the sum of its fields.
// 1df11cc43eeec814df9873a5318f87a8: Ensure modules pass the bytecode verifier before publishing or executing.
