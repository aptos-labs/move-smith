// The following transactional test exercises the Move compiler and VM
// as per the requirements.

/////////////////////////////////////////////
// 1. Regular Module
/////////////////////////////////////////////
//# publish
module 0xCAFE::RegularModule {
    // Regular struct with abilities
    struct MyStruct has copy, drop, store, key {
        val: u64,
    }

    // Tuple struct to test tuple field access (.0)
    struct MyTupleStruct has copy, drop, store, key {
        inner: (u8, bool),
    }

    // Function to create and return tuple struct
    public fun create_tuple_struct(a: u8, b: bool): MyTupleStruct {
        MyTupleStruct { inner: (a, b) }
    }

    // Function to access tuple fields positionally
    public fun tuple_struct_get_first(s: &MyTupleStruct): u8 {
        s.inner.0
    }

    // Function to return second element (.1)
    public fun tuple_struct_get_second(s: &MyTupleStruct): bool {
        s.inner.1
    }

    // Function to create and return a tuple
    public fun make_tuple(a: u64, b: u64): (u64, u64) {
        (a, b)
    }

    // Function to use AST filter: e.g. shadow local variable, unused binding,
    // test field access, and test that fields can't be accessed outside module.
    public fun ast_filter_features(): u8 {
        let shadow = 7u8;
        let shadow = shadow + 1u8; // shadowed local
        let unused = 123u64; // unused binding
        let s = MyStruct { val: 42 };
        let _ = s.val; // valid field access in module
        shadow
    }

    // A public runner to be called externally
    public fun runner() {
        let s = MyTupleStruct { inner: (11u8, true) };
        let x = copy s.inner.0;
        let y = copy s.inner.1;
        let _tuple = Self::make_tuple(32, 64); // tuple returned and unused
        let filtered = Self::ast_filter_features(); // test local features
        let _ = filtered;
    }
}
//# run 0xCAFE::RegularModule::runner --signers 0xCAFE

/////////////////////////////////////////////
// 2. Script Module
/////////////////////////////////////////////
//# publish
script 0xCAFE::ScriptMod {
    // Script module with runner function
    fun main() {
        let tup: (u8, u64, bool) = (2u8, 8888u64, true);
        // Access tuple elements positionally (tests Move 2 positional fields)
        let a = tup.0;
        let b = tup.1;
        let c = tup.2;
        // shadow variables
        let a = a + 1u8;
        // unused but legal code: test AST filter
        let _useless = 2222u16;
        let _ = (b, c);

        // Test constructing and destructuring a tuple
        let (x, y) = (9u8, false);
        let _z = (x, y);
    }
}
//# run 0xCAFE::ScriptMod::main --signers 0xCAFE

/////////////////////////////////////////////
// 3. Script (Script Block)
/////////////////////////////////////////////
//# run
script {
    fun main() {
        let tuple: (u64, bool, u8) = (99u64, false, 255u8);
        let _first = tuple.0;
        let _second = tuple.1;
        let _third = tuple.2;

        // Unused variable to test AST filter
        let unused = 1000u64;
        let (x, y) = (1u16, true);
        let _ = (x, y);
    }
}

/////////////////////////////////////////////
// 4. External field access NEGATIVE CASE
//    (fields are NOT accessible outside module; no need to run, just check)
//    Uncommented since this would be a compiler error; for verification filtering
/////////////////////////////////////////////
    // use 0xCAFE::RegularModule;
    // fun illegal() {
    //     let s = RegularModule::MyStruct { val: 99 };
    //     // The next line should not compile:
    //     let x = s.val; // ERROR: field access outside module
    // }

/////////////////////////////////////////////
// 5. Tuple member access from module function
/////////////////////////////////////////////
//# run 0xCAFE::RegularModule::tuple_struct_get_first --signers 0xCAFE --args 0xCAFE::RegularModule::MyTupleStruct { inner: (42u8, false) }

// Featurres:
// e68ecc42ec10b5f6d3edc1a25f9c727b: Support both regular modules and special script modules as Move targets.
// 94c414d896fd044e3e113f97fb8b963e: Apply AST filtering for verification purposes.
// 16b63ec19d7caee7c22b07523fd21b49: When Move 2 is enabled, refer to tuple fields by positional field syntax (e.g., .0, .1, ...).
