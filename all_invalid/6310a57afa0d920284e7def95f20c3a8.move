//# publish
module 0xCAFE::ReturnTest {
    public fun test(): u64 {
        let mut x = 10;
        x = x + 20;
        x = x * 2;
        x = x / 5;
        x = x - 1;
        x
    }

    public fun runner(): u64 {
        let cond = true;
        if cond {
            return 42;
        } else {
            return 24;
        }
    }
}

//# run 0xCAFE::ReturnTest::runner --signers 0xCAFE

//# run 0xCAFE::ReturnTest::test --signers 0xCAFE

//# run
script {
    use 0xCAFE::ReturnTest;

    // Test if-else with returns
    fun main() {
        let cond = false;
        let res = if cond {
            return 1;
        } else {
            return 2;
        };
    }
}

// Featurres:
// 2c12cc14febccc74bcced84e346b16a8: Test that the Move language correctly handles return statements in both branches of an if-else statement within a script.
// 90b0011045b6d2bb1a0407e441a41a35: Use if-else expressions for conditional branching.
// 994ce8b5626bf946b04ae2a76053213f: Test that the `test` function correctly performs multiple sequential arithmetic operations on a local variable and returns the expected computed value.
