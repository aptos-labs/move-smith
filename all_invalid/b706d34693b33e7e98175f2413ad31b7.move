
//# publish
module 0xCAFE::BlockExpressionTest {
    use std::vector;

    // A simple function that returns u8
    public fun identity(x: u8): u8 {
        x
    }

    // This function tests block expressions in arguments and expressions body
    public fun block_in_argument_and_body(x: u8): u8 {
        // Block expression as argument, with assignments inside the block
        let y = identity({
            let z = x;
            z = z + 1;
            z = z * 2;
            z
        });
        // Another block in function body: increments y and returns final value without semicolon
        {
            let w = y / 2;
            w + 1
        }
    }

    // This function returns a tuple using block expressions where last expression is returned without semicolon
    public fun block_tuple_return(x: u8): (u8, u8) {
        let a = {
            let b = x + 10;
            b * 2
        };
        let c = {
            let d = x + 20;
            d * 3
        };
        (a, c)
    }

    // This function uses 'choose' quantifier to choose a u8 value greater than 100 and less than 130
    public fun choose_value(): u8 {
        choose val in 101..130 {
            val % 2 == 1
        }
    }

    // A runner function to test multiple features without arguments
    public fun runner(): (u8, u8) {
        let val = block_in_argument_and_body(5u8);
        let (a, b) = block_tuple_return(val);
        (a, b)
    }
}



//# run 0xCAFE::BlockExpressionTest::block_in_argument_and_body --args 7u8


//# run 0xCAFE::BlockExpressionTest::block_tuple_return --args 8u8


//# run 0xCAFE::BlockExpressionTest::choose_value


//# run 0xCAFE::BlockExpressionTest::runner


// Featurres:
// 50f685f669ac3fea09867583a94ace9d: Test that block expressions with assignments and side effects are correctly evaluated in function arguments and expression bodies.
// 4b1e2b46aabc7fb4cadc6b955a2b1035: Write code blocks where the final expression is allowed without a trailing semicolon to return its value.
// 5edb1d8435eca69454744134ffaee6e9: Use 'choose' quantifiers to select a value satisfying a given condition.
