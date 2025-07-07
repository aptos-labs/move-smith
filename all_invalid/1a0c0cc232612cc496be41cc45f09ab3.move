//# publish
module 0xCAFE::AbilityRestriction {
    // Test ability declarations: each struct must declare abilities only from copy, drop, store, key

    struct CorrectCopyDrop has copy, drop {
        a: u8,
    }

    struct CorrectStoreKey has store, key {
        b: u64,
    }

    struct CorrectAllAbilities has copy, drop, store, key {
        c: bool,
    }

    // Uncommenting below will cause compiler error (not valid abilities)
    // struct InvalidAbility has copy, drop, key, phantom {
    //     d: u8,
    // }

    public fun make_copy_drop(): CorrectCopyDrop {
        CorrectCopyDrop {a: 10}
    }

    public fun make_store_key(): CorrectStoreKey {
        CorrectStoreKey {b: 12345}
    }

    public fun make_all_abilities(): CorrectAllAbilities {
        CorrectAllAbilities {c: true}
    }
}

//# run 0xCAFE::AbilityRestriction::make_copy_drop

//# run 0xCAFE::AbilityRestriction::make_store_key

//# run 0xCAFE::AbilityRestriction::make_all_abilities

//# publish
module 0xCAFE::AnnotatedScriptFunction {
    use std::debug;

    #[inline]
    #[deprecated]
    public fun annotated_fun(x: u64): u64 {
        debug::print(&b"Running annotated_fun\n");
        x * 2
    }

    public fun call_annotated_fun(): u64 {
        annotated_fun(21u64)
    }
}

//# run 0xCAFE::AnnotatedScriptFunction::call_annotated_fun


//# publish
module 0xCAFE::SingletonStructs {
    // Structs with singleton (record-like) layout (no type parameters, no generics, no phantom fields)

    struct SingleField has drop, store {
        val: u8,
    }

    struct DoubleField has store {
        x: u64,
        y: bool,
    }

    struct NestedSingleton has store {
        a: SingleField,
        b: DoubleField,
    }

    public fun make_single_field(): SingleField {
        SingleField {val: 7}
    }

    public fun make_double_field(): DoubleField {
        DoubleField {x: 100, y: true}
    }

    public fun make_nested(): NestedSingleton {
        NestedSingleton {
            a: SingleField {val: 20},
            b: DoubleField {x: 3000, y: false},
        }
    }
}

//# run 0xCAFE::SingletonStructs::make_single_field

//# run 0xCAFE::SingletonStructs::make_double_field

//# run 0xCAFE::SingletonStructs::make_nested

// Featurres:
// 7c69ce06bc685b45e170e5437a346277: Restrict type ability declarations to one of the supported keywords: 'copy', 'drop', 'store', or 'key'.
// 52c9a1b5506e7c6cf267f9b531307af7: Attach attributes to your script's function definition.
// ea2e53c49b97770577bf263fb135e66e: Define structs with singleton (record-like) layouts in your modules
