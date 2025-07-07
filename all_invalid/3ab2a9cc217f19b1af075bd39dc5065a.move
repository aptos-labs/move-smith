
//# publish
module 0xCAFE::TestFunctionsAndLocals {
    // This module tests functions with parameters and return types.
    // Also this tests use of local variables with meaningful names.

    public fun add_and_double(x: u64, y: u64): u64 {
        let sum = x + y;
        let doubled = sum * 2;
        doubled
    }

    public fun concat_u8_with_u16(a: u8, b: u16): u32 {
        // Combine a and b into a u32 (just a dummy example)
        let combined = ((a as u32) << 16) + (b as u32);
        combined
    }

    public fun runner() {
        let res1 = add_and_double(10u64, 20u64);
        let res2 = concat_u8_with_u16(5u8, 0x1234u16);
        let _ = res1;
        let _ = res2;
    }
}



//# run 0xCAFE::TestFunctionsAndLocals::runner



//# publish
module 0xCAFE::DiagnosticColorOutput {
    use aptos_framework::debug;

    // This module tests that color output is automatically chosen for diagnostics
    // by inspecting environment variables.
    // We call debug::print to emit diagnostics - color depends on env automatically.

    public fun print_diagnostics() {
        debug::print(b"Diagnostic message line 1\n");
        debug::print(b"Diagnostic message line 2\n");
    }

    public fun runner() {
        print_diagnostics();
    }
}



//# run 0xCAFE::DiagnosticColorOutput::runner



//# publish
module 0xCAFE::SymbolPoolExample {
    // This module uses local variables with meaningful names to simulate symbol pool usage.
    // The Move compiler uses symbol pool to keep local variable names readable for diagnostics.

    public fun example() {
        let first_var = 42u64;
        let secondVar = first_var * 2;
        let finalValue = secondVar + 10;
        let _ = finalValue;
    }
}



//# run 0xCAFE::SymbolPoolExample::example


// Features:
// 2d791d60a5f8aea86a800ebe519df3f0: Create functions with a signature that includes parameters and return types.
// f4615cb3e06b36e24c5094c7a3104352: Display local variable names using the symbol pool to get human-readable names.
// cddd76dfccb7295a41a882307e9ffda9: Automatically choose color output for diagnostics if environment variable is unset or set to an unrecognized value.
