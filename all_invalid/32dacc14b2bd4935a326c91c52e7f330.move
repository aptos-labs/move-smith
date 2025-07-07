
//# publish
module 0xCAFE::VectorFunctionTest {
    // No need to import std::vector if not used explicitly
    // Use vector literals (built-in language feature) as below

    // Function that returns an empty vector<u8> using the vector literal expression
    public fun empty_vector_u8(): vector<u8> {
        vector[]
    }

    // Function that returns a vector<u64> with elements given
    public fun vector_u64_with_elements(): vector<u64> {
        vector[10u64, 20u64, 30u64]
    }

    // Function that returns a vector<vector<bool>>, nested vectors with elements
    public fun nested_vectors_bool(): vector<vector<bool>> {
        vector[
            vector[true, false],
            vector[false, false, true],
            vector[]
        ]
    }

    // Function type taking an u8 and returning a reference to u8 to a local value
    // To fix errors, we must return references to values inside the function, 
    // so change function signature and return references properly

    // Since returning references to local variables is not allowed,
    // we must rewrite apply_function to return u8 directly (no referencing dereferencing needed).
    public fun apply_function(f: |u8| u8, x: u8): u8 {
        f(x)
    }

    // Similarly fix apply_higher_order:
    // apply_higher_order takes a function f that takes a function and u8 and returns u8,
    // and a function g that takes u8 returns u8, and an input x: u8
    public fun apply_higher_order(
        f: |(|u8| u8, u8)| u8,
        g: |u8| u8,
        x: u8,
    ): u8 {
        f(g, x)
    }

    // Runner function - returns sum of applying functions
    public fun runner(): u8 {
        // Declare lambdas as function values (no referencing)
        let inc = |a: u8| -> u8 {
            a + 1u8
        };
        let dec = |a: u8| -> u8 {
            a - 1u8
        };

        let use_inc = apply_function(inc, 5u8);
        let use_dec = apply_function(dec, 6u8);

        let hof = |func: |u8| u8, val: u8| -> u8 {
            let v1 = func(val);
            let v2 = func(v1);
            v2
        };

        let use_hof = apply_higher_order(hof, inc, 4u8);
        use_inc + use_dec + use_hof
    }
}
