// # publish
module 0xCAFE::InvariantAndVector {

    use std::vector;

    struct Data has store, drop {
        values: vector<u8>,
        count: u64,
    }

    spec {
        invariant "count_matches_length" {
            forall d: Data :: d.count == vector::length(&d.values) as u64
        }
    }

    public fun new_data(): Data {
        let vals = vector::empty<u8>();
        Data {
            values: vals,
            count: 0,
        }
    }

    public fun add_value(d: &mut Data, val: u8) {
        vector::push_back(&mut d.values, val);
        d.count = d.count + 1;
    }

    public fun runner() {
        let mut d = new_data();
        add_value(&mut d, 10);
        add_value(&mut d, 20);
        add_value(&mut d, 30);

        // Invariant should hold (count == length)
        let len = vector::length(&d.values);
        assert!(d.count == (len as u64), 100);
    }
}
// # run 0xCAFE::InvariantAndVector::runner

// # publish
module 0xCAFE::VariableParsing {

    /// This function tests parsing and use of variable identifiers.
    /// We'll have multiple variables with underscore, digits etc.
    public fun var_id_test() : u64 {
        let x1 = 10u64;
        let _x2 = 20u64;
        let temp_var3 = 30u64;

        let combined = x1 + _x2 + temp_var3;
        combined
    }

    public fun runner() {
        let val = var_id_test();
        // val == 60u64 should hold
        assert!(val == 60, 201);
    }
}
// # run 0xCAFE::VariableParsing::runner

// # publish
module 0xCAFE::VectorWithType {

    use std::vector;

    /// This function creates a vector<u64> with some elements.
    public fun create_vector_u64() : vector<u64> {
        let mut v = vector::empty<u64>();
        vector::push_back(&mut v, 1u64);
        vector::push_back(&mut v, 2u64);
        vector::push_back(&mut v, 3u64);

        v
    }

    public fun runner() {
        let v = create_vector_u64();
        // Check length = 3
        assert!(vector::length(&v) == 3, 301);
        // Check first element
        let first = *vector::borrow(&v, 0);
        assert!(first == 1, 302);
    }
}
// # run 0xCAFE::VectorWithType::runner

// # run 0xCAFE::InvariantAndVector::runner
// # run 0xCAFE::VariableParsing::runner
// # run 0xCAFE::VectorWithType::runner

// Featurres:
// 1572b617e0987acb2f9490483264dc83: Declare invariants in spec blocks to specify conditions that must always hold.
// 68b15705314c207ff25a25931f860900: Parse variable identifiers in the Move language code.
// a231dc4d27bf992781ad062e3287d6ee: Create vector types with element type specifications using 'vector<type>' syntax.
