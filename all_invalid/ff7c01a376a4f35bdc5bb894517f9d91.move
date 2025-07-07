// #publish
module 0xCAFE::ConstantsModule {
    // Define some constants
    const CONST_U8: u8 = 42;
    const CONST_U64: u64 = 100000;
    const CONST_BOOL: bool = true;

    // A function that returns all constants as a tuple
    public fun get_constants(): (u8, u64, bool) {
        (CONST_U8, CONST_U64, CONST_BOOL)
    }

    // Runner function to call get_constants without arguments.
    public fun runner() {
        let (a, b, c) = get_constants();
        // no assertions needed, just exit
        a;
        b;
        c;
    }
}
// #run 0xCAFE::ConstantsModule::runner

// #publish
module 0xBEEF::ImportModule {
    use 0xCAFE::ConstantsModule;

    // Function that uses imported constants via function call from ConstantsModule
    public fun imported_constants_sum(): u64 {
        let (a, b, c) = ConstantsModule::get_constants();
        // sum the constants converting booleans to u64 (true = 1u64)
        (a as u64) + b + (if c { 1u64 } else { 0u64 })
    }

    // Runner function with no arguments
    public fun runner() {
        let sum = imported_constants_sum();
        sum;
    }
}
// #run 0xBEEF::ImportModule::runner

// #run
script {
    use 0xCAFE::ConstantsModule;
    use 0xBEEF::ImportModule;

    fun main() {
        // Test direct constants access through function and tuple unpacking
        let (a, b, c) = ConstantsModule::get_constants();
        // Validate sum via imported module call
        let sum = ImportModule::imported_constants_sum();

        // Use 'move' expression without parentheses to test syntax
        let x = move a;
        let y = move b;
        let z = move c;

        // Use the moved values to prevent compiler warnings (no drop by default for primitives)
        let _final_sum = (x as u64) + y + (if z { 1u64 } else { 0u64 });
    }
}

// Featurres:
// 646d4127a24c340b4a97e5cc7f22b5a9: Define constants with specific names and values in Move modules.
// aacd56972f7e4e045bc5c19edbe18a00: Resolve and import modules with named address prefixes, provided the mapping for the address exists in your project configuration.
// 50e09f80f0a5d1443ce0a870cdae8efb: Replace 'move(x)' with 'move x' in Move code to improve syntax.
