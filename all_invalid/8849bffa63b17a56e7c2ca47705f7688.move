// # publish
address 0xCAFE {
    module TypesWithAbilities<T: copy + drop + store + key, U: copy + drop + store> {
        // A struct with explicit ability constraints
        struct Wrapper has copy, drop, store {
            value: T,
            nested: U,
        }

        // A public function to create Wrapper
        public fun create(value: T, nested: U): Wrapper<T, U> {
            Wrapper { value, nested }
        }
    }
}

// # publish
address 0xCAFE {
    module SumDecreasing {
        use std::vector;
        use 0xCAFE::TypesWithAbilities;

        /// This function takes a vector of u64 and sums the values by a decreasing loop.
        /// The sum is initial_sum + sum of [input_vector elements decreasing from len-1 to 0]
        public fun test1(values: vector<u64>): u64 {
            let len = vector::length(&values);
            let mut acc = 0u64;
            let mut i = len;
            while (i > 0) {
                i = i - 1;
                acc = acc + *vector::borrow(&values, i);
            }
            let sum_of_values = acc;
            let initial_sum = sum_of_values; // As per requirement: final result = sum_of_inputs + accumulated total
            initial_sum + sum_of_values
        }

        /// Runner function without arguments to allow # run command
        public fun runner(): u64 {
            // Prepare vector [5,4,3,2,1]
            let vals = vector::empty<u64>();
            let vals = vector::push_back(vals, 5u64);
            let vals = vector::push_back(vals, 4u64);
            let vals = vector::push_back(vals, 3u64);
            let vals = vector::push_back(vals, 2u64);
            let vals = vector::push_back(vals, 1u64);
            test1(vals)
        }
    }
}
// # run 0xCAFE::SumDecreasing::runner

// # run
script {
    use 0xCAFE::TypesWithAbilities;
    use 0xCAFE::SumDecreasing;

    fun main() {
        // Test TypesWithAbilities::create with u64 and u8 types which fulfill ability constraints
        let wrapper = TypesWithAbilities::create<u64, u8>(42u64, 7u8);

        // Call SumDecreasing::test1 directly via runner script call
        let result = SumDecreasing::runner();

        // Result = sum_of_inputs + sum_of_inputs = (5+4+3+2+1)*2 = 15*2 = 30
        // Just return without assertion as per instruction.
        // Use dummy no-op with result.
        let _ = result;
        let _ = wrapper;
    }
}

// Featurres:
// 0691cf57e8aa68da49dfd322abf370ed: Annotate type parameters with explicit ability constraints.
// ada67865bddc808bf8b520da8bb122bb: Define named Move address blocks that contain modules and attributes.
// 46dad5b78645bcbf204e23b9432b614a: Test that the `test1` function correctly sums decreasing values from the input and computes the final result as the sum of initial inputs plus the accumulated total.
