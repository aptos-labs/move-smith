
//# publish
module 0xCAFE::LoopLabels {
    public fun labeled_continue_example(): u8 {
        let outer_counter = 0u8;
        let inner_counter = 0u8;
        let result = 0u8;
        'outer_while: while (outer_counter < 3) {
            'inner_while: while (inner_counter < 5) {
                inner_counter = inner_counter + 1;
                if (inner_counter == 3) {
                    // continue to outer labeled loop when inner_counter is 3 
                    continue 'outer_while;
                };
                result = result + 1; // increments when inner_counter != 3
            };
            outer_counter = outer_counter + 1;
            inner_counter = 0;
        };

        // result should reflect increments except at inner_counter 3 where it continued to outer loop
        result
    }

    public fun while_loop_variable_ret(): u8 {
        let x = 0u8;
        while (x < 5) {
            x = x + 1;
        };
        // x should be 5 here, after the loop finishes
        x
    }
}


//# run 0xCAFE::LoopLabels::labeled_continue_example


//# run 0xCAFE::LoopLabels::while_loop_variable_ret


//# publish(language_version = 6)
module 0xCAFE::LangVersionTest {
    public fun lang_version_function(): u8 {
        42u8
    }
}


//# run 0xCAFE::LangVersionTest::lang_version_function


// Featurres:
// 18bc541ddf8fce19e1e0c056f6446e14: Test that labeled continue statements in nested while loops correctly jump to the appropriate labeled loop in Move.
// a4128e2ba6ab35bdb3bff531d7a2f912: Specify language versions for compiling your Move code to control feature support.
// e6841562ee50111c0389b0465ca3c5c9: Test that the value assigned to a local variable inside a while loop is correctly available after the loop completes.
