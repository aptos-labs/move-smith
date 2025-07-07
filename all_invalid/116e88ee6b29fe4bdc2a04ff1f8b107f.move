// #publish
module 0xCAFE::Module1 {
    use std::vector;

    // A helper function to demonstrate loop over a range and attempt to reassign the loop variable.
    public fun loop_with_reassignment() {
        let mut sum = 0u64;
        let mut i = 0u64;
        // loop over range 0..10
        while (i < 10) {
            // Attempt to reassign the loop variable 'i' inside the loop body.
            // i = i + 1; -- Actually we need this for the loop, but let's also try to reassign 'i' inside the body incorrectly to check if disallowed.
            // NOTE: Unlike in for loops variable is mutable, so reassigning is allowed. So to test the compiler behavior for 'for' loops and reassign within the loop variable,
            // we will do a for loop next where reassignment of the loop variable should be disallowed.

            sum = sum + i;
            i = i + 1; // increment loop variable explicitly
        }
    }

    // A for loop example where the loop variable is immutable and reassigning it inside the loop is disallowed by compiler.
    public fun for_loop_with_reassignment() {
        let mut sum = 0u64;

        for i in 0..10 {
            // Trying to reassign the loop variable i should cause a compiler error.
            // Uncommenting below line should cause compilation error:
            // i = i + 1;

            sum = sum + i;
        }
    }

    // A runner function that calls the above functions without args.
    public fun run() {
        loop_with_reassignment();
        for_loop_with_reassignment();
    }
}
// #run 0xCAFE::Module1::run

// #publish
module 0xCAFE::Module2 {
    // We'll define 'exp_' function and 'exps' that transforms a vector of expressions (here simulated as u8 values)
    // into some other form applying exp_ on each element.

    // Since Move does not have higher order funcs or native "expression" types,
    // we simulate expr with u8 and exp_ returns u8 squared.

    public fun exp_(x: u8): u8 {
        x * x
    }

    // transform each element in the vector by applying exp_ function
    public fun exps(xs: vector<u8>): vector<u8> {
        let len = vector::length(&xs);
        let mut result = vector::empty<u8>();
        let mut i = 0;
        while (i < len) {
            let val = *vector::borrow(&xs, i);
            let r = exp_(val);
            vector::push_back(&mut result, r);
            i = i + 1;
        }
        result
    }

    // A runner function that calls exps with example input and stores result in a local (no assertions)
    public fun run() {
        let input = vector::from_bytes(vec[1, 2, 3, 4]);
        let _output = exps(input);
    }
}
// #run 0xCAFE::Module2::run

// #run 0xCAFE::Module2::exp_ --args 5u8
// #run 0xCAFE::Module2::exps --args vector<u8>[1u8 2u8 3u8]

// #run
script {
    use 0xCAFE::Module1;
    use 0xCAFE::Module2;

    fun main() {
        // Call run functions from both modules in this script context.
        Module1::run();
        Module2::run();

        // Call exp_ and exps with arguments
        let single_exp = Module2::exp_(7);
        let input = vector::from_bytes(vec[5, 6, 7]);
        let multiple_exp = Module2::exps(input);
    }
}

// Featurres:
// d0de8b446e4cbd6ab135f28da19f5934: Test that the loop correctly executes with a range and that reassigning the loop variable within the loop body is disallowed or handled as expected.
// d0f45a8325cce9350e8c9b2b6b3cb0c2: Define a script block in your Move code using the 'script' keyword and curly braces.
// e4f4fb756ae16b178004ed92b279c472: Use the 'exps' function to transform a list of Move expressions into another form, applying the 'exp_' function to each expression within a compiler context.
