address 0x1 {
    module TransactionalTest {
        use std::vector;

        // A resource struct with ability constraints: store + key
        // It can be stored in global storage and has a key.
        struct ResourceWithAbilities has store, key {
            value: u64,
        }

        // A generic struct with ability constraints on the type parameter T
        // T must have copy + drop abilities.
        struct GenericWithAbility<T: copy + drop> has store {
            data: T,
        }

        /// A simple pure function to add two u64 numbers.
        public fun add(a: u64, b: u64): u64 {
            a + b
        }

        /// A function to partially apply 'add' function: returns a lambda/function that adds a fixed number.
        /// This is a move function that returns &fun(u64): u64
        /// But lambda lifting (i.e. returning lambdas) is disallowed in scripts, so this is a module function.
        public fun partial_add(fixed: u64): fun(u64): u64 {
            // Here we create a lambda that takes one u64 and adds fixed.
            // Move lambda syntax:
            // `fun(x: u64): u64 { add(fixed, x) }`

            // Note: We return an actual function type `fun(u64): u64`, which moves supports inside
            // modules but disallows in scripts.
            fun(x: u64): u64 {
                add(fixed, x)
            }
        }

        /// Spec defining an invariant condition on ResourceWithAbilities.
        /// The value must always be <= 100.
        spec ResourceWithAbilities {
            invariant value_lte_100(res: &ResourceWithAbilities): bool {
                res.value <= 100
            }
        }

        /// Spec with invariant on generic struct GenericWithAbility<u64> that data must be even.
        spec GenericWithAbility<u64> {
            invariant data_even(gen: &GenericWithAbility<u64>): bool {
                gen.data % 2 == 0
            }
        }

        /// Transactional test function:
        /// 1. Creates a ResourceWithAbilities.
        /// 2. Uses partial application via lambda in module,
        /// 3. Checks invariants using spec functions.
        /// 4. Works with GenericWithAbility<u64> enforcing ability constraints.
        public entry fun test_all_features(account: signer) {
            // Publish ResourceWithAbilities at the caller's address
            let res = ResourceWithAbilities { value: 42 };
            move_to(&account, res);

            // Partial apply: create an adder that adds 10
            let add_10 = partial_add(10);

            // Use the resulting lambda: add_10(5) == 15
            let result = add_10(5);
            assert!(result == 15, 101);

            // Borrow the resource to check the invariant condition via spec (implicit)
            let res_ref = borrow_global<ResourceWithAbilities>(signer::address_of(&account));
            // Spec invariant is checked statically but let's "simulate" a check using assert:
            assert!(res_ref.value <= 100, 102);

            // Create a generic struct with data 20 (even number)
            let generic_instance = GenericWithAbility<u64> { data: 20 };
            move_to(&account, generic_instance);

            // Borrow and check invariant (simulate with assert)
            let gen_ref = borrow_global<GenericWithAbility<u64>>(signer::address_of(&account));
            assert!(gen_ref.data % 2 == 0, 103);

            // Modify resource to break invariant (should fail if uncommented in real scenario)
            // let mut res_mut_ref = borrow_global_mut<ResourceWithAbilities>(signer::address_of(&account));
            // res_mut_ref.value = 101; // violates invariant

            // We do NOT do mutation that violates invariant here as it should fail verification.

        }
    }
}

// Featurres:
// 50ee0c7b7d1856d5244efa476d5a1a06: Use lambda expressions that partially apply existing functions, except that such lambda lifting is not allowed in scripts.
// a44da32fcb121bd1ee7c0a4b836c993e: Define invariant conditions within specifications.
// d51a366e7d162768d352933eb1c5a4a7: Specify ability constraints on structs, resources, and generic parameters using the ':' syntax followed by a list of abilities separated by '+'.
