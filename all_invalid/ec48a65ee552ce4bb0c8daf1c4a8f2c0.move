
//# publish
module 0xCAFE::ExpControl {
    /// This function simulates some compiler named experiments toggling.
    /// It accepts a vector of experiment settings as strings,
    /// where each entry is either "exp_name" to enable or "exp_name=on"/"exp_name=off" for explicit control.
    public fun configure_experiments(_exps: vector<vector<u8>>) {
        // This just mimics reading and toggling experiments by consuming the input vector.
    }

    // Simple public runner function with no arguments.
    public fun runner() {
        // Call configure_experiments twice with empty vectors to simulate on/off toggling.
        configure_experiments(vector<vector<u8>>[]);
        configure_experiments(vector<vector<u8>>[vector::empty()]);
        configure_experiments(vector<vector<u8>>[vector::singleton(b"feature_x=on")]);
    }
}



//# run 0xCAFE::ExpControl::runner



//# publish
module 0xCAFE::SpecTests {
    /// Sample struct to test specification language.
    struct SpecStruct has store {
        dummy: u8,
    }

    /// A function illustrating various specification conditions.
    public fun spec_func(x: u8): u8 {
        spec {
            // Precondition must be less than 100
            requires x < 100;
            // Ensure result is greater than input
            ensures(result > x);
            // Function must not abort
            aborts_if(false);
            // If aborting, abort code must be 42
            aborts_with(42);
            // Indicating memory locations modified (none in this example)
            modifies(());
            // Emits event? no actually here false
            emits(false);
            // Decreasing measure for termination checker
            decreases(x);
            // Assert some invariant in spec
            assert(x != 0);
            // Assume an expression for speculation
            assume(x < 200);
            // Succeeds_if with no condition (just true)
            succeeds_if(true);
        };
        x + 1
    }

    public fun run() {
        let _ = spec_func(5u8);
    }
}



//# run 0xCAFE::SpecTests::run



//# publish
module 0xCAFE::TokenMatcher {
    /// Simulated token enum for matching test.
    enum Token has copy, drop {
        Identifier,
        Number,
        Symbol(char),
    }

    /// Returns true if the input token equals the specified token without advancing any state.
    public fun is_token_eq(tok: Token, target: Token): bool {
        match tok {
            Token::Identifier => {
                match target {
                    Token::Identifier => true,
                    _ => false,
                }
            },
            Token::Number => {
                match target {
                    Token::Number => true,
                    _ => false,
                }
            },
            Token::Symbol(c1) => {
                match target {
                    Token::Symbol(c2) => c1 == c2,
                    _ => false,
                }
            },
        }
    }

    /// Runner function to test some token match cases
    public fun run() {
        let t1 = Token::Identifier;
        let t2 = Token::Identifier;
        let eq1 = is_token_eq(t1, t2);

        let t3 = Token::Symbol('x');
        let t4 = Token::Symbol('y');
        let eq2 = is_token_eq(t3, t4);

        let t5 = Token::Number;
        let eq3 = is_token_eq(t5, t5);
    }
}



//# run 0xCAFE::TokenMatcher::run
