// File: tests/transactional/test_schema_map_and_cfg.move
// Purpose: Transactional test for Aptos Move compiler and VM functionalities:
// 1) Adding function members within a schema target of a module.
// 2) Testing Option::map function.
// 3) Simplifying CFG via optimized bytecode.

module 0x1::TestSchemaMapCFG {

    use std::option;
    use std::debug;

    /// A schema target struct with function members for organized code structure.
    struct Schema has store {
        val: u64,
    }

    /// Implements functions as members of the Schema struct.
    impl Schema {
        /// Constructor function
        public fun new(val: u64): Self {
            Schema { val }
        }

        /// Member function that increments the internal value
        public fun increment(&mut self) {
            self.val = self.val + 1;
        }

        /// Member function that doubles the internal value
        public fun double(&mut self) {
            self.val = self.val * 2;
        }

        /// Returns the stored value
        public fun get(&self): u64 {
            self.val
        }
    }

    /// Helper function to test Option::map functionality.
    /// Applies function `f` to a some option value, leaves none unchanged.
    fun option_map_example(opt: option::Option<u64>, f: fun(u64): u64): option::Option<u64> {
        option::map(opt, f)
    }

    /// Function with some control flow to be simplified by the Move compiler.
    /// This intentionally has branching that can be optimized.
    fun complicated_control_flow(x: u64): u64 {
        let mut res = 0;

        if (x > 10) {
            // Branch 1
            res = x + 1;
        } else if (x == 10) {
            // Branch 2
            res = x * 2;
        } else {
            // Branch 3
            res = x;
        }

        // Additional branching to test critical edges
        if (res % 2 == 0) {
            res = res / 2;
        } else {
            res = res * 3 + 1;
        }

        res
    }

    #[test]
    fun test_schema_functions() {
        // Test creation and member functions
        let mut s = Schema::new(5);
        assert!(s.get() == 5, 0);

        s.increment();
        assert!(s.get() == 6, 1);

        s.double();
        assert!(s.get() == 12, 2);
    }

    #[test]
    fun test_option_map() {
        // Prepare some option with value 10
        let some_val = option::some(10);
        // Map function to add 5
        let f = fun(x: u64): u64 { x + 5 };

        // Apply option_map_example
        let mapped = option_map_example(some_val, f);
        assert!(option::is_some(&mapped), 3);
        assert!(option::borrow(&mapped).copy() == 15, 4);

        // Test that none stays none
        let none_val: option::Option<u64> = option::none();
        let mapped_none = option_map_example(none_val, f);
        assert!(option::is_none(&mapped_none), 5);
    }

    #[test]
    fun test_cfg_simplification() {
        // Provide inputs that hit different branches
        let r1 = complicated_control_flow(15);
        let r2 = complicated_control_flow(10);
        let r3 = complicated_control_flow(5);

        // Check results match expected values manually calculated:
        // For x=15: branch1 => res=16 (15+1), 16 even => 16/2=8
        assert!(r1 == 8, 6);

        // For x=10: branch2 => res=20 (10*2), 20 even => 20/2=10
        assert!(r2 == 10, 7);

        // For x=5: branch3 => res=5, 5 odd => 5*3+1=16
        assert!(r3 == 16, 8);
    }

}

// Featurres:
// 3ad547c96786a64cd192079cf221dcfc: Add function members within a schema target of a module for organized code structure.
// 2546adaf47f70b2598c1cbdc28df4fc3: Test that the map function correctly transforms a some option value by applying a given function.
// 5d7c61b81a950841df5fc856f19d524b: Simplify control flow graphs to optimize bytecode and potentially remove critical edges.
