//# publish
address 0xDEADBEEF {
    module TestModule {
        // Define a simple struct with a field
        struct MyStruct has copy, drop, store {
            value: u64,
        }

        // Function to create and return an instance of MyStruct
        public fun create_struct(val: u64): MyStruct {
            MyStruct { value: val }
        }

        // Function to test assigning a local copy and mutating it
        public fun test_modify_struct(s: &mut MyStruct): u64 {
            let mut local_copy = *s; // assign local copy
            local_copy.value = local_copy.value + 42; // modify through mutable reference
            *s = local_copy; // assign back to original
            local_copy.value // return the value to verify
        }

        // Runner function to execute the test
        public fun run_test(): u64 {
            let mut s = create_struct(10);
            let result = test_modify_struct(&mut s);
            result
        }

        // Define an 'axiom' struct with optional type parameters for parametrization
        // Since Move currently doesn't support optional generics, demonstrate parameterization
        // with a constant or generic as a placeholder
        resource struct Axiom<T> has key {
            condition: bool,
            marker: T,
        }

        // Function to instantiate an axiom with a specific condition
        public fun create_axiom<T>(cond: bool, marker: T): Axiom<T> {
            Axiom { condition: cond, marker }
        }
    }
}
//# run 0xDEADBEEF::TestModule::run_test