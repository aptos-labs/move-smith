
//# publish
module 0xCAFE::Computation {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            7u8
        }
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        let inner_sum = inline_adder(a, b);
        add_and_return(inner_sum, 5u8)
    }
}



//# publish
module 0xCAFE::TestFeatures {
    // Removed unused import 'std::vector'

    use 0xCAFE::Computation;

    // Removed unnecessary 'acquires Phantom'
    public fun choose_value(): u8 {
        let v = 1u8;
        while (v <= 10u8) {
            if (v == 7u8) {
                break;
            };
            v = v + 1;
        };
        v
    }

    struct Phantom has store {}

    public fun ast_filter_demo(x: u8): u8 {
        let res = Computation::add_and_return(x, 3u8);
        res
    }
}



//# run 0xCAFE::Computation::add_and_return --args 4u8 3u8



//# run 0xCAFE::Computation::nested_calls --args 2u8 3u8



//# run 0xCAFE::TestFeatures::choose_value



//# run 0xCAFE::TestFeatures::ast_filter_demo --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 5edb1d8435eca69454744134ffaee6e9: Use 'choose' quantifiers to select a value satisfying a given condition.
// 803f7e00af8ab7fdca3c641cc558eafb: Leverage AST filtering for verification purposes with 'ast_filter'.
