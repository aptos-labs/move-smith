
//# publish
module 0xCAFE::AssignmentAndPattern {
    // This module tests assignment expressions with left-values and destructuring patterns,
    // as well as the removal of inline functions after inlining.

    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    // Inline function that returns a tuple, to be inlined and then removed by the compiler
    public inline fun inline_add_mul(x: u8, y: u8): (u8, u8) {
        (x + y, x * y)
    }

    // Function demonstrating assignment expressions with left-value (mutable variable)
    public fun assign_example(mut_x: u8, mut_y: u8): u8 {
        let a = mut_x;
        let b = mut_y;

        // Direct assignment expressions
        a = a + 5;
        b = b * 2;

        // Return sum
        a + b
    }

    // Function demonstrating destructuring pattern in let binding and parameters
    public fun destructuring_example(p: Pair): u8 {
        // Destructure in let binding
        let Pair { a, b } = p;

        // Destructure in a for loop tuple
        let v = vector[(a, b), (b, a)];
        let sum = 0u8;
        for ((x, y) in v) {
            sum = sum + x + y;
        };

        sum
    }

    // Inline function that returns a Pair, will be inlined and removed
    public inline fun create_pair(x: u8, y: u8): Pair {
        Pair { a: x, b: y }
    }

    // Runner function to call assign_example and destructuring_example
    public fun runner(): u8 {
        let (sum1, sum2) = (assign_example(3, 4), destructuring_example(create_pair(2, 5)));
        sum1 + sum2
    }
}


//# run 0xCAFE::AssignmentAndPattern::assign_example --args 7u8 3u8


//# run 0xCAFE::AssignmentAndPattern::destructuring_example --args 0xCAFE::AssignmentAndPattern::Pair { a: 5u8, b: 8u8 }


//# run 0xCAFE::AssignmentAndPattern::runner


// Featurres:
// c2690b9c0a9fa1771bbd371be5f3e8e0: Create assignment expressions with left-value and right-value.
// fbf6d074e8b73bdc6cd6271ed135c831: Bind variables to names in patterns using de-structuring assignments in let bindings or function parameters.
// 4957c6b77b94890bc1f8b09f0feac0e4: Remove inline functions from the program after inlining to reduce code size and prevent codegen issues.
