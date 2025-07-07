//# publish
module 0xCAFE::VisibilityAndSpec {
    use std::vector;

    struct Data has store {
        value: u64
    }

    // public function, can be called by any code within or outside module
    public fun set_value(value: u64): Data {
        Data { value }
    }

    // private function, only callable within the module
    fun incr_value(data: &mut Data) {
        data.value = data.value + 1;
    }

    // entry function to be called as an entry point in a transaction
    entry fun entry_incr(data: &mut Data) {
        incr_value(data);
    }

    // deprecated function, mark as deprecated to test compiler handling of deprecated visibility
    #[deprecated]
    public fun deprecated_func(): u8 {
        42u8
    }

    // Spec-only module declared within this module - the compiler should handle it distinctly
    spec module {
        invariant [1] (forall d: Data :: d.value >= 0);
        function spec_fun(): bool;
    }
    
    spec fun spec_fun(): bool {
        true
    }
}

//# run 0xCAFE::VisibilityAndSpec::deprecated_func

//# run 0xCAFE::VisibilityAndSpec::entry_incr

//# run
script {
    use 0xCAFE::VisibilityAndSpec;

    #[inline(always)]
    fun main() {
        let mut data = VisibilityAndSpec::set_value(10u64);
        VisibilityAndSpec::entry_incr(&mut data);
    }
}

// Featurres:
// 8c25b2fe5f739e1b5083239e0d6df363: Define a script with attributes and use declarations.
// 77fd16c7d6ef9e1e8e0b07ecad6da90a: Declare a function with optional public, entry, or deprecated script visibility modifiers.
// 89f8f5a5053fd2c4219f777ba327bfd5: Define specification-only modules within normal Move modules or address blocks and have them handled distinctly by the compiler.
