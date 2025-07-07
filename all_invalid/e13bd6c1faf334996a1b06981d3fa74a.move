
//# publish
module 0xCAFE::ComplexTest {
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
        x = x + 1;
        let res = x + CONST_VAL;
        res
    }

    public inline fun inline_assign_param(mut mut_param: u8): u8 {
        // assign to function parameter inside inline function
        mut_param = mut_param + 5;
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
