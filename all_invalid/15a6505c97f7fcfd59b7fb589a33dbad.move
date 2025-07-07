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
    /// Note: The `type` alias and union `|` are not yet supported in Move.
    /// This code is adapted to remove unsupported syntax.

    /// Instead of real union types, we just demonstrate using multiple variables with different types.
    
    struct Dummy has copy, drop, store {
        val: u64,
    }

    public inline fun union_runner(): u64 {
        let x: u8 = 123u8;
        let y: u64 = 456u64;
        let z: address = 0xCAFE;

        // Use values to pass and return something
        let dummy = AliasTest::Dummy { val: 10 };

        dummy.val + (if x == 123u8 { 100 } else { 0 }) 
        + (if y == 456u64 { 1000 } else { 0 }) 
        + (if z == 0xCAFE { 10000 } else { 0 })
    }
}
//# run 0xCAFE::UnionTest::union_runner

//# run
script {
    use 0xCAFE::UnionTest;
    use 0xCAFE::AliasTest;

    /// Directly use anonymous numeric address and alias usage in script:
    let dummy = AliasTest::Dummy { val: 7 };

    let val = UnionTest::union_runner();

    let dummy_val = AliasTest::dummy_get_val(&dummy);
    val + dummy_val;
}