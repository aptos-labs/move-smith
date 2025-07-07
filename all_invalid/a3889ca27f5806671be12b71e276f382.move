//# publish
address 0x1 {
    module SourceDependency {
        struct S { val: u64 }

        public fun create(): S {
            S { val: 42 }
        }

        public fun get_value(s: &S): u64 {
            s.val
        }

        /// Runner to test create and get_value
        public fun runner(): u64 {
            let s = create();
            get_value(&s)
        }
    }
}

//# run 0x1::SourceDependency::runner

//# publish
address 0x1 {
    module HandleIndexUser {
        use std::signer;

        /// A dummy struct so we can reference by handle index (struct index 0 = SourceDependency::S)
        struct Local {}

        /// Function that returns S by specifying type by handle index
        public fun get_struct_val(): u64 acquires SourceDependency::S {
            // We declare a reference to the struct SourceDependency::S by its handle (index 0).
            // This simulates usage of the 'Struct' feature by referencing the struct handle index in the signature.
            // The returned type is u64.
            // Implementation calls to SourceDependency.

            let s = SourceDependency::create();
            SourceDependency::get_value(&s)
        }

        /// Runner function with return type specified explicitly
        public fun runner(): u64 {
            get_struct_val()
        }
    }
}

//# run 0x1::HandleIndexUser::runner

//# run
script {
    use 0x1::SourceDependency;
    use 0x1::HandleIndexUser;

    fun main(account: &signer) {
        // Use SourceDependency runner
        let val1 = SourceDependency::runner();
        // Use HandleIndexUser runner
        let val2 = HandleIndexUser::runner();

        // Just to use values to avoid "unused variable" warning
        let _ = val1 + val2;
    }
}