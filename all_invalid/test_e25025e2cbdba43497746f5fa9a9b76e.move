//# publish
module 0x1::test_mod {
    public fun nested_mutation(): u64 {
        let result = {
            let a = 10;
            let b = 20;
            let c = {
                let mut x = a;
                let mut y = b;
                // nested block updating x and y
                {
                    x = x + 5;
                    y = y + 10;
                }
                // return sum inside nested block
                x + y
            };
            c + a + b
        };
        result
    }

    public fun complex_boolean_expression(): bool {
        let condition1 = (false || true) && !(false && false);
        let condition2 = !(true || false) && (false || true);
        let condition3 = !((true && false) || !(false) && (true || false));
        // combine conditions in a complex expression
        condition1 || condition2 && condition3
    }

    public fun run_tests() {
        assert!(nested_mutation() == 65 + 10 + 20, 42);
        assert!(complex_boolean_expression() == true, 42);
    }
}

//# run 0x1::test_mod::run_tests