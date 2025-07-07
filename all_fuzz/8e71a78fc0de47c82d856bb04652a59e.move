
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    /// A naive set representation for ability constraints for each generic type, for demo purposes
    struct TypeAbilitySet has copy, drop {
        // Use a vector of booleans to represent if a certain ability is present
        // Positions: 0 = copy, 1 = drop, 2 = store, 3 = key
        abilities: vector<bool>,
    }

    /// Convert ability constraints from type parameters presence into a set representation
    /// For the purpose of demonstration: we simulate type parameters and their abilities by booleans passed from script
    public fun abilities_to_set(is_copy: bool, is_drop: bool, is_store: bool, is_key: bool): TypeAbilitySet {
        let abilities = vector::empty<bool>();

        vector::push_back(&mut abilities, is_copy);
        vector::push_back(&mut abilities, is_drop);
        vector::push_back(&mut abilities, is_store);
        vector::push_back(&mut abilities, is_key);

        TypeAbilitySet { abilities }
    }

    /// Example addition function, takes two u8 numbers, returns their sum + 10
    public fun add_and_offset(val1: u8, val2: u8): u8 {
        val1 + val2 + 10
    }

    /// Function with anonymous function (lambda) expressions
    public fun lambda_examples(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };
        let sum = add(x, y);
        let product = mul(x, y);
        (sum, product)
    }

    /// Inline function that multiplies a u64 number by a u64 multiplier
    public inline fun multiply(a: u64, b: u64): u64 {
        a * b
    }

    /// A function that tests calling the inline function nestedly and returns result as u64
    public fun nested_inline_call(a: u64, b: u64, c: u64): u64 {
        let ab = multiply(a, b);
        multiply(ab, c)
    }

    /// Multiple parameters function with arbitrary types and different abilities
    public fun multi_params_fn(addr: address, x: u8, y: u64, b: bool): u64 {
        if (b) {
            y + (x as u64)
        } else {
            0
        }
    }

    /// Custom fold function over vector<u8> implementing sum
    public fun fold_sum(v: &vector<u8>): u64 {
        let acc = 0u64;
        let len = vector::length(v);
        let i = 0;

        while (i < len) {
            let val = *vector::borrow(v, i);
            acc = acc + (val as u64);
            i = i + 1;
        };
        acc
    }

    /// Custom vector removal function with shifting elements left
    /// Removes element at index and shifts rest left; returns removed element
    public fun remove_at_and_shift(v: &mut vector<u8>, index: u64): u8 {
        let len = vector::length(v);
        assert!(index < len, 100);

        let removed_val = *vector::borrow(v, index);

        let i = index;
        while (i + 1 < len) {
            let next_val = *vector::borrow(v, i + 1);
            let cur_ref = vector::borrow_mut(v, i);
            *cur_ref = next_val;
            i = i + 1;
        };
        // Pop last element which is duplicated after shifting
        vector::pop_back(v);
        removed_val
    }

    /// Runner function that tests fold and remove_at_and_shift with assertions
    public fun runner() {
        let v = vector[10u8, 20u8, 30u8, 40u8, 50u8];
        let summed = fold_sum(&v);
        assert!(summed == 150u64, 101);

        let removed = remove_at_and_shift(&mut v, 2);
        assert!(removed == 30u8, 102);

        // Check new length and shifted elements
        let len = vector::length(&v);
        assert!(len == 4, 103);
        assert!(*vector::borrow(&v, 2) == 40u8, 104);
        assert!(*vector::borrow(&v, 3) == 50u8, 105);
    }
}



//# run 0xCAFE::FeatureTest::add_and_offset --args 3u8 4u8



//# run 0xCAFE::FeatureTest::lambda_examples --args 5u8 6u8



//# run 0xCAFE::FeatureTest::nested_inline_call --args 2u64 3u64 4u64



//# run 0xCAFE::FeatureTest::multi_params_fn --args 0xCAFE 7u8 8u64 true



//# run 0xCAFE::FeatureTest::abilities_to_set --args true false true false



//# run 0xCAFE::FeatureTest::runner
