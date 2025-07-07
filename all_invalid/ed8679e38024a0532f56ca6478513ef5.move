// A test to cover:
// 1. Decode hexadecimal escape sequences in byte string literals.
// 2. Declare a function with optional public, entry, or deprecated script visibility modifiers.
// 3. Warn when an address is redundantly specified for a module that already has one.

//////////////////////////////////////////////////////////////////
//# publish
address 0xCAFE {
    module Module0 {
        // A function that returns a byte string with hex escape sequences decoded.
        public fun get_hex_bytes(): vector<u8> {
            // Byte string containing: \x41 = 'A', \x42 = 'B', \x43 = 'C'
            let b: vector<u8> = b"\x41\x42\x43";
            b
        }

        // An entry function (transaction entry point) without arguments.
        entry fun do_nothing() {
        }

        // A deprecated (script visibility) function, no args.
        script fun deprecated_func() {
        }

        // Runner function to call both entry and deprecated functions.
        public fun runner() {
            do_nothing();
            deprecated_func();
        }
    }
}
//# run 0xCAFE::Module0::runner --signers 0xCAFE
//# run 0xCAFE::Module0::get_hex_bytes --signers 0xCAFE

//////////////////////////////////////////////////////////////////
//# publish
// Redundant address specifying for a module. Should warn (compile) but okay.
address 0xCAFE {
    module 0xCAFE::RedundantAddressModule {
        public fun foo(): u64 {
            42
        }
    }
}
//# run 0xCAFE::RedundantAddressModule::foo --signers 0xCAFE

//////////////////////////////////////////////////////////////////
//# run
script {
    use 0xCAFE::Module0;

    fun main() {
        // Call get_hex_bytes script function from Module0.
        let bytes = Module0::get_hex_bytes();
        // Just discard result to test decoding/computation.
    }
}

// Featurres:
// 63b3af5e5d419bb922ba25f65782c552: Decode hexadecimal escape sequences in byte string literals.
// 77fd16c7d6ef9e1e8e0b07ecad6da90a: Declare a function with optional public, entry, or deprecated script visibility modifiers.
// 48027d930099823e613a573e3d66ee2c: Warn when an address is redundantly specified for a module that already has one.
