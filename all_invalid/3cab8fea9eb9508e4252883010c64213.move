
//# publish
module 0xCAFE::AbilitiesTest {
    // Test abilities annotations on structs and resources
    struct CopyResource has copy, store {
        value: u8
    }

    struct DropAndCopy has copy, drop {
        data: u16
    }

    struct StoreOnly has store {
        field: u64
    }

    struct KeyResource has key, store {
        id: u128
    }

    public fun create_resources(): CopyResource {
        CopyResource { value: 42 }
    }

    public fun test_abilities_usage() {
        let _copy_res = create_resources();
        let _drop_copy = DropAndCopy { data: 123 };
        let _store_only = StoreOnly { field: 456 };
        let _key_res = KeyResource { id: 789 };
    }

    // Dummy function named 'exps' that accepts vector<u8> representing Move expressions as byte strings,
    // simulates applying 'exp_' transformation on each expression string,
    // and returns vector<u8> of transformed expressions as byte strings.
    //
    // This is purely illustrative as actual 'exp_' is not a Move function,
    // so here we just append b"_exp" to each string.
    public fun exps(exprs: vector<vector<u8>>): vector<vector<u8>> {
        let transformed = vector::empty<vector<u8>>();
        let len = vector::length(&exprs);
        let i = 0;
        while (i < len) {
            let expr = *vector::borrow(&exprs, i);
            let new_expr = vector::empty<u8>();
            let j_max = vector::length(&expr);
            let j = 0;
            while (j < j_max) {
                let c = *vector::borrow(&expr, j);
                vector::push_back(&mut new_expr, c);
                j = j + 1;
            };
            // Append suffix "_exp"
            let suffix = b"_exp";
            let k = 0;
            while (k < vector::length(&suffix)) {
                vector::push_back(&mut new_expr, *vector::borrow(&suffix, k));
                k = k + 1;
            };
            vector::push_back(&mut transformed, new_expr);
            i = i + 1;
        };
        transformed
    }

    // Dummy function named 'symbolize' that accepts vector<u8> of UTF8 strings,
    // returns vector<u64> that represents symbols by converting bytes into u64 ints for example.
    // This just returns length of each string as a single element vector to simulate symbolization.
    public fun symbolize(strings: vector<vector<u8>>): vector<vector<u64>> {
        let symbols = vector::empty<vector<u64>>();
        let len = vector::length(&strings);
        let i = 0;
        while (i < len) {
            let s = *vector::borrow(&strings, i);
            let slen = vector::length(&s);
            let sym = vector::empty<u64>();
            vector::push_back(&mut sym, slen as u64);
            vector::push_back(&mut symbols, sym);
            i = i + 1;
        };
        symbols
    }

    // Runner function to call exps and symbolize with some sample data
    public fun runner() {
        let exprs = vector[
            b"x+1",
            b"y*2",
            b"z-3"
        ];
        let _ = exps(exprs);

        let strings = vector[
            b"alpha",
            b"beta",
            b"gamma"
        ];
        let _ = symbolize(strings);
    }
}


//# run 0xCAFE::AbilitiesTest::test_abilities_usage


//# run 0xCAFE::AbilitiesTest::runner


// Featurres:
// e50f7ebef96acd475a77c80dd2e3b935: Annotate structs or resources with abilities such as Copy, Drop, Store, or Key using 'has' modifiers.
// e4f4fb756ae16b178004ed92b279c472: Use the 'exps' function to transform a list of Move expressions into another form, applying the 'exp_' function to each expression within a compiler context.
// 78af512b113f55770b2a635ce9a9d77c: Convert a list of strings into a list of symbols for usage in your Move code
