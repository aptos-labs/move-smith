//# publish
module 0xabc::primitive_struct_test {
    // Helper function to consume a primitive u64
    fun consume_u64(_val: u64) {}

    // Helper function to consume a struct W
    fun consume_struct(_w: W) {}

    // Struct with copy and drop capabilities
    struct W has copy, drop {
        x: u64,
        y: bool,
    }

    // Function to test copying and passing primitives
    public fun test_primitives(a: u64, b: bool) {
        let a_copy = copy a;
        let b_copy = copy b;
        consume_u64(a_copy);
        consume_u64(a);
        // mutate original to check for side effects
        // (no mutation, just passing copies)
        consume_u64(b_copy);
        consume_u64(b);
    }

    // Function to test copying and passing structs
    public fun test_structs(w: W) {
        let w_copy = copy w;
        consume_struct(w_copy);
        consume_struct(w);
    }

    // Runner function to test both primitives and structs
    public fun main() {
        test_primitives(42, true);
        let s = W { x: 99, y: false };
        test_structs(s);
    }
}

//# run 0xabc::primitive_struct_test::main

   
//# publish
module 0xabc::conditional_return {
    public fun get_value(condition: bool): u64 {
        if (condition) {
            return 100;
        } else {
            let temp = 0;
            // this branch intentionally empty besides assignment
        }
        // fallback, should never reach here if condition is true
        999
    }
}


//# run
script {
use 0xabc::conditional_return;

fun main() {
    // Test with condition true, should return 100 regardless of previous variable
    assert!(conditional_return::get_value(true) == 100, 42);
    // Test with condition false, should not return 100
    assert!(conditional_return::get_value(false) == 999, 43);
}
}


//# publish
module 0xabc::break_inside_loop {
    public fun main() {
        // Loop with break, no assertions after break
        loop {
            if (true) {
                break;
            }
        }
    }
}


//# run
script {
fun main() {
    // Executing the script should terminate immediately after break; no assertions after
    // The test is to ensure no runtime errors occur
    // Note: No assertions needed; just run to ensure no panics
    0;
}
}