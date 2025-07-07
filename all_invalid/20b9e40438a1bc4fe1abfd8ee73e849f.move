// #publish
address 0xCAFE {
    module ModuleInline {
        // A public inlineable function to add two u64 numbers.
        public inline fun add(a: u64, b: u64): u64 {
            a + b
        }

        // A friend inlineable function callable from 0xBEEF.
        friend(0xBEEF) inline fun friend_mul(a: u64, b: u64): u64 {
            a * b
        }

        // Non-inline function to test calling friend inline function from inside module itself
        public fun call_friend_mul(): u64 {
            friend_mul(6, 7)
        }

        // Runner function to test friend_mul externally, returns 0 to keep signature simple
        public fun runner(): u64 {
            42
        }
    }
}

// #publish
address 0xBEEF {
    module ModuleCaller {
        use 0xCAFE::ModuleInline;

        public fun call_add_func(): u64 {
            // Call public inlineable function across module boundary
            ModuleInline::add(10, 32)
        }

        public fun call_friend_mul_func(): u64 {
            // Call friend inlineable function across module boundary (allowed because this module is friend)
            ModuleInline::friend_mul(4, 5)
        }
        
        public fun loop_index_sum(): u64 {
            let sum = 0;
            // Declare and initialize loop index variable in for loop
            for i in 0..5 {
                // Use a label at start of bytecode block inside Move function
                label_start:
                sum = sum + i;
            }
            sum
        }
    }
}
// #run 0xBEEF::ModuleCaller::call_add_func
// #run 0xBEEF::ModuleCaller::call_friend_mul_func
// #run 0xBEEF::ModuleCaller::loop_index_sum

// #run 0xCAFE::ModuleInline::runner

// Featurres:
// c8af774d9ccf538c6ed3c843228d6d52: Define and use labels at the start of bytecode blocks in Move functions.
// 6313f2fc4f513c9bfe7ae3313b8c4a5e: Inline public or friend functions across module boundaries when permitted by visibility rules.
// 59e10dac00e363bde67a27b878077c5f: Declare and initialize a loop index variable within the 'for' loop.
