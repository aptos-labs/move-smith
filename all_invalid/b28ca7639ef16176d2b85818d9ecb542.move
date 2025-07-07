address 0x1 {
module Test {

    use std::string;
    use std::option;
    use std::vector;
    use aptos_framework::module;

    // Struct to test field extraction and construction
    struct Fields has copy, drop, store {
        a: u64,
        b: bool,
        c: vector<u8>,
    }

    /// Helper function:
    /// Given an address and a module name, returns a ModuleId
    public fun construct_module_id(addr: address, name: vector<u8>): module::ModuleId {
        module::ModuleId { address: addr, name }
    }

    /// Given a Fields struct, unwrap fields and reconstruct a new Fields struct
    public fun reconstruct_fields(f: Fields): Fields {
        let a_val = f.a;
        let b_val = f.b;
        let c_val = f.c;
        // Create a new Fields struct with the same values
        Fields { a: a_val, b: b_val, c: c_val }
    }

    /// Function currying example
    /// Returns a function that takes a bool, and returns another function that takes u64
    /// Depending on the bool, pick different closures
    public fun curried_fn(flag: bool): (u64) -> u64 {
        if (flag) {
            // Closure 1: add 1
            move |x: u64| { x + 1 }
        } else {
            // Closure 2: multiply by 2
            move |x: u64| { x * 2 }
        }
    }

    #[test_only]
    public fun transactional_test() {
        // 1. Test ModuleId construction from address and module name

        let test_addr: address = @0x42;
        let mod_name = string::utf8(b"MyTestModule");
        let mod_id = construct_module_id(test_addr, mod_name);
        // Assert the constructed ModuleId has correct address and name
        assert!(mod_id.address == test_addr, 100);
        assert!(mod_id.name == string::utf8(b"MyTestModule"), 101);

        // 2. Test reconstruct_fields after unwrapping fields
        let original_fields = Fields {
            a: 42,
            b: true,
            c: string::utf8(b"field_c"),
        };
        let rebuilt_fields = reconstruct_fields(original_fields);
        assert!(rebuilt_fields.a == 42, 102);
        assert!(rebuilt_fields.b == true, 103);
        assert!(rebuilt_fields.c == string::utf8(b"field_c"), 104);

        // 3. Test function currying and conditional logic through closures
        let fn_add_one = curried_fn(true);
        let fn_mul_two = curried_fn(false);

        let res1 = fn_add_one(10);
        let res2 = fn_mul_two(10);

        assert!(res1 == 11, 105); // 10 + 1 = 11
        assert!(res2 == 20, 106); // 10 * 2 = 20
    }
}
}

// Featurres:
// fd2135fdcbbf39fffb9dd8b6f884ac82: Extract the address and name from a module identifier to construct a ModuleId within the Move module system.
// e1edb0b78d698d134e8bac8aefa5afdb: Construct and return a new fields structure from assignable values after unwrapping pattern fields.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
