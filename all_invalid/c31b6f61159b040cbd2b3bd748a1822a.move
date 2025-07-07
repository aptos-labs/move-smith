//# publish
address 0xCAFE {
    module VectorLengthTest {
        use std::vector;

        // A "runner" function that returns the length of a large vector with 1026 elements.
        public fun run_large_vector_1026_length(): u64 {
            let mut v = vector::empty<u8>();
            let mut i = 0u64;
            // push 1026 elements (u8 from 0 to 255 cycle)
            while (i < 1026) {
                vector::push_back(&mut v, (i % 256) as u8);
                i = i + 1;
            };
            let len = vector::length(&v) as u64;
            len
        }

        // A "runner" function that returns the length of a large predefined numeric vector with thousands of elements.
        public fun run_large_vector_thousands_length(): u64 {
            // Create a vector<u64> with 3000 elements [0,1,2,...,2999]
            let mut v = vector::empty<u64>();
            let mut i = 0u64;
            while (i < 3000) {
                vector::push_back(&mut v, i);
                i = i + 1;
            };
            vector::length(&v) as u64
        }

        // A small function to test unconditional jump semantics by using loops and returns.
        // The logic used here is simple: a counter added up to 10 by jumping labels.
        public fun run_unconditional_jump_simulation(): u64 {
            let mut acc = 0u64;

            // simulate a jump loop with a label and manually controlled jumps:
            // This simulates unconditional jumps in bytecode style, in Move source we use a loop and if.
            let mut counter = 0u8;

            loop {
                if (counter == 10) {
                    // quit loop (like jump to exit)
                    break;
                };
                acc = acc + (counter as u64);
                counter = counter + 1;
            };

            acc
        }

    }
}
//# run 0xCAFE::VectorLengthTest::run_large_vector_1026_length
//# run 0xCAFE::VectorLengthTest::run_large_vector_thousands_length
//# run 0xCAFE::VectorLengthTest::run_unconditional_jump_simulation


//# run
script {
    use 0xCAFE::VectorLengthTest;

    fun main() {
        let len_1026 = VectorLengthTest::run_large_vector_1026_length();
        let len_thousands = VectorLengthTest::run_large_vector_thousands_length();
        let jump_sim = VectorLengthTest::run_unconditional_jump_simulation();

        // Print or use the results to exercise the VM.
        // Move transactional tests do not need asserts or outputs,
        // but performing local vars usage exercises the VM.
        let _ = len_1026;
        let _ = len_thousands;
        let _ = jump_sim;
    }
}


// Featurres:
// 89852f8f837b39aa2df27137180131b1: Define Move packages with optional package names.
// 227906e22aa321006147337dca6670c1: Use unconditional jumps to transfer control flow to a specified label in Move bytecode.
// 9898ecef48e80badb478f37dbd426347: Verify that the functions correctly return the length of large vectors, including one with 1026 elements and another with thousands of predefined numeric elements.
