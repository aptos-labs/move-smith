//# publish
module 0xCAFE::Visibility {
    use std::string;

    // Visibility is defined as a u8 for demonstration:
    // 0: private, 1: public, 2: friend, etc.
    struct Visibility has copy, drop, store {
        value: u8
    }

    // Return string representation of the visibility
    public fun to_string(vis: Visibility): vector<u8> {
        if (vis.value == 0) {
            b"private"
        } else if (vis.value == 1) {
            b"public"
        } else if (vis.value == 2) {
            b"friend"
        } else {
            b"unknown"
        }
    }

    // Constructors
    public fun private(): Visibility { Visibility { value: 0 } }
    public fun public(): Visibility { Visibility { value: 1 } }
    public fun friend(): Visibility { Visibility { value: 2 } }

    // Runner function to ensure compiler coverage
    public fun runner() {
        let v_private = private();
        let v_public = public();
        let v_friend = friend();
        let _ = to_string(v_private);
        let _ = to_string(v_public);
        let _ = to_string(v_friend);
    }
}
//# run 0xCAFE::Visibility::runner

//# publish
module 0xCAFE::LoopReturn {
    // This function tests a loop with an internal conditional return to terminate the function early
    public fun test_loop_return(): u64 {
        let mut i = 0u64;
        loop {
            i = i + 1;
            if (i == 5) {
                // Returning inside the loop should exit immediately
                return i;
            }
            // Otherwise continue looping
        }
        // Unreachable but syntax requires a return, return 0 just in case
        0
    }

    // Runner to test the loop function
    public fun runner(): u64 {
        test_loop_return()
    }
}
//# run 0xCAFE::LoopReturn::runner

//# run
script {
    use 0xCAFE::Visibility;
    use 0xCAFE::LoopReturn;

    fun main() {
        // Test the visibility to_string returns
        let vis_public = Visibility::public();
        let vis_str = Visibility::to_string(vis_public);
        // Note: No assert needed
        
        // Test the loop return behavior
        let loop_result = LoopReturn::test_loop_return();
        // Note: No assert needed, just run

        // Exit main - no return needed, function ends here
    }
}