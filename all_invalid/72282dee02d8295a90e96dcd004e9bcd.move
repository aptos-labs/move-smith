module 0x1::test_transactional {

    use std::debug;
    use std::vector;

    /// An enum with variants for testing
    enum MyEnum {
        A,
        B(u64),
        C { x: u64, y: bool },
    }

    /// Nested struct for dot notation tests
    struct Outer {
        inner: Inner,
    }

    struct Inner {
        value: u64,
    }

    /// Returns the sum of all `MyEnum` variants' numeric contributions
    public fun sum_enum_val(e: MyEnum): u64 {
        // Just a utility function for tests
        match e {
            MyEnum::A => 10,
            MyEnum::B(x) => x,
            MyEnum::C { x, y } => if y { x } else { 0 },
        }
    }

    #[test]
    public entry fun test_variants() {
        // Test all variants within the defining module - variant creation, matching

        let a = MyEnum::A;
        let b = MyEnum::B(42);
        let c_true = MyEnum::C { x: 100, y: true };
        let c_false = MyEnum::C { x: 100, y: false };

        let val_a = sum_enum_val(a);
        let val_b = sum_enum_val(b);
        let val_c_true = sum_enum_val(c_true);
        let val_c_false = sum_enum_val(c_false);

        // Assert correct value dispatch from match
        debug::assert(val_a == 10, 0);
        debug::assert(val_b == 42, 1);
        debug::assert(val_c_true == 100, 2);
        debug::assert(val_c_false == 0, 3);
    }

    #[test]
    public entry fun test_nested_dot_notation() {
        // Create nested structs and access inner value by dot-chained path
        let inner = Inner { value: 123 };
        let outer = Outer { inner };

        // Access nested field using dot notation chain
        let val = outer.inner.value;

        debug::assert(val == 123, 10);
    }

    #[test]
    public entry fun test_vector_map_primitive() {
        // Vector of primitives: [1, 2, 3, 4]
        let input: vector<u64> = vector::from_array([1, 2, 3, 4]);
        // Map closure: multiply each element by 10, capture factor 10
        let factor = 10;

        let output = vector::map<u64, u64>(input, |x: u64| {
            x * factor
        });

        // Expected: [10, 20, 30, 40]
        debug::assert(vector::length(&output) == 4, 20);
        debug::assert(*vector::borrow(&output, 0) == 10, 21);
        debug::assert(*vector::borrow(&output, 1) == 20, 22);
        debug::assert(*vector::borrow(&output, 2) == 30, 23);
        debug::assert(*vector::borrow(&output, 3) == 40, 24);
    }

    #[test]
    public entry fun test_vector_map_vector() {
        // Vector of vectors: [[1,2], [3,4], [5]]
        let inner1 = vector::from_array([1, 2]);
        let inner2 = vector::from_array([3, 4]);
        let inner3 = vector::from_array([5]);

        let input: vector<vector<u64>> = vector::from_array([inner1, inner2, inner3]);

        // Map closure: for each inner vector, add 1 to each element
        // Capture offset = 1
        let offset = 1;
        let output = vector::map<vector<u64>, vector<u64>>(input, |v: vector<u64>| {
            vector::map<u64, u64>(v, |x: u64| { x + offset })
        });

        // output expected [[2, 3], [4, 5], [6]]
        debug::assert(vector::length(&output) == 3, 30);

        let out0 = vector::borrow(&output, 0);
        debug::assert(*vector::borrow(out0, 0) == 2, 31);
        debug::assert(*vector::borrow(out0, 1) == 3, 32);

        let out1 = vector::borrow(&output, 1);
        debug::assert(*vector::borrow(out1, 0) == 4, 33);
        debug::assert(*vector::borrow(out1, 1) == 5, 34);

        let out2 = vector::borrow(&output, 2);
        debug::assert(*vector::borrow(out2, 0) == 6, 35);
    }
}

// Featurres:
// dff165b90d81be268aa2dd6355fb7b75: Perform variant testing (`test_variants`) on enum types only within the module that defines the enum.
// 73d278c7618650803046349136e36d3d: Access nested names using a dot notation chain.
// 635fb0525118946a50130cecf3ee6bc4: Test that the std::vector::map function works correctly for both vectors of primitive types and vectors of vectors, including closure capturing and element mapping.
