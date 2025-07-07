
//# publish
module 0xCAFE::InteractionTest {
    use std::vector;

    // Constants declared at module scope to verify accessibility
    const CONST_U8: u8 = 42;
    const CONST_VECTOR_U8: vector<u8> = b"Test";

    // Struct with private/internal functions
    struct InnerStruct has copy, drop, store {
        val: u64
    }

    // Internal function that is only accessible within the module
    internal fun internal_function(x: u64): u64 {
        x + 100
    }

    // Public function that calls internal
    public fun call_internal(x: u64): u64 {
        internal_function(x)
    }

    // Function to demonstrate variable shadowing within block
    public fun shadowing_demo(val: u64): u64 {
        let val = val + 1;
        if (val > 10) {
            let val = val * 2;
            val // shadowed variable used here
        } else {
            val + 5
        }
    }

    // Function that reassigns variables multiple times
    public fun reassign_demo(): u64 {
        let x = 0;
        x = x + 1;
        x = x + 2;
        let x = x * 3; // shadowing previous x
        x
    }
}


//# run 0xCAFE::InteractionTest::call_internal --args 50u64


//# run 0xCAFE::InteractionTest::shadowing_demo --args 11u64


//# run 0xCAFE::InteractionTest::reassign_demo


//# publish
module 0xCAFE::ControlFlowTest {
    // Declare constants
    const CONST_BOOL: bool = true;
    const CONST_U16: u16 = 65535;

    // Test local variable assignments outside loops
    public fun variable_assignment_test(): u64 {
        let total = 0u64;
        let i = 0u64;
        while (i < 5) {
            let temp = i * 2;
            total = total + temp;
            i = i + 1;
        };
        total
    }

    // Test local variable shadowing with nested loops
    public fun nested_loop_shadowing(): u64 {
        let outer = 0u64;
        while (outer < 3) {
            let outer = outer + 1; // shadow outer
            let inner = 0u64;
            while (inner < 2) {
                let inner = inner + outer; // shadow inner
                outer = outer + inner; // modify outer
                inner = inner + 1; // this won't affect outer
            };
            outer = outer + 1;
        };
        outer
    }

    // Test combined control flow with ifs
    public fun complex_flow(x: u64): u64 {
        let result = 0u64;
        if (x < 10) {
            let y = x + 5;
            while (y > 0) {
                if (y % 2 == 0) {
                    result = result + y;
                } else {
                    result = result - y;
                };
                y = y - 1;
            };
        } else {
            let z = x - 10;
            while (z < x) {
                result = result + z;
                z = z + 2;
            };
        };
        result
    }

    // Test for loop with break
    public fun for_loop_break(): u64 {
        let sum = 0u64;
        for (i in 0..10) {
            if (i == 5) {
                break;
            };
            sum = sum + i;
        };
        sum
    }

    // Test while loop with continue (simulate via if)
    public fun while_loop_continue(): u64 {
        let sum = 0u64;
        let i = 0u64;
        while (i < 10) {
            if (i % 2 == 0) {
                i = i + 1;
                continue;
            };
            sum = sum + i;
            i = i + 1;
        };
        sum
    }
}


//# run 0xCAFE::ControlFlowTest::variable_assignment_test


//# run 0xCAFE::ControlFlowTest::nested_loop_shadowing


//# run 0xCAFE::ControlFlowTest::complex_flow --args 8u64


//# run 0xCAFE::ControlFlowTest::for_loop_break


//# run 0xCAFE::ControlFlowTest::while_loop_continue


//# publish
module 0xCAFE::VisibilityTest {
    // Struct with private/internal functions
    struct PrivateStruct has copy, drop, store {
        secret: u64
    }

    // Internal function not accessible outside module
    internal fun internal_compute(x: u64): u64 {
        x * 2
    }

    // Public function calling internal
    public fun compute_via_public(x: u64): u64 {
        internal_compute(x)
    }

    // External test to verify access restrictions
    // Here, external code cannot call internal_compute directly
    // but can call compute_via_public
}


//# run 0xCAFE::VisibilityTest::compute_via_public --args 123u64


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// cc3d3914bef959a9d2be3435ad4c242c: Test that variables in Move can be reassigned and retain their updated values within a function.
// 6e816c93475426773118e5918e3a3c04: Test that constant declarations of primitive types and vectors are correctly supported and accessible in Move scripts.
// c55db86185c0d0ecf3a554d5fe77b012: Test that nested loops and control flow (for and while) correctly update variables and reach specified assertions in a Move script.
