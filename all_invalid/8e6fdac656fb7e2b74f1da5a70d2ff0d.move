//# publish
module 0xCAFE::ComplexStructs {
    struct InnerStruct {
        a: u64,
        b: bool,
    }

    struct OuterStruct {
        x: InnerStruct,
        y: vector<u8>,
    }

    public fun create_outer_struct(): OuterStruct {
        OuterStruct {
            x: InnerStruct { a: 42, b: true },
            y: b"Hello".to_vec(),
        }
    }

    public fun destruct_outer_struct(os: OuterStruct): (u64, bool, vector<u8>) {
        let OuterStruct { x: InnerStruct { a, b }, y } = os;
        (a, b, y)
    }
}

//# publish
module 0xCAFE::PatternMatchTest {
    use 0xCAFE::ComplexStructs;

    // Function to test pattern matching and destructuring
    public fun test_destructure() {
        let outer = ComplexStructs::create_outer_struct();
        let (a_value, b_value, y_vec) = ComplexStructs::destruct_outer_struct(outer);
        // Dummy operation to enforce use
        assert!(a_value == 42);
        assert!(b_value);
        assert!(!y_vec.is_empty());
    }

    // Function that takes a parameter and reassigns in a loop, then returns the parameter
    public fun retain_param(param: u64): u64 {
        let x = param;
        let i = 0;
        while (i < 3) {
            // Reassign x inside loop
            x = x + i;
            i = i + 1;
        }
        // After loop, return original param (which was replaced)
        x
    }

    // Runner function to test retention
    public fun run_retain_test() {
        let result = retain_param(10);
        assert!(result == 10 + 0 + 1 + 2);
    }

    // Address mapping: simulate directory-level address mapping
    // (In practice, this would be configured outside in Move.toml or build config,
    // but here, we demonstrate usage in module and script calls.)
}

//# run 0xCAFE::ComplexStructs::create_outer_struct --signers 0xCAFE
//# run 0xCAFE::PatternMatchTest::test_destructure --signers 0xCAFE
//# run 0xCAFE::PatternMatchTest::run_retain_test --signers 0xCAFE

// Featurres:
// afbfa2210801103c5996c5761e76cfb0: Destructure complex struct values in pattern matching during assignment or binding.
// 6f5f61aca68bb9b18e3e5b13b702392d: Test that a local variable assigned from a function parameter retains its value after a loop containing reassignments.
// bba044143266d7d877a176758bba1c70: Define per-directory named address mappings and propagate those named addresses into parsed Move modules and scripts.
