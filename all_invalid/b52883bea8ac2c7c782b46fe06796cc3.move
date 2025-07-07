
//# publish
module 0xBADD::AliasTest {
    use std::vector;

    
//# publish
    module NestedLoops {
        public fun test_breaks(): (u64, u64, u64) {
            let outer_i: u64 = 0;
            let inner_j: u64 = 0;
            let outer_k: u64 = 0;

            loop {
                outer_i = outer_i + 1;
                let inner_loop_count: u64 = 0;
                loop {
                    inner_j = inner_j + 1;
                    inner_loop_count = inner_loop_count + 1;
                    if (inner_loop_count >= 3) {
                        break;
                    }
                };
                if (outer_i >= 2) {
                    break;
                };
            };

            // After breaking from inner loop and outer loop,
            // update outer_k to sum of outer_i and inner_j
            outer_k = outer_i + inner_j;

            (outer_i, inner_j, outer_k)
        }
    }

    
//# publish
    module AttributeNamespace {
        // Define an attribute in a namespace, simulated using custom attribute attribute
        // my_ns::attributes]
        public fun get_namespaced_attribute(): u8 {
            42
        }
    }
}


//# run 0xBADD::AliasTest::NestedLoops::test_breaks --args

//# run 0xBADD::AliasTest::AttributeNamespace::get_namespaced_attribute --args
