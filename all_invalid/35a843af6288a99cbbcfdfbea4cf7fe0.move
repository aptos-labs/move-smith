//# publish
module 0x1::RangeList {
    use std::vector;
    use std::option;
    use std::string;

    /// A structure representing a location in source code
    struct Location has copy, drop, store {
        file: vector<u8>,
        line: u64,
        column: u64,
    }

    /// Represents a binding with an associated range
    struct Range has copy, drop, store {
        start: u64,
        end: u64,
    }

    /// A tuple of binding name, range and location info
    struct BindingRange has copy, drop, store {
        name: vector<u8>,
        range: Range,
        location: Location,
    }

    /// A list of bindings with ranges and location info
    struct RangeList has copy, drop, store {
        list: vector<BindingRange>,
    }

    public fun new_location(file: vector<u8>, line: u64, column: u64): Location {
        Location { file, line, column }
    }

    public fun new_range(start: u64, end: u64): Range {
        Range { start, end }
    }

    public fun new_binding_range(name: vector<u8>, range: Range, location: Location): BindingRange {
        BindingRange { name, range, location }
    }

    public fun new_range_list(): RangeList {
        RangeList { list: vector::empty() }
    }

    public fun add_binding_range(rl: &mut RangeList, br: BindingRange) {
        vector::push_back(&mut rl.list, br);
    }

    public fun runner(): RangeList {
        let mut rl = new_range_list();

        let loc1 = new_location(vector::utf8(b"module.move"), 1, 5);
        let range1 = new_range(10, 20);
        let br1 = new_binding_range(vector::utf8(b"x"), range1, loc1);
        add_binding_range(&mut rl, br1);

        let loc2 = new_location(vector::utf8(b"module.move"), 2, 10);
        let range2 = new_range(30, 40);
        let br2 = new_binding_range(vector::utf8(b"y"), range2, loc2);
        add_binding_range(&mut rl, br2);

        rl
    }
}
//# run 0x1::RangeList::runner


//# publish
module 0x1::SpecAttributes {
    use std::vector;
    use std::string;

    /// A dummy resource, just to have attributes on spec blocks
    struct DummyResource has key {}

    #[test_only]
    #[deprecated]
    spec module {
        // attributes on spec blocks should not cause error
        #[spec_attr1]
        #[spec_attr2]
        fun spec_function() { }
    }

    #[spec_attr_outer]
    #[spec_attr_inner]
    spec fun dummy_spec() {
        // inner spec block attributes shouldn't cause error either
    }

    /// runner function to be invoked
    public fun runner() {
        // just empty, running this verifies attribute acceptance
    }
}
//# run 0x1::SpecAttributes::runner


//# publish
module 0x1::AbilitySetTest {
    use std::signer;

    // Define a resource type with a custom set of abilities: key + store (instead of default)
    struct MyResource has key, store {
        value: u64,
    }

    // Type with no abilities (empty ability set)
    struct EmptyAbility has {}

    // Type with copy, drop only
    struct CopyDrop has copy, drop {
        data: u8,
    }

    // Type with copy, drop, store, key abilities
    struct FullAbility has copy, drop, store, key {
        id: u64,
    }

    // Runner method to instantiate the resource and one other type
    public fun runner(account: &signer) {
        let res = MyResource { value: 42 };
        let cd = CopyDrop { data: 7 };

        // Use the resource by moving it into storage (a dummy test)
        move_to(account, res);

        // just use cd to avoid warnings
        let _ = cd;
    }
}
//# run 0x1::AbilitySetTest::runner --signers 0x1


//# run
script {
    use 0x1::RangeList;
    use 0x1::SpecAttributes;
    use 0x1::AbilitySetTest;
    use std::signer;

    fun main(account: signer) {
        // test RangeList runner
        let _ = RangeList::runner();

        // test SpecAttributes runner
        SpecAttributes::runner();

        // test AbilitySetTest runner
        AbilitySetTest::runner(&account);
    }
}