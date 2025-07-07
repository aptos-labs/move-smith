
//# publish
module 0xCAFE::ContinueAndQuantifier {
    // Test 1: Labeled continue statements in nested while loops
    public fun labeled_continue_example() {
        let outer_counter = 0u8;
        let _inner_counter;

        'outer_loop: while (outer_counter < 3) {
            let inner_counter = 0u8;
            while (inner_counter < 5) {
                if (inner_counter == 2) {
                    outer_counter = outer_counter + 1;
                    continue 'outer_loop;
                };
                inner_counter = inner_counter + 1;
            };
            outer_counter = outer_counter + 1;
            _inner_counter = inner_counter; // to silence unused variable warning
        };
    }

    // Test 2: Quantifiers binding a variable to a type domain using colon
    fun example_quantifier<T>() {
        let _x: T; 
        // The variable `_x` is declared with a generic type parameter T.
        // We won't initialize or use _x here, since this is a compile-time test of quantifier syntax.
    }

    // Test 3: Define and use script in Move module
    public entry fun run_script() {
        let x: u8 = 42;
        let y = 43u8;
        let z = x + y;
        let _ = z;
        // dummy usage to silence unused variable warning
    }
}



//# run 0xCAFE::ContinueAndQuantifier::labeled_continue_example



//# run 0xCAFE::ContinueAndQuantifier::example_quantifier<u8>



//# run 0xCAFE::ContinueAndQuantifier::run_script


// Features:
// 18bc541ddf8fce19e1e0c056f6446e14: Test that labeled continue statements in nested while loops correctly jump to the appropriate labeled loop in Move.
// e5444ec3cf73e7458eb767d479217dd2: Write quantifiers that bind a variable to a type domain using a colon to specify the type, as in 'x: T'.
// 6994dad09f324b160b16e661e17ce3e7: Define and use scripts in your Move modules.
