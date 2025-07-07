//# publish
module 0xCAFE::AbilitiesAndAssignment {
    // A struct with abilities Copy, Drop, Store
    struct S1 has copy, drop, store {
        x: u64,
        y: u64,
    }

    // A key struct with Drop and Store
    struct S2 has key, drop, store {
        id: u64,
    }

    // A struct with no abilities (default)
    struct S3 {
        flag: bool,
    }

    // A resource struct with key and store abilities
    resource struct AccountData has key, store {
        owner: address,
        value: u64,
        nested: S1,
    }

    // Function testing assignment expressions, including to struct fields, resource fields
    public fun assignment_test(account: &signer) {
        let mut a = 10u64;
        let mut b = 20u64;
        a = b;    // simple assignment a = b
        b = 30;

        // Create S1 struct and assign fields
        let mut s = S1 { x: a, y: b };
        s.x = s.y; // s.x = s.y

        // Create S3 struct and assign to field
        let mut s3 = S3 { flag: true };
        s3.flag = false;

        // Publish resource to account
        move_to(account, AccountData {
            owner: signer::address_of(account),
            value: 1000,
            nested: s,
        });

        // Borrow resource and mutate nested.x = value
        let r = borrow_global_mut<AccountData>(signer::address_of(account));
        r.value = r.nested.x;  // r.value = r.nested.x

        // Change nested.x and nested.y using assignment expressions
        r.nested.x = r.value;
        r.nested.y = 500;
    }
}
//# run 0xCAFE::AbilitiesAndAssignment::assignment_test --signers 0xCAFE

//# publish
module 0xCAFE::NameResolution {
    // A copyable struct to be used for variant demonstration
    struct MyEnum has copy, drop, store {
        value: u8,
    }

    // An enum-like struct with variants simulated by structs (Move doesn't have native enum yet)
    struct E has copy, drop, store {
        tag: u8,
        data: u64,
    }

    // Nested module name resolution example using fully qualified names
    public fun module_level_resolution() : u64 {
        // create a struct fully qualified
        let s = 0xCAFE::AbilitiesAndAssignment::S1 { x: 1, y: 2 };
        s.x + s.y
    }

    public fun type_level_resolution(): u8 {
        let e = MyEnum { value: 123 };
        e.value
    }

    public fun variant_level_resolution(): u64 {
        // simulate variant by accessing tag and data explicitly
        let e = E { tag: 1, data: 999 };
        if (e.tag == 1) { e.data } else { 0 }
    }

    // Runner to call above three
    public fun runner(): u64 {
        let sum = module_level_resolution();
        let v = type_level_resolution();
        let vv = variant_level_resolution();
        sum + (v as u64) + vv
    }
}
//# run 0xCAFE::NameResolution::runner

//# run
script {
    use 0xCAFE::AbilitiesAndAssignment;
    use 0xCAFE::NameResolution;

    fun main(account: signer) {
        AbilitiesAndAssignment::assignment_test(&account);
        let _ = NameResolution::runner();
    }
}

// Featurres:
// c2690b9c0a9fa1771bbd371be5f3e8e0: Create assignment expressions with left-value and right-value.
// e50f7ebef96acd475a77c80dd2e3b935: Annotate structs or resources with abilities such as Copy, Drop, Store, or Key using 'has' modifiers.
// f1c921aca42f3b921cebd45f3d43cf5e: Use specific syntax to distinguish between various levels of name resolution in module, type, and variant access.
