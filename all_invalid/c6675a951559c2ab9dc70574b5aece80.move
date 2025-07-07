
//# publish
module 0xCAFE::InlineSpecTest {
    spec for_inline {
        inline_spec_fun(): u64 {
            999
        }

        // A spec function with a local variable update inside an expression block
        inline_spec_fun_update(): u64 {
            let x = 0u64;
            {
                let x = x + 42u64;
                x
            } + {
                let x = 10u64;
                x + 1u64
            }
        }

        // A spec function with imperative expressions that is expected to be excluded from verification
        inline_spec_fun_imperative() {
            let x = 1u64;
            while (x < 5u64) {
                x = x + 1u64;
            };
            // Note: This function does not return a value and uses imperative expressions
        }
    }

    public fun runner() {
        let _ = inline_spec_fun();
        let _ = inline_spec_fun_update();
        // Call inline_spec_fun_imperative in specs is not executable, but we call here for compilation coverage
    }
}


//# run 0xCAFE::InlineSpecTest::runner


// Featurres:
// 0826263e309bbe8ed6cee2b0c62077ac: Create inline specification functions by setting the 'for_inline' parameter, resulting in functions with 'inline_' prefix in their names.
// a2acc1502b08da208d2d08e4984609c4: Test that local variable updates within expression blocks are correctly evaluated and used in subsequent expressions, ensuring proper handling of state changes in nested blocks.
// a6e10024aa543c46926e5bc7a36747d7: Rely on the compiler to mark spec functions containing imperative expressions as uninterpreted, so they are excluded from certain verification analyses.
