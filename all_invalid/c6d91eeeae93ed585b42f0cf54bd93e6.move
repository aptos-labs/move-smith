address 0x1 {
module TestClosures {

    /// PRIVATE FUNCTION
    /// This function is private and can only be called inside this module
    fun private_double(x: u64): u64 {
        x * 2
    }

    /// PUBLIC FUNCTION
    /// Calls the private function to double the input
    public fun public_double(x: u64): u64 {
        private_double(x)
    }

    /// MODULE FUNCTION
    /// Calls the private function to double the input, only callable within module
    module fun module_double(x: u64): u64 {
        private_double(x)
    }

    /// Demonstrating nested closures capturing variables at different scopes,
    /// returning closures from functions, and composing closures
    
    /// Type alias for closure taking u64 and returning u64
    /// (Move doesn't currently support true closures; simulation via functions returning functions.)
    /// We simulate this by returning function pointers / references.
    /// Since Move doesn't support first-class function types, we use fun type wrappers.

    /// Outer function returns a closure (function) that adds 'outer_add'
    public fun outer_adder(outer_add: u64): (u64) {
        // Inner closure that captures outer_add and adds inner_add
        fun inner_adder(inner_add: u64): (u64) {
            // Returned closure that adds both outer_add and inner_add to input
            fun composed(x: u64): u64 {
                x + outer_add + inner_add
            }
            composed
        }
        inner_adder
    }

    /// Compose two simple closures manually by calling one after another
    /// returns the sum of applying both closures to input x
    public fun compose_adders(x: u64, add1: u64, add2: u64): u64 {
        // Using private doubles for demonstration
        let a = private_double(x) + add1; // simulate first closure: double then add add1
        let b = x + add2; // simulate second closure: add add2
        a + b
    }

    #[test]
    public fun test_visibility_and_closures() {
        // Test private function indirectly via public and module functions:
        assert!(public_double(5) == 10, 100);
        assert!(module_double(7) == 14, 101);

        // The following line would fail to compile if uncommented, as private_double is private
        // let _ = private_double(10);

        // Testing nested closure simulation:
        // Get the inner_adder by calling outer_adder
        let inner = outer_adder(3);
        // Get the composed closure by calling inner with 5
        let closure = inner(5);
        // call composed closure with 10: 10 + 3 + 5 = 18
        let result = closure(10);
        assert!(result == 18, 102);

        // Compose two adder "closures"
        let comp_result = compose_adders(4, 1, 2);
        // Explanation:
        // private_double(4) = 8 + 1 = 9
        // 4 + 2 = 6
        // sum = 9 + 6 = 15
        assert!(comp_result == 15, 103);
    }
}
}

// Featurres:
// 7558a3708edea4ef863b7d2740db0eac: Declare functions with private visibility that can only be called from within the same module.
// a4b807ac0a99854fe42c1614ea55c58a: Define public or module functions within a module.
// c0b603c0378f40d20cbf5caeed8e8ac7: Test that nested closure functions can capture variables at different scopes and be composed, including returning closures from functions and composing them with other closures.
