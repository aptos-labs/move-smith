//# publish
address 0xCAFE {
    module ModuleA {
        // Friend module declaration to grant special access
        friend 0xCAFE::ModuleB;

        resource struct R { val: u64 }

        public fun create_r(): R {
            R { val: 42 }
        }

        public fun borrow_r_ref(r: &R): u64 {
            r.val
        }
    }
}

//# publish
address 0xCAFE {
    module ModuleB {
        // Declare friend to ModuleA to access its internal types (though friend is one way)
        friend 0xCAFE::ModuleA;

        use 0xCAFE::ModuleA;

        public fun call_borrow_friend(): u64 {
            let r = ModuleA::create_r();
            // Friend access: borrow_r_ref is public, but assume we want to simulate friend usage :
            // Just call the function, our friend declaration is here to validate compile
            ModuleA::borrow_r_ref(&r)
        }

        public fun run_runner() {
            // Just call the friend function
            let _ = call_borrow_friend();
        }
    }
}

//# run 0xCAFE::ModuleB::run_runner

//# publish
address 0xCAFE {
    module ModuleParsing {
        // Function to test parsing end delimiter '<' in types with nested generics of pairs
    
        struct MyPair<T, U> has copy, drop, store {
            fst: T,
            snd: U,
        }

        struct NestedPair has copy, drop, store {
            inner: MyPair<u8, MyPair<u64, bool>>,
        }

        public fun create_nested_pair(): NestedPair {
            NestedPair {
                inner: MyPair {
                    fst: 7u8,
                    snd: MyPair {
                        fst: 1234u64,
                        snd: true,
                    }
                }
            }
        }

        public fun run() {
            let np = create_nested_pair();
            let _fst = np.inner.fst;
            let _snd_fst = np.inner.snd.fst;
            let _snd_snd = np.inner.snd.snd;
        }
    }
}

//# run 0xCAFE::ModuleParsing::run

//# publish
address 0xCAFE {
    module ModuleVMError {
        use std::error;
        use std::signer;

        public fun abort_with_code(): u64 acquires signer {
            // Abort with a code to trigger VM error and capture source location
            abort 0xDEADBEEFu64;
        }

        public fun run_abort() {
            abort_with_code();
        }
    }
}

//# run 0xCAFE::ModuleVMError::run_abort --signers 0xCAFE

// Featurres:
// 5d06b27b54b8c9fe107c4b6c915e1ac6: Use the '<' token as an end delimiter in parsing contexts where nested '>>' tokens are involved.
// b7cf2830591b569585c2b4bc36d4ba75: Declare 'friend' modules to grant special access rights.
// 453682ddea7b74240c22d95d81f4b0ee: Retrieve the source location associated with a VM error when available.
