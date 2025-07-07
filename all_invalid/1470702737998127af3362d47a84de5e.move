
//# publish
module 0xDEAD::RecursiveCheck {
    use std::vector;

    // Module for testing nested structures and recursive calls
    struct InnerStruct has copy, drop, store {
        val: u32,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        flag: bool,
    }

    // Function to create nested structures
    public fun create_structs(val: u32, flag: bool): (OuterStruct, InnerStruct) {
        let inner = InnerStruct { val };
        let outer = OuterStruct { inner, flag };
        (outer, inner)
    }

    // Recursive function to check structure consistency
    public fun check_outer(inner_struct: &OuterStruct): bool {
        if (inner_struct.flag) {
            true
        } else {
            false
        }
    }

    // Function to test logical negation and compound assignment
    public fun test_logic(x: bool, y: bool): bool {
        let res = false;
        if (!(x && y)) {
            res = true;
        } else {
            res = false;
        };
        res
    }

    // Functions with parameter list enclosed in parentheses to test syntax
    public fun param_list_test((a: u64, b: u64)): u64 {
        a + b
    }

    // Wrapper to use functions with parameter list in test
    public fun run_tests() {
        let (outer, inner) = create_structs(42, false);
        let check_result = check_outer(&outer);
        let logic_result = test_logic(true, false);
        let sum = param_list_test((100u64, 200u64));
    }
}


//# run 0xDEAD::RecursiveCheck::run_tests


// Featurres:
// d46da021d7cad51cc60e73f0334676f4: Target specific modules for recursive structure checking.
// 5cee685862c557c647152db0d4254887: Test the behavior of the logical negation and compound assignment within the function to ensure it correctly evaluates the boolean expressions based on different input values.
// c97d16ca4d327179d64cbaa15d06c6b2: Declare functions in specifications with parameter lists enclosed in parentheses.
