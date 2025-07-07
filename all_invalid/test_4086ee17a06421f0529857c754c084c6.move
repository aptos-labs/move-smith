//# publish
module 0x88::functional_tests {
    // Define a trait that represents a function pointer returning a boolean
    trait BoolFunc {
        fun invoke(&u64): bool;
    }

    // Define a struct that holds a function pointer trait
    struct FunctionHolder has drop {
        func: Box<dyn BoolFunc>,
    }

    // Implementation of the FuncHolder module with a constructor and test runner
    module FuncHolder {
        use 0x88::functional_tests::{BoolFunc, FunctionHolder};

        // A concrete implementation of the BoolFunc trait that wraps a closure
        struct ClosureWrapper has drop {
            predicate: fn(&u64): bool,
        }

        impl BoolFunc for ClosureWrapper {
            fun invoke(&self, x: &u64): bool {
                (self.predicate)(x)
            }
        }

        // Function to create a FunctionHolder with a specified predicate
        public fun create_holder(predicate: fn(&u64): bool): FunctionHolder {
            let wrapper = ClosureWrapper { predicate };
            let boxed: Box<dyn BoolFunc> = Box::new(wrapper);
            FunctionHolder { func: boxed }
        }

        // Test runner function that sets up a closure and invokes it via the trait object
        public fun test_closure() {
            // Define a closure equivalent to a function pointer
            fun is_even(x: &u64): bool {
                *x % 2 == 0
            }

            let holder = create_holder(is_even);
            // Invoke the function via the trait object
            let result = holder.func.invoke(&4);
            assert!(result);
            let result_odd = holder.func.invoke(&3);
            assert!(!result_odd);
        }
    }
}

//# run 0x88::functional_tests::FuncHolder::test_closure