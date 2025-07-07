//# publish
module 0xABC::loop_break_test {
    //# run
    script {
        fun main() {
            let condition = false;
            loop {
                if (condition) {
                    if (condition) continue;
                } else {
                    break;
                }
            };
        }
    }

    //# run
    script {
        fun test_loop_break() {
            let flag = true;
            let counter = 0;
            loop {
                if (counter >= 3) {
                    break;
                }
                if (flag && counter == 1) {
                    condition = false; // Switch condition to false inside the loop
                }
                if (flag && counter == 0) {
                    // Continue loop without breaking
                    continue;
                }
                counter = counter + 1;
            }
            // After loop, counter should be 3
        }
        // Call runner function
        pub fun run_tests() {
            test_loop_break();
        }
    }

    //# run 0xABC::loop_break_test::run_tests
    // no arguments needed
}

 //# publish
module 0xDEF::copy_and_arith {
    fun copy_kill(_p: u64): u64 {
        let a = _p;
        let b = a;
        _p = _p + 2;
        b + a
    }

    public fun main() {
        // Testing copy_kill with different input
        assert!(copy_kill(5) == 10, 0);
        assert!(copy_kill(0) == 0, 1);
        assert!(copy_kill(20) == 40, 2);
    }
}

//# run 0xDEF::copy_and_arith::main

//# publish
module 0x123::logical_ops {
    fun test_logic() {
        assert!((true && false) == false, 200);
        assert!((true || false) == true, 201);
        assert!(!true == false, 202);
        assert!(!false == true, 203);
        assert!(!!true == true, 204);
        assert!(!!false == false, 205);
        // Additional interaction test
        assert!(((true && true) || (false && true)) == true, 206);
        assert!(!((false || false) && true) == true, 207);
    }

    public fun run_tests() {
        test_logic();
    }
}

//# run 0x123::logical_ops::run_tests