// # publish
address 0xCAFE {
module FriendModule {
    friend 0xBEEF;
    // This function is marked private and can only be called by FriendModule's friends (0xBEEF)
    private fun private_function(): u64 {
        42
    }

    /// A public "runner" function to call the private function internally: no signer required
    public fun runner(): u64 {
        private_function()
    }

    /// A function callable by friends - calls the private function internally
    public fun friend_caller(): u64 {
        private_function()
    }
}
}

// # publish
address 0xBEEF {
module FriendOfFriendModule {
    /// Call FriendModule::friend_caller which internally calls FriendModule's private_function
    public fun test_friend_call(): u64 {
        0xCAFE::FriendModule::friend_caller()
    }

    /// Runner function attempting to directly call private function (should fail if uncommented)
    /// Not called in test because it should not compile.
    // public fun illegal_call(): u64 {
    //     0xCAFE::FriendModule::private_function()
    // }

    /// Runner entry function to be called by run command
    public fun runner(): u64 {
        test_friend_call()
    }
}
}

// # publish
address 0xC0DE {
module SimplifyUpdate {
    // Public function to test rewriting and simplification of a function body
    public fun complicated_computation(x: u64): u64 {
        let y = x * 2;
        // Rewritten version: simplify y + 10 - 2 to y + 8
        y + 8
    }

    // Another function that calls complicated_computation multiple times
    public fun complex_runner(): u64 {
        let a = complicated_computation(5);
        let b = complicated_computation(10);
        a + b
    }

    // Runner function to test simplified function execution
    public fun runner(): u64 {
        complex_runner()
    }
}
}

// # publish
address 0xDEAD {
module DeadCodeTest {
    // Test dead code in else branch after conditional with loop and break
    public fun test_dead_code(): u64 {
        let mut x = 0u64;
        if (true) {
            // Loop with break to ensure loop and break inside if branch works
            let mut i = 0u8;
            loop {
                x = x + (i as u64);
                if (i == 3) {
                    break;
                }
                i = i + 1;
            }
            100
        } else {
            // Dead code: loop with break, but this branch never runs
            let mut i = 0u8;
            loop {
                x = x + (i as u64); // Dead code, but must not affect execution or cause errors
                break;
            }
            200
        };
        // Return x + 50 to verify loop computations
        x + 50
    }

    public fun runner(): u64 {
        test_dead_code()
    }
}
}

// # run
script {
    use 0xCAFE::FriendModule;
    use 0xBEEF::FriendOfFriendModule;
    use 0xC0DE::SimplifyUpdate;
    use 0xDEAD::DeadCodeTest;

    fun main() {
        // Call module runner functions and scripts to test compiler/vm
        let res1 = FriendModule::runner();
        let res2 = FriendOfFriendModule::runner();
        let res3 = SimplifyUpdate::runner();
        let res4 = DeadCodeTest::runner();

        // Dummy use of results to avoid unused variable warnings
        let _: u64 = res1 + res2 + res3 + res4;
    }
}

// Featurres:
// 5a93f8922a3f80b6cbf1c7f536622223: Enforce module privacy rules based on friendship relationships during function calls.
// 2299143f301faa72d1100abc3fbe6b4a: Rewrite and update the bodies of target functions after simplification.
// e51a13f151c79b9b3b0d4ad12d73a0c0: Test that dead code in the else branch after a conditional with a loop and break does not affect execution or cause errors.
