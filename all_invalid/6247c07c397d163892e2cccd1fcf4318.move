//# publish
module 0xCAFE::AliasTest {
    /// We test `use` declarations with alias directly here for the module below.
    struct Dummy has copy, drop, store {
        val: u64,
    }

    public fun dummy_get_val(d: &Dummy): u64 {
        d.val
    }

    /// Expose struct via alias
    /// As requested, define an alias for this struct
    /// We cannot declare alias directly here, but in other modules, we `use` it as alias.
    public fun runner(): u64 {
        let d = Dummy { val: 42 };
        dummy_get_val(&d)
    }
}
//# run 0xCAFE::AliasTest::runner

//# publish
module 0xCAFE::UnionTest {
    use 0xCAFE::AliasTest;

    /// We test union/variant types using the `|` syntax by defining a union type alias.
    /// We also test the usage of use declarations here.
    /// Note: Move currently does not have built-in support for tagged union types in the language syntax,
    /// but according to the request, we simulate the `|` union type by type aliasing or example.
    ///
    /// Move does not officially have union types/variant types but some Move versions RFC-ed it.
    /// For the test, we declare type aliases using `|` to test parser support.

    // Test union type alias with integer types
    public type IntUnion = u8 | u64;

    // Test union type alias with single module type and primitive type
    public type AddressOrU8 = address | u8;

    // An actual struct for use and alias test
    struct Dummy has copy, drop, store {
        val: u64,
    }

    public inline fun union_runner(): u64 {
        // use alias AliasTest::Dummy as DummyAlias is tested in another module
        let x: IntUnion = 123u8;
        let y: IntUnion = 456u64;
        let z: AddressOrU8 = 0xCAFE;

        // Use values to pass and return something
        let dummy = AliasTest::Dummy { val: 10 };
        dummy.val + (if x == 123u8 { 100 } else { 0 }) + (if y == 456u64 { 1000 } else { 0 }) + (if z == 0xCAFE { 10000 } else { 0 })
    }
}
//# run 0xCAFE::UnionTest::union_runner

//# run
script 0xCAFE::run_script_union_alias() {
    use 0xCAFE::UnionTest;
    use 0xCAFE::AliasTest;

    /// Directly use anonymous numeric address and alias usage in script:
    let dummy = AliasTest::Dummy { val: 7 };

    let val = UnionTest::union_runner();

    let dummy_val = AliasTest::dummy_get_val(&dummy);
    val + dummy_val;
}