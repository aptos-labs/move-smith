
//# publish
module 0xCAFE::SpecFeatures {
    spec module {
        // Fixed: spec variables must be declared with '=' initialization
        let module_spec_var = 0u64;

        // global variables in spec use 'let' without 'global' keyword
        let global_spec_var = 0u64;

        // specification function with local spec variables declared using 'let'
        public spec fun spec_with_local_vars() {
            let local_var1 = 1u64;
            let local_var2 = 2u64;
            let swap_result = SpecFeatures::swap_u64(local_var1, local_var2);
        }

        public spec fun spec_with_global_var() {
            let value = global_spec_var;
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
        let (x, y) = SpecFeatures::swap_u64(100u64, 200u64);
        let _ = (x, y);
    }
}
