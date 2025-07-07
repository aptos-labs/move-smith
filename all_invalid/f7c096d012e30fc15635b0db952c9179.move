
//# publish
    module SpecOnlyModule {
        spec module {
            // Specification-only module content
            constant SPEC_CONST: u64 = 1000;
            invariant SPEC_CONST > 0;
        }
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
        spec module {
            constant SPEC_ONLY_VALUE: u64 = 42;

            // Specification-only function
            spec fun spec_fun(v: u64): u64 {
                v * 2
            }

            // An invariant that all Data values have val > 0
            invariant forall d: &NormalModule::Data { NormalModule::get_val(d) > 0 }
        }
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


// Featurres:
// a6f9ca8668025ee82217756e08871cab: Associate named address maps with Move packages.
// a9363c0147e2393028a12e3b3ac1a4ca: Fail the compilation process if any errors or diagnostics are encountered.
// 6b6f4b1180bc5d3c5d1f376f7b597099: Write module, address, and script definitions in package definitions and have the compiler extract and separate specification-only modules.
