//# publish
module 0xCAFE::VarDestructInlineHOF {

    use std::vector;

    // A struct to test destructuring with mutable references
    struct Container has key {
        a: u64,
        b: u64,
    }

    // A constant registry to hold unique constants
    struct ConstRegistry has key {
        constants: vector::Vector<u64>,
    }

    public fun new_registry(account: &signer): ConstRegistry {
        ConstRegistry {
            constants: vector::empty<u64>(),
        }
    }

    // Adds a constant if not already present (no duplicates).
    public fun add_const(registry: &mut ConstRegistry, val: u64) {
        let constants_ref = &mut registry.constants;
        // Only add if not already in the vector (simple linear lookup)
        let len = vector::length(constants_ref);
        let mut i = 0;
        let mut found = false;
        while (i < len) {
          if (vector::borrow(constants_ref, i) == &val) {
            found = true;
            break;
          };
          i = i + 1;
        };
        if (!found) {
            vector::push_back(constants_ref, val);
        };
    }

    // Returns true if the constant exists in the registry
    public fun has_const(registry: &ConstRegistry, val: u64): bool {
        let constants_ref = &registry.constants;
        let len = vector::length(constants_ref);
        let mut i = 0;
        while (i < len) {
          if (vector::borrow(constants_ref, i) == &val) {
            return true;
          };
          i = i + 1;
        };
        false
    }

    // Function that uses inline functions, higher order functions, closures, and destructuring
    public fun complex_binding_and_hof() {
        // Inline function: increment
        let increment = |x: u64| x + 1;

        // Higher order function: apply to vector elements
        fun map_vector(v: vector::Vector<u64>, f: &fn(u64): u64): vector::Vector<u64> {
            let len = vector::length(&v);
            let mut i = 0;
            let mut result = vector::empty<u64>();
            while (i < len) {
                let val = *vector::borrow(&v, i);
                let new_val = f(val);
                vector::push_back(&mut result, new_val);
                i = i + 1;
            };
            result
        };

        let v = vector::from_elem<u64>(0, 3); // [0, 0, 0]

        // Use the inline function increment as a closure function argument
        let v1 = map_vector(v, &increment);

        // Destructuring + mutable binding with struct
        let mut c = Container { a: 5, b: 10 };
        let Container { a: mut x, b: y } = c;
        x = x + y; // 5 + 10 = 15
        // Assign back
        c = Container { a: x, b: y };

        // Anonymous closure (not assignable directly, but inline call)
        let result = (|x: u64, y: u64| x * y)(3, 4);
        assert!(result == 12, 0);

        // Just to use all variables so optimizer does not remove info
        let _ = c.a + c.b + *vector::borrow(&v1, 0);

        // Dummy noop to freeze state
        ()
    }

    // Runner function to exercise all constructs
    public fun run() {
        let registry = new_registry(&signer::spec_signer());
        add_const(&mut registry, 100u64);
        add_const(&mut registry, 200u64);
        add_const(&mut registry, 100u64); // duplicate, should not be added

        complex_binding_and_hof();
    }
}
//# run 0xCAFE::VarDestructInlineHOF::run --signers 0xCAFE


//# run
script {
    use 0xCAFE::VarDestructInlineHOF;

    fun main(account: &signer) {
        // Just call the runner function to run the test scenario
        VarDestructInlineHOF::run();
    }
}

// Featurres:
// a266a7f8865315499de9a81c96b2fb89: Test the correct handling of variable bindings, destructuring, inline functions, higher-order functions, and anonymous closures in Move.
// 22a1a56e65aeb620b92ffc37f157c73f: Use numeric values for constants, including those of arbitrary size, as long as they are within the u64 range.
// 317fa7b3c5a552d9524c0b3f9e17ab77: Add constants to the module's constant registry while checking for duplicates.
