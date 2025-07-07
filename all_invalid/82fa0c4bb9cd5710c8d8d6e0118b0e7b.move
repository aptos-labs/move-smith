
//# publish
module 0xCAFE::ExprScopeTest {
    use std::debug;
    
    struct Container has copy, drop, store {
        value: u8,
    }
    
    public fun test_block_and_scope(mut x: u8): u8 {
        // Outer scope x = input
        let r = {
            // Start new block scope
            let y = 5u8;
            let z = {
                // Nested block scope with pattern matching tuple
                let (a, b) = (2u8, 3u8);
                a + b + y
            };
            x = x + z; // modifies outer x captured mutable
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
        let v = (Option::some(10u8), Vector::empty<u8>());
        let result = {
            let (opt, vec) = v;
            // shadow opt with pattern inside block
            let res = match opt {
                Option::Some(value) => value + 20,
                Option::None => 0,
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
    
    //
    // current_token_error_string mimicking (dummy function)
    // In real, this would give tokenizer state string, here return "EOF" or token content
    //
    public fun current_token_error_string(flag: bool): vector<u8> {
        if (flag) {
            b"EOF"
        } else {
            b"token_content"
        }
    }

    //
    // return_assignable_list -- given a vector of expressions return list of assignable values as strings
    //
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


//# run 0xCAFE::ExprScopeTest::test_block_and_scope --args 7u8


//# run 0xCAFE::ExprScopeTest::test_block_with_shadowing --args 2u8


//# run 0xCAFE::ExprScopeTest::test_nested_pattern_scope


//# run 0xCAFE::ExprScopeTest::runner


//# run 0xCAFE::ExprScopeTest::current_token_error_string --args true


//# run 0xCAFE::ExprScopeTest::current_token_error_string --args false


//# run 0xCAFE::ExprScopeTest::return_assignable_list


// Featurres:
// b8a9c1c10b3e492d4bf690d9499d4e07: Use block expressions with let-bindings and pattern matching that can introduce new variable scopes and potentially modify variables within those scopes.
// b29c72198884fefb396e2c4448d83464: Use 'current_token_error_string' to get a descriptive string for the current tokenizer state, indicating either an end-of-file or the specific token content.
// 732f16fe4f57a883619d9f7446b37d19: Return a list of assignable values for expressions that are lists of expressions.
