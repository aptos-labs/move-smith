//# publish
module 0xCAFE::PatternMatch {

    // Define an enum with abilities and generics
    public enum Option<T> has copy, drop, store {
        None,
        Some(T),
    }

    // Define another enum with nested enum and abilities
    public enum Result<T, E> has copy, drop, store {
        Ok(T),
        Err(E),
    }

    // Struct to test reference match with ability
    struct Wrapper has key {
        value: u64,
    }

    // A function to test match with multiple arms including pattern guards and nested enums
    public fun match_option(opt: Option<u8>): u8 {
        match opt {
            Option::None => 0,
            Option::Some(x) if x > 10 => 100,
            Option::Some(x) => x,
        }
    }

    public fun match_result(res: Result<u64, bool>): u64 {
        match res {
            Result::Ok(v) => v,
            Result::Err(true) => 999,
            Result::Err(false) => 0,
        }
    }

    public fun match_wrapper_ref(wrapper_ref: &Wrapper): u64 {
        match wrapper_ref {
            &Wrapper { value } if value > 50 => 50,
            &Wrapper { value } => value,
        }
    }

    // Function that nests pattern matching with generics and enum variants
    public fun nested_match(opt: Option<Result<u8, bool>>): u8 {
        match opt {
            Option::None => 0,
            Option::Some(Result::Ok(v)) => v,
            Option::Some(Result::Err(true)) => 1,
            Option::Some(Result::Err(false)) => 2,
        }
    }

    // Runner function to exercise all above functions without arguments (with internal calls)
    public fun runner(): u8 {
        let val1 = match_option(Option::None);
        let val2 = match_option(Option::Some(5));
        let val3 = match_option(Option::Some(20));
        let val4 = match_result(Result::Ok(123));
        let val5 = match_result(Result::Err(true));
        let val6 = match_result(Result::Err(false));
        let wrapper = Wrapper { value: 30 };
        let val7 = match_wrapper_ref(&wrapper);
        let wrapper2 = Wrapper { value: 80 };
        let val8 = match_wrapper_ref(&wrapper2);
        let val9 = nested_match(Option::None);
        let val10 = nested_match(Option::Some(Result::Ok(7)));
        let val11 = nested_match(Option::Some(Result::Err(true)));
        let val12 = nested_match(Option::Some(Result::Err(false)));

        val1 + val2 + val3 + val4 + val5 + val6 + val7 + val8 + val9 + val10 + val11 + val12
    }

    spec module {
        // Using spec block with let bindings to test bindings in specs
        fun runner_spec() {
            let o1 = Option::Some(42);
            let res1 = match_option(o1);
            let expected: u8 = 42;
            // normal spec, no assert needed as per instructions

            let w = Wrapper { value: 99 };
            let w_ref = &w;
            let match_val = match_wrapper_ref(w_ref);
            let expected_val = 50;

            let nested = Option::Some(Result::Err(true));
            let nested_val = nested_match(nested);
            let expected_nested = 1;
        }
    }
}
//# run 0xCAFE::PatternMatch::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::PatternMatch;

    fun main() {
        let ret = PatternMatch::runner();
        // no assertions needed
    }
}

// Featurres:
// d0ec17a6fc0c2d88253ae1421a56465b: Write match expressions with multiple arms in your Move code.
// d8c9ee3b39f9145b5a4991ceb4b01bd9: Bind values using 'let' declarations in spec blocks for verification purposes
// 80d7e2978ba5552ff7ed4935f17c6caa: Verify that pattern matching, including nested, conditional, reference, and enum variants with abilities and generics, correctly handles various data structures and control flows in Move modules.
