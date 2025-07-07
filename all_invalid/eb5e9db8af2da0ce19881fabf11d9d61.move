//# publish
module 0xCAFE::SpecMatchIfTest {
    use std::signer;

    /// A dummy struct to use in match and if tests.
    struct Dummy has copy, drop, store, key {}

    /// A function that tests match with single expression arms and returns u8.
    public fun match_single_expr(x: u8): u8 {
        match x {
            0 => 10,
            1 => 20,
            _ => 30
        }
    }

    /// A function that uses a block as the body of each match arm, returning u8.
    public fun match_block(x: u8): u8 {
        match x {
            0 => {
                let y = 100;
                y
            },
            1 => {
                let y = 200;
                y
            },
            _ => {
                let y = 300;
                y
            }
        }
    }

    /// A function using if expression without else branch.
    public fun if_no_else(x: u8): u8 {
        if (x > 5) {
            42
        } else {
            0
        }
    }

    /// A function using if expression with else branch.
    public fun if_with_else(x: u8): u8 {
        if (x == 0) {
            1
        } else if (x == 1) {
            2
        } else {
            3
        }
    }

    /// A runner function that calls the above to exercise them; no arguments, no return.
    public fun runner() {
        // dummy calls to consume returned values
        let _ = match_single_expr(0);
        let _ = match_single_expr(2);
        let _ = match_block(0);
        let _ = match_block(2);
        let _ = if_no_else(6);
        let _ = if_no_else(2);
        let _ = if_with_else(0);
        let _ = if_with_else(1);
        let _ = if_with_else(42);
    }

    spec module {
        // Spec block that uses match with single expressions in ensures
        ensures match 1 {
            0 => false,
            1 => true,
            _ => false
        };

        // Spec with if expression
        ensures {
            let res = if (true) { 5 } else { 10 };
            res == 5
        };
    }
}
//# run 0xCAFE::SpecMatchIfTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::SpecMatchIfTest;

    fun main() {
        let res1 = SpecMatchIfTest::match_single_expr(1);
        let res2 = SpecMatchIfTest::match_block(1);
        let res3 = SpecMatchIfTest::if_no_else(10);
        let res4 = SpecMatchIfTest::if_with_else(0);

        // Consume results to avoid unused variable warnings
        let _ = res1 + res2 + res3 + res4;
    }
}

// Featurres:
// d43b5a0d688d38535489b7863763334a: Include Move specifications (spec blocks) in modules.
// cb13e562c934693e4ed8de450a53c13b: Use either a single expression or a block as the body of each match arm.
// 8a433713e4c9c9810c327e9baf0d420f: Use 'if' expressions with optional 'else' branches for conditional control flow.
