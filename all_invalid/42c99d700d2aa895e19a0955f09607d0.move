
//# publish
module 0xCAFE::ExprScopeTest {
    use std::option;
    use std::vector;

    struct Container has copy, drop, store {
        value: u8,
    }

    public fun test_block_and_scope(x_input: u8): u8 {
        let x = x_input;
        let r = {
            let y = 5u8;
            let z = {
                let (a, b) = (2u8, 3u8);
                a + b + y
            };
            let x = x + z;
            x * 2
        };
        r
    }

    public fun test_block_with_shadowing(x: u8): u8 {
        let x = {
            let x = x + 10;
            let (a, b) = (3u8, 4u8);
            a * b + x
        };
        x
    }

    public fun test_nested_pattern_scope(): u8 {
        let v = (option::some(10u8), vector::empty<u8>());
        let result = {
            let (opt, _vec) = v;
            let res = if (option::is_some(&opt)) {
                let value = option::borrow(&opt);
                *value + 20
            } else {
                0
            };
            res
        };
        result
    }

    public fun runner(): u8 {
        let a = 2u8;
        let _ = Self::test_block_and_scope(a);
        let b = Self::test_block_with_shadowing(5u8);
        let c = Self::test_nested_pattern_scope();
        b + c
    }

    public fun current_token_error_string(flag: bool): vector<u8> {
        if (flag) {
            b"EOF"
        } else {
            b"token_content"
        }
    }

    public fun return_assignable_list(): vector<vector<u8>> {
        let exprs = vector[
            b"x",
            b"y",
            b"vec[0]",
            b"struct.field",
            b"arr[2]",
        ];
        exprs
    }
}
