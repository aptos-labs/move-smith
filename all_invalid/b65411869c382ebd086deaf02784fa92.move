// Transactional Test for Move Compiler and VM
// Features tested: pack expressions, let-bindings, and type parameter correctness

//------------------------
//# publish
address 0xCAFE {
    module MyModule {
        use std::signer;

        /// A generic struct to test packing and type parameter handling
        struct Wrapper<T> has copy, drop, store {
            value: T,
        }

        /// A simple non-generic struct with primitive fields
        struct Foo has copy, drop, store {
            a: u64,
            b: bool,
        }

        /// Function to test constructing structs with pack
        public fun make_wrapped_bool(): Wrapper<bool> {
            let w = Wrapper<bool> {
                value: true
            };
            w
        }

        /// Function to test let-bindings and pack with multiple fields (primitive types)
        public fun make_foo(): Foo {
            let f = Foo {
                a: 99,
                b: false
            };
            f
        }

        /// Function that tries to treat primitive type as a type parameter (should not compile if misused)
        public fun primitive_type_is_not_type_parameter() : Foo {
            // Here we test that u64 is NOT a type parameter and can be used directly
            let x: u64 = 777u64;
            let f = Foo { a: x, b: true };
            f
        }

        /// Runner to test all pack/let features at once
        public fun run_all() {
            let w = make_wrapped_bool();
            let f = make_foo();
            let pf = primitive_type_is_not_type_parameter();
            // We do not assert, but we exercise storing/moving
            let _ = w;
            let _ = f;
            let _ = pf;
        }
    }
}

//# run 0xCAFE::MyModule::run_all --signers 0xCAFE

//------------------------
//# run
script {
    use 0xCAFE::MyModule::{Wrapper, Foo};

    fun main() {
        // Explicit let-binding and pack for generic struct
        let wrapped_u8 = Wrapper<u8> { value: 255u8 };

        // let-binding for simple struct
        let foo = Foo { a: 42, b: true };

        // Unused, but constructed
        let _ = wrapped_u8;
        let _ = foo;
    }
}