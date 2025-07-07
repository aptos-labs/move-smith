//# publish
module 0xA550C18::TestModule {
    use std::signer;

    #[skip(redundant_field_names, unused_variable)]
    struct R has key {
        v: u64,
    }

    // Initialize the resource R with a value
    public fun initialize(account: &signer, val: u64) {
        move_to(account, R { v: val });
    }

    // A function that reads and modifies R depending on its v value
    public fun do(account: &signer) {
        let r = borrow_global_mut<R>(signer::address_of(account));
        if (r.v == 0) {
            // unpacking syntax for struct fields
            let R { v: old_v } = *r;
            r.v = old_v + 10;
        } else {
            r.v = r.v * 2;
        };
    }

    // Helper function that demonstrates variable bindings in lambda and blocks
    public fun lambda_and_block() {
        let vec = vector::empty<u64>();
        // immutable binding
        let add_one = |x: u64| { x + 1 };

        // mutable binding inside block
        {
            let mut temp = 5u64;
            temp = add_one(temp);
            vector::push_back(&mut vec, temp);
        }

        // Another block with immutable bindings
        {
            let y = 3u64;
            let z = add_one(y);
            vector::push_back(&mut vec, z);
        }
    }

    // Runner function to execute all relevant code
    public fun runner(account: &signer) {
        initialize(account, 0);
        do(account);
        lambda_and_block();
    }
}
//# run 0xA550C18::TestModule::runner --signers 0xA550C18


//# publish
module 0xBEEF::DependencyModule {
    #[skip(unused_variable)]
    struct DepStruct {
        a: u8,
        b: u64,
    }

    public fun create_dep_struct(): DepStruct {
        // unpacking with braces, tuple-like struct accessing fields
        let s = DepStruct { a: 1, b: 2 };
        let DepStruct { a, b } = s;
        a;
        b;
        s
    }
}
//# run 0xBEEF::DependencyModule::create_dep_struct

//# run
script {
    use 0xA550C18::TestModule;
    use 0xBEEF::DependencyModule;

    fun main(account: signer) {
        // Publish is covered by module above. Here we just run the runner.
        TestModule::runner(&account);

        // Using the dependency module function
        let dep = DependencyModule::create_dep_struct();

        // Verify "do" with v != 0:
        // Initialize R with v = 5 and call do again
        TestModule::initialize(&account, 5);
        TestModule::do(&account);
    }
}