
//# publish
module 0xDEAD::PackageVisibilityTest {
    // This module tests access restrictions based on package visibility
    // It will attempt to access functions and modules in different contexts

    // Public function, should be accessible outside
    public fun pub_func(): u8 {
        42
    }

    // Private function, accessible only within this module
    fun priv_func(): u8 {
        7
    }

    // Function that tries to access the private function (should succeed internally)
    public fun access_private(): u8 {
        priv_func()
    }
}


//# publish
module 0xBADD::InterDependentA {
    // This module depends on InterDependentB to test cyclic dependencies
    use 0xBADD::InterDependentB;

    // Export a public function, calling B's function
    public fun call_b(): u8 {
        InterDependentB::b_func()
    }
}

//# publish
module 0xBADD::InterDependentB {
    // Depend on A module to create potential cyclic dependency
    use 0xBADD::InterDependentA;

    // Export a public function, calling A's function
    public fun b_func(): u8 {
        InterDependentA::call_b() // This should trigger or be blocked by cyclic dependency detection
    }
}


//# publish
module 0xC0FF::SideEffectFree {
    // This module contains pure functions with no side effects
    
    // Pure function
    public fun add_one(x: u64): u64 {
        x + 1
    }

    // Function with expression that should produce correct result
    public fun compute(): u64 {
        let a = add_one(10);
        let b = add_one(a);
        b
    }

    // Function to verify that side effects do not occur
    public fun test_side_effects(): u64 {
        let res = compute();
        res
    }
}


//# run 0xDEAD::PackageVisibilityTest::access_private --args

//# run 0xBADD::InterDependentA::call_b --args

//# run 0xC0FF::SideEffectFree::test_side_effects


// Featurres:
// 40695500bde0323f00aa864d292abae6: Declare functions or modules with 'package' visibility to restrict access within the same package.
// 322a88b49cb3bc03a2c0848b4e7784c8: Design modules to avoid cyclic dependencies to prevent dependency cycle errors.
// e0857c203b7fb353aa193912b35ecaf7: Write Move expressions that are guaranteed to be free of side effects by using only leaf expressions or pure calls.
