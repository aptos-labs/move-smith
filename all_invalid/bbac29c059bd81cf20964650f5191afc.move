//# publish
module 0xCAFE::MutabilityTest {
    // A simple struct to demonstrate field access and mutation
    struct Data has key {
        value: u64,
        flag: bool,
    }

    // A helper function to create a new Data
    public fun make_data(init_value: u64): Data {
        Data {
            value: init_value,
            flag: false,
        }
    }
    
    // A function to mutate the fields of Data
    public fun mutate_data(d: &mut Data) {
        d.value = d.value + 10;
        d.flag = true;
    }

    // Function that takes a global resource to mutate
    resource struct GlobalResource has key {
        count: u64,
    }

    // Initialize the global resource
    public fun init_global_resource(owner: &signer) {
        move_to<GlobalResource>(owner, GlobalResource { count: 0 });
    }

    // Mutate the global resource
    public fun mutate_global_resource() {
        let g = borrow_global_mut<GlobalResource>(@0xCAFE);
        g.count = g.count + 1;
    }
}

#[//# run 0xCAFE::MutabilityTest::make_data --signers 0xCAFE]
fun run_make_data() {
    let data = 0xCAFE::MutabilityTest::make_data(42);
    // No assertions; testing compilation and runtime
}

#[//# run 0xCAFE::MutabilityTest::mutate_data --signers 0xCAFE]
fun run_mutate_data() {
    // Create a resource to hold Data
    let data = 0xCAFE::MutabilityTest::make_data(100);
    // Mutate via reference
    0xCAFE::MutabilityTest::mutate_data(&mut data);
    // Access fields to verify (though assertions are ignored)
}

#[//# run 0xCAFE::MutabilityTest::init_global_resource --signers 0xCAFE]
fun run_init_global() {
    0xCAFE::MutabilityTest::init_global_resource(&signer);
}

#[//# run 0xCAFE::MutabilityTest::mutate_global_resource --signers 0xCAFE]
fun run_mutate_global() {
    0xCAFE::MutabilityTest::mutate_global_resource();
}

// Featurres:
// 5857892d922f0a971e9fae8e65751c3e: Mutate variables via expressions such as assignment, Move, or mutable Borrow, and have these operations treated as modifications by the compiler.
// 56e58f9f7702e43904de062182125520: Refer to field or module items by name, possibly with type arguments.
// 2dd7578d325883fa41ddc631335c1f43: Expand macro or syntactic sugar constructs during compilation.
