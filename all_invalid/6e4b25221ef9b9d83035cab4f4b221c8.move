
//# publish
module 0xCAFE::InvariantTest {
    use std::vector;
    use std::string;

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
}


//# run 0xCAFE::InvariantTest::new_obj


//# publish
module 0xCAFE::SymbolList {
    use std::vector;
    use std::string;

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

        // Use SymbolList function
        let _symbols = SymbolList::example_conversion();
    }
}


//# run 0xCAFE::NeighborModules::neighbor_use_demo


// Featurres:
// c70d5c3e1e65b82fa6fb866dee4ef840: Specify whether an invariant is a regular invariant or an 'update' invariant by including the 'update' keyword.
// 78af512b113f55770b2a635ce9a9d77c: Convert a list of strings into a list of symbols for usage in your Move code
// 7d99bcdfe7182509c4201e56ea92b828: Access all direct (immediate) module or script neighbors that are referenced during import or use.
