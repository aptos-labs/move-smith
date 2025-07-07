// The test address used for publishing and running modules and scripts
// will be 0xCAFE instead of 0x1.

//# publish
module 0xCAFE::ModuleA {
    // Test mutual dependency by using ModuleB (will cause compile error)
    // use 0xCAFE::ModuleB;

    // Define a simple function to be run to test callability.
    public fun runner(): u64 {
        // Return a constant value to verify compilation.
        42u64
    }
}
//# run 0xCAFE::ModuleA::runner


//# publish
module 0xCAFE::ModuleB {
    // Introduce friend declaration to ModuleA to test friend dependency.
    // friend 0xCAFE::ModuleA;
    
    // Optionally try to use ModuleA (mutual dependency)
    // use 0xCAFE::ModuleA;

    public fun runner(): u64 {
        24u64
    }
}
//# run 0xCAFE::ModuleB::runner


//# publish
module 0xCAFE::ModuleCycle1 {
    // Try to create cyclic friend relationship
    friend 0xCAFE::ModuleCycle2;

    public fun runner(): u64 {
        1u64
    }
}
//# run 0xCAFE::ModuleCycle1::runner


//# publish
module 0xCAFE::ModuleCycle2 {
    friend 0xCAFE::ModuleCycle1;

    public fun runner(): u64 {
        2u64
    }
}
//# run 0xCAFE::ModuleCycle2::runner


//# run
script {
    use std::debug;

    fun main() {
        // Test 1: Fully qualify address and module references with :: syntax
        let a = 0xCAFE::ModuleA::runner();
        let b = 0xCAFE::ModuleB::runner();

        debug::print(&b"ModuleA::runner() returned: ");
        debug::print(&u64_to_bytes(a));
        debug::print(&b"\n");

        debug::print(&b"ModuleB::runner() returned: ");
        debug::print(&u64_to_bytes(b));
        debug::print(&b"\n");

        // Test 3: Nested loops with break statements conditioned on an outer boolean

        let mut outer_flag = true;
        let mut outer_count = 0u64;
        let mut inner_count = 0u64;

        loop {
            outer_count = outer_count + 1;

            let mut i = 0u64;
            loop {
                inner_count = inner_count + 1;

                if outer_flag && inner_count > 5 {
                    break;  // break inner loop if outer_flag is true and inner_count > 5
                };
                i = i + 1;
                if i > 10 {
                    break;
                }
            };

            // Break outer loop after 3 iterations for test restraint
            if outer_count >= 3 {
                break;
            };

            // Toggle outer_flag to false after first iteration
            if outer_count == 1 {
                outer_flag = false;
            }
        };

        debug::print(&b"outer_count: ");
        debug::print(&u64_to_bytes(outer_count));
        debug::print(&b", inner_count: ");
        debug::print(&u64_to_bytes(inner_count));
        debug::print(&b"\n");
    }

    // helper to convert u64 to bytes for debug print
    public fun u64_to_bytes(x: u64): vector<u8> {
        let bytes = std::convert::to_bytes(&x);
        bytes
    }
}

// Featurres:
// bfd59e2009020d70ca7e04b65ab54ed0: Convert module or address references like 'Module.' or 'Address.' to 'Module::' or 'Address::' syntax.
// e804905ce6742f65f069209e4daac6e8: Create mutual or cyclic dependencies between modules using 'use' or 'friend' relationships (although resulting in a compiler error).
// 12114af09de99c2526fd934eda77cf45: Test that nested loops correctly handle break statements with an outer conditional.
