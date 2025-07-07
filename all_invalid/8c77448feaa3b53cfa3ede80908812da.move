
//# publish
module 0xCAFE::SpecFeatures {
    spec module {
        // Fixed: spec variables must be declared with '=' initialization
        let module_spec_var: u64 = 0;

        global let global_spec_var: u64 = 0;

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
        // The tuple must be unpacked to separate variables: x and y
        let (x, y) = SpecFeatures::swap_u64(100u64, 200u64);
        // Just to avoid unused variable warnings
        let _ = (x, y);
    }
}
