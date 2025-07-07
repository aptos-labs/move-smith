// A transactional test to verify nested match statements, generic structs, and large vector constant comparisons
// Address used: 0xCAFE

//# publish
module 0xCAFE::NestedMatch {
    use std::vector;

    // Define a generic struct with type parameter T
    struct Wrapper<T> has copy, drop, store {
        value: T,
    }

    // Large vector constant with > 800 elements
    const LARGE_VECTOR: vector<u8> = vector_init();

    fun vector_init(): vector<u8> {
        let mut tmp = vector::empty<u8>();
        let mut i = 0u16;
        // Push 850 elements: 0..849
        while (i < 850) {
            vector::push_back(&mut tmp, (i as u8));
            i = i + 1;
        };
        tmp
    }

    // Another large vector constant for comparison: same length 850 with all zeros
    const LARGE_VECTOR_ZERO: vector<u8> = vector_zero_init();

    fun vector_zero_init(): vector<u8> {
        let mut tmp = vector::empty<u8>();
        let mut i = 0u16;
        while (i < 850) {
            vector::push_back(&mut tmp, 0u8);
            i = i + 1;
        };
        tmp
    }

    // Constant expression comparing two large vectors for equality
    const VECTORS_EQUAL: bool = vector::eq(&LARGE_VECTOR, &LARGE_VECTOR);

    // Constant expression comparing large vector with different vector should be false
    const VECTORS_DIFFERENT: bool = vector::eq(&LARGE_VECTOR, &LARGE_VECTOR_ZERO);

    // Nested match with booleans and nested tuple patterns
    public fun nested_match_handler(x: u8, y: bool): u8 {
        // Outer match on x mod 3
        match x % 3 {
            0 => {
                // Inner match on y boolean
                match y {
                    true => 10,
                    false => 20
                }
            }
            1 => {
                // Inner match on tuple (x mod 2, y)
                match ((x % 2), y) {
                    (0, true) => 30,
                    (0, false) => 40,
                    (1, true) => 50,
                    (1, false) => 60
                }
            }
            _ => {
                // Should cover only 2 mod 3
                70
            }
        }
    }

    // Runner function with no arguments that calls nested_match_handler for all edges and returns sum
    public fun runner(): u64 {
        // outer 0:
        let mut s = 0u64;
        s = s + (nested_match_handler(0, true) as u64);
        s = s + (nested_match_handler(0, false) as u64);
        // outer 1 with inner (0,y):
        s = s + (nested_match_handler(4, true) as u64);
        s = s + (nested_match_handler(4, false) as u64);
        // outer 1 with inner (1,y):
        s = s + (nested_match_handler(1, true) as u64);
        s = s + (nested_match_handler(1, false) as u64);
        // outer 2 case:
        s = s + (nested_match_handler(2, true) as u64);
        s = s + (nested_match_handler(2, false) as u64);
        s
    }
}
//# run 0xCAFE::NestedMatch::runner

//# publish
module 0xCAFE::GenericStructTest {
    // Define a generic struct with two type parameters and abilities
    struct Pair<A, B> has copy, drop, store {
        first: A,
        second: B,
    }

    // A runner function that creates a Pair<u8, bool> and returns 1 if first=123 and second=true else 0
    public fun runner(): u8 {
        let p = Pair<u8, bool> { first: 123, second: true };
        if (p.first == 123 && p.second) {
            1
        } else {
            0
        }
    }
}
//# run 0xCAFE::GenericStructTest::runner

//# publish
module 0xCAFE::ConstVecTest {
    use std::vector;

    // Create a large vector constant with 900 elements all 1
    const VEC1: vector<u8> = vector_one_init();

    fun vector_one_init(): vector<u8> {
        let mut tmp = vector::empty<u8>();
        let mut i = 0u16;
        while (i < 900) {
            vector::push_back(&mut tmp, 1u8);
            i = i + 1;
        };
        tmp
    }

    // Create a large vector constant with 900 elements all 2
    const VEC2: vector<u8> = vector_two_init();

    fun vector_two_init(): vector<u8> {
        let mut tmp = vector::empty<u8>();
        let mut i = 0u16;
        while (i < 900) {
            vector::push_back(&mut tmp, 2u8);
            i = i + 1;
        };
        tmp
    }

    // Check equality of VEC1 with itself at constant time
    const VEC1_EQ: bool = vector::eq(&VEC1, &VEC1);

    // Check equality of VEC1 and VEC2 at constant time (should be false)
    const VEC1_NEQ: bool = vector::eq(&VEC1, &VEC2);

    // Runner calls checks and returns 1 if all constant checks hold, else 0
    public fun runner(): u8 {
        let ok1 = if VEC1_EQ { 1 } else { 0 };
        let ok2 = if !VEC1_NEQ { 1 } else { 0 };
        ok1 + ok2 // should be 2 if correct
    }
}
//# run 0xCAFE::ConstVecTest::runner

//# run
script {
    use 0x1::vector;
    use 0x1::debug;

    fun main() {
        let nm_res = 0xCAFE::NestedMatch::runner();
        debug::print(&vector::empty<u8>()); // no-op print just for coverage
        let gs_res = 0xCAFE::GenericStructTest::runner();
        let cv_res = 0xCAFE::ConstVecTest::runner();

        // Print results mod 256 as u8 bytes
        debug::print(&vector::singleton((nm_res as u8)));
        debug::print(&vector::singleton(gs_res));
        debug::print(&vector::singleton(cv_res));
    }
}