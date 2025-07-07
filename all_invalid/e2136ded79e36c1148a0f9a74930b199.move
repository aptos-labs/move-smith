
//# publish
module 0xCAFE::SpecFeatures {
    spec module {
        // Fixed: spec variables must be declared with '=' initialization
        let module_spec_var = 0u64;

        global let global_spec_var = 0u64;

        // specification function with local spec variables declared using 'let'
        public spec fun spec_with_local_vars() {
            let local_var1 = 1u64;
            let local_var2 = 2u64;
            let swap_result = SpecFeatures::swap_u64(local_var1, local_var2);
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
        // The tuple must be unpacked to separate variables: x and y
        let (x, y) = SpecFeatures::swap_u64(100u64, 200u64);
        // Just to avoid unused variable warnings
        let _ = (x, y);
    }
}
