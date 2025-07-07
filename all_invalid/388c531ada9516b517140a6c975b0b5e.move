// Remove the invalid nested module inside a module and fix the stray braces

// Spec-only module must be a top-level module at its own address or anonymous address
// Here we move SpecOnlyModule out and place it at an anonymous address (or define an address)

address 0x1 {
    
        // Specification-only module content
        constant SPEC_CONST: u64 = 1000;
        invariant SPEC_CONST > 0;
    }
}

address 0xFEED {
    
//# publish
    module M1 {
        public fun greet(): vector<u8> {
            b"Hello from 0xFEED::M1"
        }
    }
}

address 0xBEEF {
    
//# publish
    module M2 {
        public fun greet(): vector<u8> {
            b"Hello from 0xBEEF::M2"
        }
    }
}

address 0xDEAD {
    
//# publish
    module M3 {
        public fun greet(): vector<u8> {
            b"Hello from 0xDEAD::M3"
        }
    }
}

address 0xCAFE {
    
//# publish
    module Caller {
        use 0xFEED::M1;
        use 0xBEEF::M2;
        use 0xDEAD::M3;

        public fun call_greetings(): vector<vector<u8>> {
            vector[
                M1::greet(),
                M2::greet(),
                M3::greet()
            ]
        }
    }
}


//# run
script {
    use 0xCAFE::Caller;

    fun main() {
        let greetings = Caller::call_greetings();
        // Do nothing with greetings, just execute calls
    }
}


//# run 0xCAFE::Caller::call_greetings

address 0xF00D {
    
//# publish
    module NormalModule {
        struct Data has store {
            val: u64
        }

        public fun new_data(v: u64): Data {
            Data { val: v }
        }

        public fun get_val(d: &Data): u64 {
            d.val
        }
    }
    spec module NormalModule {
        constant SPEC_ONLY_VALUE: u64 = 42;

        // Specification-only function
        spec fun spec_fun(v: u64): u64 {
            v * 2
        }

        // An invariant that all Data values have val > 0
        invariant forall d: &NormalModule::Data { NormalModule::get_val(d) > 0 }
    }
}


//# run
script {
    use 0xF00D::NormalModule;

    fun main() {
        let d = NormalModule::new_data(10);
        let v = NormalModule::get_val(&d);
        // run with valid data
    }
}
