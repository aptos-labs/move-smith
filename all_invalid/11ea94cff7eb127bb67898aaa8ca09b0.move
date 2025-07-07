//# publish
module 0xCAFE::DeadCodeMatchStructTest {
    struct AnnotatedStruct has store {
        val: u64,
        flag: bool,
    }

    public fun dead_code_else_loop(x: u8): u8 {
        if (x < 3) {
            let mut counter = 0;
            loop {
                if (counter == x) {
                    break;
                };
                counter = counter + 1;
            };
            42u8
        } else {
            // dead code that should not error or be executed
            let mut dead_counter = 0;
            loop {
                dead_counter = dead_counter + 1;
                if (dead_counter > 10) {
                    break;
                };
            };
            0u8
        };
    }

    public fun match_value(x: u8): u8 {
        match (x) {
            0 => 10,
            1 => 20,
            2 => 30,
            _ => 40,
        }
    }

    public fun create_annotated_struct(val: u64, flag: bool): AnnotatedStruct {
        AnnotatedStruct {val, flag}
    }
}

//# run 0xCAFE::DeadCodeMatchStructTest::dead_code_else_loop --args 2u8

//# run 0xCAFE::DeadCodeMatchStructTest::dead_code_else_loop --args 5u8

//# run 0xCAFE::DeadCodeMatchStructTest::match_value --args 0u8

//# run 0xCAFE::DeadCodeMatchStructTest::match_value --args 3u8

//# run 0xCAFE::DeadCodeMatchStructTest::create_annotated_struct --args 123456u64 true

// Featurres:
// e51a13f151c79b9b3b0d4ad12d73a0c0: Test that dead code in the else branch after a conditional with a loop and break does not affect execution or cause errors.
// 3f59cfdd493ab80f28bf33bd8d131657: Use `match` expressions with pattern arms for value matching.
// c2361614d8d86136ea1e6665a21ea40d: Define a field with an explicit type annotation in a Move struct
