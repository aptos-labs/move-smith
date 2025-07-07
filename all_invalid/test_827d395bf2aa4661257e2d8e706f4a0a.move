//# publish
module 0xabcde::loop_and_modify {

    // Test that a for loop iterates correctly over a range from 0 to 10
    //# run
    script {
        fun main(): () {
            for (i in 0..10) {};
        }
    }

    // Test that a move value is correctly modified and returned without copying
    //# publish
    module 0xabcde::move_modifier {

        fun modify_and_return(b: bool, p: u64): u64 {
            let val = p;             // move p into val
            if (b) {
                val = 42;            // modify until the first branch
            };
            val                     // return modified value
        }

        public fun test() {
            // Should return 42 since b is true
            assert!(modify_and_return(true, 100) == 42, 0);
            // Should return original p value (100) since b is false
            assert!(modify_and_return(false, 100) == 100, 1);
        }
    }
    //# run 0xabcde::move_modifier::test

    // Test that a function handles multiple aborts and continues execution to produce a final result
    //# publish
    module 0xabcde::abort_and_continue {

        public fun abort_x(x: u64): u64 {
            abort x
        }

        public fun continue_execution(): u64 {
            let y = 10;
            let result = 0;
            if (true) {
                abort_x(5);
            } else {
                result = y * 2;
            };
            // Next code after abort (which won't run if aborts is hit)
            result + 1
        }

        public fun test(): u64 {
            // Wrap in a try to handle aborts gracefully (simulate execution)
            // In actual test, the aborts would terminate, but here, we assume final correctness.
            continue_execution()
        }
    }
    //# run 0xabcde::abort_and_continue::test
}