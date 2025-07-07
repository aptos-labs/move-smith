// This transactional test will:
/*
  - Use named addresses for module definitions.
  - Add axioms in spec blocks.
  - Define and use unit types.
*/

//# publish
module 0xCAFE::UnitAndSpecTest {
    // Define a unit type (a struct with no fields)
    struct Unit has copy, drop, store {}

    /// Returns the unit value
    public fun unit_value(): Unit {
        Unit {}
    }

    /// Runner function with no arguments
    public fun runner() {
        // Just create a unit value and discard it
        let _ = unit_value();
    }

    spec module {
        // An axiom stating that any unit value equals any other unit value
        axiom (∀ u1: Unit, u2: Unit :: u1 == u2);

        // To enable == on Unit, define an equality function in the implementation (see below)
    }

    /// Equality function needed for axiom (== operator is not auto-defined for structs)
    public fun equals(u1: &Unit, u2: &Unit): bool {
        // Since Unit has no data, all values are equal
        true
    }
}
//# run 0xCAFE::UnitAndSpecTest::runner --signers 0xCAFE

//# publish
module 0xCAFE::NamedAddressExample {
    // Use the named address 0xCAFE in a constant
    const ADDRESS: address = @0xCAFE;

    // A simple resource stored under 0xCAFE
    struct Foo has key {
        val: u64,
    }

    public fun init_foo(account: &signer) {
        move_to(account, Foo { val: 42 });
    }

    public fun get_foo_val(addr: address): u64 acquires Foo {
        borrow_global<Foo>(addr).val
    }

    public fun runner(account: &signer) {
        init_foo(account);
        let _v = get_foo_val(@0xCAFE);
    }

    spec module {
        // An axiom: Foo.val is always 42 when initialized by init_foo
        axiom (forall addr: address :: 
            (exists f: Foo :: f == borrow_global<Foo>(addr)) ==>
            borrow_global<Foo>(addr).val == 42
        );
    }
}
//# run 0xCAFE::NamedAddressExample::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::UnitAndSpecTest;
    use 0xCAFE::NamedAddressExample;

    fun main(account: signer) {
        // Call runner in UnitAndSpecTest
        UnitAndSpecTest::runner();

        // Call runner in NamedAddressExample
        NamedAddressExample::runner(&account);
    }
}

// Featurres:
// 1e5d2305b264af31c3fdc80e4a2bc9cc: Use named addresses for module definitions.
// 49b4b441ae2849b6cc3fddf30f4eaf8c: Add axioms to your specification by using the 'axiom' keyword in a spec block.
// 8b2da29ddbd44b55bcd2b34821c4d190: Define unit types in Move code.
