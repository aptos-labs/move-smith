
//# publish
module 0xCAFE::ComplexTest {
    use std::vector;

    const CONST_VAL: u8 = 10;

    struct Data has store {
        val: u8,
    }

    public fun return_module_name(): vector<u8> {
        // Return the module name as a byte vector via identifier access
        b"ComplexTest"
    }

    public fun complex_binary_operation(): u8 {
        let x = 2u8;
        // non-trivial sequence expr as operand: increment inside binary operation
        // x += 1 before adding to CONST_VAL, so x becomes 3, result is 3 + 10 = 13
        let res = ( { x = x + 1; x } ) + CONST_VAL;
        res
    }

    public inline fun inline_assign_param(mut_param: u8): u8 {
        // assign to function parameter inside inline function
        let_param = mut_param + 5;
        mut_param
    }

    public fun outer_function(val: u8): (u8, u8) {
        let before = val;
        let after = inline_assign_param(val);
        // val outside remains unchanged, after = val + 5
        (before, after)
    }
}


//# run 0xCAFE::ComplexTest::return_module_name


//# run 0xCAFE::ComplexTest::complex_binary_operation


//# run 0xCAFE::ComplexTest::outer_function --args 7u8


// Featurres:
// 3f966e77979cf7ab5e1b615df0be442e: Reference a name or module access path as a value or identifier (e.g., some_identifier or M::some_identifier).
// 9999b96aafc20d2893411f661fd93de2: Include non-trivial sequence expressions (with side effects) as operands in binary operations, but be aware that it is not allowed under some language versions.
// 00905dd3d71fdef5877e9eb8e033622f: Test that assignments to a function parameter inside an inline function do not affect the original argument in the caller's scope.
