
//# publish
module 0xCAFE::SpecFeatures {
    spec module {
        let module_spec_var: u64;

        global let global_spec_var: u64;

        // specification function with local spec variables declared using 'let'
        public spec fun spec_with_local_vars() {
            let local_var1: u64 = 1;
            let local_var2: u64 = 2;
            let swap_result: (u64, u64) = SpecFeatures::swap_u64(local_var1, local_var2);
        }

        public spec fun spec_with_global_var() {
            let value = SpecFeatures::global_spec_var;
        }
    }

    public fun swap_u64(a: u64, b: u64): (u64, u64) {
        (b, a)
    }
}


//# run
script {
    use 0xCAFE::SpecFeatures;

    fun main() {
        // test importing module in script with use declaration
        let (x, y) = SpecFeatures::swap_u64(100u64, 200u64);
        // The tuples must be unpacked to separate variables: x and y
    }
}


// Featurres:
// 8d5ef7e27d52e3b26a30d42a9ce89d91: Declare specification local variables using the 'let', 'global', or 'local' keywords within spec blocks.
// b734fce120b912d4adf3ea9b0f3ca979: Include 'use' declarations inside your script to import modules or symbols.
// f9da88c6c81c8d4842f9cfc49e241d70: Test swapping two u64 values and returning them as a tuple from a function.
