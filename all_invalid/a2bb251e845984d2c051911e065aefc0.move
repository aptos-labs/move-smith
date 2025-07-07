module 0x1::TestFlattenAndVersionAndElemIter {

    use std::vector;
    use std::option;
    use std::string;

    /// Struct representing an attribute which can be nested.
    struct Attribute has copy, drop, store {
        key: vector<u8>,
        value: vector<u8>,
        nested: vector<Attribute>, // Nested attributes
    }

    /// Flatten nested attribute collections into a single attribute list.
    /// This function recursively flattens the nested attributes.
    public fun flatten_attributes(attrs: &vector<Attribute>): vector<Attribute> {
        let mut result = vector::empty<Attribute>();
        let len = vector::length(attrs);
        let mut i = 0;
        while (i < len) {
            let attr = vector::borrow(attrs, i);
            // Add current attribute without nested attributes
            let base = Attribute {
                key: vector::clone(&attr.key),
                value: vector::clone(&attr.value),
                nested: vector::empty(),
            };
            vector::push_back(&mut result, base);

            // Recursively flatten nested attributes and append to result
            let nested_flat = flatten_attributes(&attr.nested);
            let nested_len = vector::length(&nested_flat);
            let mut j = 0;
            while (j < nested_len) {
                vector::push_back(&mut result, vector::borrow(&nested_flat, j));
                j = j + 1;
            }
            i = i + 1;
        };
        result
    }

    /// A language item function that requires a minimum language version.
    /// We simulate this by using `vector::create` which was introduced in newer versions.
    /// Assume the language version required is 6 (for this example).
    #[verifier(language_version = 6)]
    public fun use_language_item() {
        // Vector::create requires min language version 6.
        let _v = vector::create(3, 42);
        // Just discard, testing compile and run with min version 6.
    }

    /// Elem struct as required for the third feature test.
    struct Elem has copy, drop, store {
        v: u64,
    }

    /// Mutably iterates over a vector of Elem, increments each `v` field,
    /// and accumulates their sum into an option::Option<u64>.
    public fun elem_for_each_ref(elems: &mut vector<Elem>): option::Option<u64> {
        let mut acc: u64 = 0;
        let len = vector::length(elems);
        let mut i = 0;
        while (i < len) {
            let elem_ref = vector::borrow_mut(elems, i);
            // Mutate v by incrementing by 1
            elem_ref.v = elem_ref.v + 1;
            acc = acc + elem_ref.v;
            i = i + 1;
        };
        option::some(acc)
    }

    /// Transactional test entrypoint
    #[test]
    public fun transactional_test() {
        // 1. Test flattening nested attributes
        let nested_attrs = vector::empty<Attribute>();
        let attr3 = Attribute {
            key: b"key3",
            value: b"value3",
            nested: vector::empty(),
        };
        let attr2 = Attribute {
            key: b"key2",
            value: b"value2",
            nested: vector::empty(),
        };
        let mut attr1_nested = vector::empty<Attribute>();
        vector::push_back(&mut attr1_nested, attr2);
        vector::push_back(&mut attr1_nested, attr3);
        let attr1 = Attribute {
            key: b"key1",
            value: b"value1",
            nested: attr1_nested,
        };
        let mut top_attrs = vector::empty<Attribute>();
        vector::push_back(&mut top_attrs, attr1);

        let flat_attrs = flatten_attributes(&top_attrs);
        let flat_len = vector::length(&flat_attrs);
        // Expect 3 flat attributes
        assert!(flat_len == 3, 101);

        // Check keys flattened correctly
        let k0 = vector::borrow(&flat_attrs, 0);
        let k1 = vector::borrow(&flat_attrs, 1);
        let k2 = vector::borrow(&flat_attrs, 2);
        assert!(vector::equals(&k0.key, b"key1"), 102);
        assert!(vector::equals(&k1.key, b"key2"), 103);
        assert!(vector::equals(&k2.key, b"key3"), 104);

        // 2. Use a language item function with required min version
        use_language_item();

        // 3. Test elem_for_each_ref function correctness
        let mut elems = vector::empty<Elem>();
        vector::push_back(&mut elems, Elem { v: 1 });
        vector::push_back(&mut elems, Elem { v: 2 });
        vector::push_back(&mut elems, Elem { v: 3 });

        let acc_opt = elem_for_each_ref(&mut elems);
        assert!(option::is_some(&acc_opt), 105);
        let acc = option::borrow(&acc_opt);

        // Original elems: 1,2,3
        // After increment: 2,3,4
        // Sum: 9
        assert!(*acc == 9, 106);

        // Check mutation in elems vector
        let e0 = vector::borrow(&elems, 0);
        let e1 = vector::borrow(&elems, 1);
        let e2 = vector::borrow(&elems, 2);
        assert!(e0.v == 2, 107);
        assert!(e1.v == 3, 108);
        assert!(e2.v == 4, 109);
    }
}

// Featurres:
// 070c1100f7e02cc1cacd103bd588767b: Flatten nested attribute collections into a single attribute list.
// 1b6e69660f14edaa90ec85de5c9a4c02: Use language items that require a minimum specified language version in your Move code.
// 53e08013c54ee81ae97423472172bc19: Test that the `elem_for_each_ref` function correctly iterates over a vector of `Elem` objects, allowing mutation of the `v` field and properly accumulating the results.Failed to generate a completion. Please try again.
