
//# publish
module 0xCAFE::PatternAndLambda {
    use std::vector;

    struct Point has copy, drop, store {
        x: u8,
        y: u8,
        z: u8,
    }

    // Function to demonstrate '..' pattern in match and let bindings
    public fun test_rest_pattern(p: Point): u8 {
        // match with '..' to ignore some fields
        let v = match p {
            Point { x, .. } => x,
        };
        // let with '..' to ignore some fields
        let Point { y, .. } = p;
        let sum = v + y;
        sum
    }

    fun internal_func(a: u8): u8 {
        a + 10
    }

    // This function is deliberately non-inline and non-native
    public fun non_inline_func(x: u8): u8 {
        internal_func(x)
    }

    // A function that returns a lambda
    public fun get_lambda(): |u8|u8 {
        let lambda = |a: u8| {
            non_inline_func(a)
        };
        lambda
    }

    // Runner function that calls internal and returns a u8
    public fun runner(): u8 {
        let p = Point {x: 5, y: 6, z: 7};
        let a = test_rest_pattern(p);
        let lambda = get_lambda();
        let b = lambda(15);
        a + b
    }
}


//# run 0xCAFE::PatternAndLambda::test_rest_pattern --args 0xCAFE::PatternAndLambda::Point{ x: 3u8, y: 4u8, z: 5u8 }


//# run 0xCAFE::PatternAndLambda::non_inline_func --args 7u8


//# run 0xCAFE::PatternAndLambda::get_lambda


//# run 0xCAFE::PatternAndLambda::runner


// Featurres:
// 028ba79c0d2d6550c16b84253f99819a: Use '..' patterns in Move code to match an unspecified or rest pattern in bindings.
// 127be41d1292e2b7160dfeeb0a5424e2: Include and filter 'use' declarations within a script.
// c95695c0ff82b3531a77db7eb90d92df: Support lambda lifting for non-inline, non-native, non-intrinsic functions within target modules.
