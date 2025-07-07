// This test exercises variable shadowing inside closures passed to inline functions,
// getting module ids from module handles (address + name), and type annotations on spec variables.

//# publish
module 0xCAFE::ShadowTest {
    use std::signer;
    use std::string;
    use std::vector;

    public inline fun apply_to<F: copy + drop>(x: &mut u64, f: &F) {
        // call the closure f to update x
        f(x);
    }

    public inline fun test_shadowing() {
        let mut x = 42u64;

        // define a closure that shadows x but updates outer x
        let f = &|y: &mut u64| {
            // shadow x: inner x shadows outer
            let mut x = 100u64;

            // increment the outer x by y's value
            *y = *y + x; // Should update the outer x, not the inner x
        };

        apply_to(&mut x, f);

        // now x should be 142 (42 + 100)
    }

    // Construct a ModuleId from an address and a string name
    // Here we test extracting address, name from a single module identifier
    // by breaking things apart into components manually.

    use std::module;

    public fun get_module_id(): module::ModuleId acquires ModuleId {
        let addr = @0xCAFE;
        let name_vec: vector<u8> = b"ShadowTest";

        module::ModuleId { address: addr, name: name_vec }
    }

    // Runner function to exercise get_module_id()
    public fun runner() {
        let module_id = get_module_id();
    }
}
//# run 0xCAFE::ShadowTest::test_shadowing
//# run 0xCAFE::ShadowTest::runner

//# publish
module 0xCAFE::SpecVarType {
    use std::spec;

    // Define a resource to test spec variables with type annotations

    resource struct Counter has copy, drop, store, key {
        value: u64
    }

    // Initialize counter
    public fun init(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    // Increment the counter
    public fun inc(account: &signer) acquires Counter {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        counter.value = counter.value + 1;
    }

    // Spec function with an explicitly typed spec variable (counter_value: u64)
    spec fun counter_value(addr: address): u64 {
        let counter_value: u64 = if spec::global_exists<Counter>(addr) {
            spec::borrow_global<Counter>(addr).value
        } else {
            0
        };
        counter_value
    }

    // Runner function to test init and inc with spec calls (in comment)
    public fun runner(account: &signer) acquires Counter {
        init(account);
        inc(account);
        inc(account);
    }
}
//# run 0xCAFE::SpecVarType::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::ShadowTest;
    use 0xCAFE::SpecVarType;
    use std::signer;

    fun main(account: signer) {
        ShadowTest::test_shadowing();
        ShadowTest::runner();
        SpecVarType::runner(&account);
    }
}

// Featurres:
// 74ac9c50dd657ff88b2f637c4d0aedf9: Test that the Move compiler correctly implements variable renaming (shadowing) within closures passed to inline functions, ensuring that assignments inside closures to outer variables actually update the intended variable.
// fd2135fdcbbf39fffb9dd8b6f884ac82: Extract the address and name from a module identifier to construct a ModuleId within the Move module system.
// 7f194944ff993f9e657b4781aa70c7c3: Specify the type of a spec variable after a colon.
