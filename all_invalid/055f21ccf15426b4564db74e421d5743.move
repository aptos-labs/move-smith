//# publish
address 0x1 {
    module ModuleWithUnusedFunctions {
        // Module annotated with source location
        //! @source_location "0x1::ModuleWithUnusedFunctions"

        // A public function that is run as a runner
        public fun runner() {
            let x = 10;
            let y = copy x; // using copy to create copy expression
            dummy_private(y);
            dummy_internal();
        }

        // Private function that is called by runner (so not unused)
        fun dummy_private(a: u8) {
            // do nothing
            let _ = a;
        }

        // Private function that is NOT called anywhere (unused)
        fun unused_private() {
            // won't be called anywhere
        }

        // Internal function that is called (not unused)
        fun dummy_internal() {
            // do nothing
        }

        // Internal function NOT called anywhere (unused)
        fun unused_internal() {}

        // Public function NOT called anywhere (potentially unused)
        public fun unused_public() {}

    }
}
//# run 0x1::ModuleWithUnusedFunctions::runner --signers 0x1

//# publish
address 0x2 {
    module AnnotatedModule {
        //! @source_location "0x2::AnnotatedModule"
        use std::signer;

        public fun runner(s: &signer) {
            let a = 42;
            let b = copy a;

            // use b to avoid warning but no further call
            let _ = b;
        }

        fun unused_func() {}

    }
}
//# run 0x2::AnnotatedModule::runner --signers 0x2

//# run
script {
    use std::signer;

    fun main(account: signer) {
        let val = 5;
        let val_copy = copy val;

        let _ = val_copy;

        // call a public function from a different module directly inline
        0x1::ModuleWithUnusedFunctions::runner();

        // call AnnotatedModule runner
        0x2::AnnotatedModule::runner(&account);
    }
}