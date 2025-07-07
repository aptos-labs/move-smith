//# publish
module 0x1::PhantomTest {
    // Test feature 1: Phantom type parameter used.
    struct MyStruct<T, phantom U> {
        field: T,  // U is unused, marked as phantom to avoid compiler warnings
    }

    public fun create<T, U>(x: T): MyStruct<T, U> {
        MyStruct { field: x }
    }

    // Test feature 2: Use <<T as End Delimiter> contexts
    // Function nested_types will return true if execution succeeds, which
    // demonstrates use of '<' as end delimiter when parsing nested vectors.
    public fun nested_types(): bool {
        let _: vector<vector<u8>> = vector::empty<vector<u8>>();
        true
    }

    // Runner function
    public fun run() {
        let _ = create<u8, bool>(100);
        let _ = nested_types();
    }
}
//# run 0x1::PhantomTest::run --signers 0x1

//# publish
module 0x2::ControlFlowTest {
    use std::vector;

    // Feature 3: Complex nested for/while with variables tracking
    public fun nested_loop_runner(): u64 {
        let mut sum = 0u64;
        let vec = vector::empty<u8>();
        vector::push_back(&mut vec, 1);
        vector::push_back(&mut vec, 2);
        vector::push_back(&mut vec, 3);

        // Outer for
        let mut i = 0;
        while (i < vector::length(&vec)) {
            let v = *vector::borrow(&vec, i);
            let mut j = 0;
            // Inner while
            while (j < v) {
                sum = sum + (i as u64) + (j as u64);
                j = j + 1;
                // Artificial branch to test VM control flow
                if (sum > 6) {
                    // Intentional break of inner loop
                    break;
                }
            }
            i = i + 1;
        }
        sum
    }

    // Public "runner" function
    public fun run() {
        let _ = nested_loop_runner();
    }
}
//# run 0x2::ControlFlowTest::run --signers 0x2

//# run
script {
    use std::vector;

    fun main() {
        // Test feature 2 again in script context, to test parsing '<' as end delimiter.
        let nested: vector<vector<u8>> = vector::empty<vector<u8>>();
        let mut sum = 0u8;

        for v in &nested {
            let mut i = 0u8;
            while (i < 2) {
                sum = sum + i;
                i = i + 1;
            }
        }
        // No assertion needed, just force execution through VM.
        let _ = sum;
    }
}