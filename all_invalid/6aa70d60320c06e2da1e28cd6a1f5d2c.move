// # publish
address 0xCAFE {
    module ModuleEarlyReturn {
        public fun one(): u64 {
            if (true) {
                return 42;
            }
            100
        }
        
        public fun test(p: u64): u64 {
            let _x = one();
            _x = p;
            _x
        }

        public fun runner(): u64 {
            let a = one();
            if (a != 42) {
                // not reached
                0
            } else {
                test(777)
            }
        }
    }
}
// # run 0xCAFE::ModuleEarlyReturn::runner

// # run 0xCAFE::ModuleEarlyReturn::one

// # run 0xCAFE::ModuleEarlyReturn::test --args 123u64

// Featurres:
// 2b6aca4d6028953398d725597776c5b9: Test that a function with a conditional early return executes the return statement and produces the expected result.
// 82192e1c5121e4531b7cb24f03120b62: Test that the `test` function correctly assigns the input parameter `p` to the local variable `_x` after calling the `one` function and returns the value of `_x`.
// c5d6a5f9cde63291ecf21af67224ce85: Use address specifier 'Name' to refer to a named address in your code.
