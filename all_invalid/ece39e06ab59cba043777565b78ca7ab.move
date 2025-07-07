
//# publish
module 0xCAFE::InvariantTest {
    use std::vector;

    struct InvObj has key, store {
        count: u64,
    }

    // Regular invariant example: count must always be less than 100
    // invariant]
    fun regular_invariant(obj: &InvObj): bool {
        obj.count < 100
    }

    // Update invariant example: after update, count should be non-zero
    // invariant(update)]
    fun update_invariant(obj: &InvObj): bool {
        obj.count != 0
    }

    public fun new_obj(): InvObj {
        InvObj {count: 0}
    }

    public fun update_obj(obj: &mut InvObj, new_count: u64) {
        obj.count = new_count;
    }

    // Add a public function to destructure InvObj, so other modules can access count safely
    public fun get_count(obj: &InvObj): u64 {
        obj.count
    }
}



//# run 0xCAFE::InvariantTest::new_obj




//# publish
module 0xCAFE::SymbolList {
    use std::vector;

    struct Symbol has copy, drop {
        val: vector<u8>
    }

    public fun string_list_to_symbol_list(list: vector<vector<u8>>): vector<Symbol> {
        let symbols = vector::empty<Symbol>();
        let len = vector::length(&list);
        let i = 0;
        while (i < len) {
            let s = *vector::borrow(&list, i);
            let sym = Symbol { val: s };
            vector::push_back(&mut symbols, sym);
            i = i + 1;
        };
        symbols
    }

    public fun example_conversion(): vector<Symbol> {
        let strs = vector[b"apple", b"banana", b"cherry"];
        string_list_to_symbol_list(strs)
    }
}



//# run 0xCAFE::SymbolList::example_conversion




//# publish
module 0xCAFE::NeighborModules {
    use 0xCAFE::InvariantTest;
    use 0xCAFE::SymbolList;

    public fun neighbor_use_demo() {
        // Use InvariantTest function
        let obj = InvariantTest::new_obj();
        InvariantTest::update_obj(&mut obj, 42);

        // Access count via public getter instead of unpacking struct
        let _count = InvariantTest::get_count(&obj);

        // Use SymbolList function
        let _symbols = SymbolList::example_conversion();
    }
}



//# run 0xCAFE::NeighborModules::neighbor_use_demo
