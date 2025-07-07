//# publish
module 0x123::ReturnTest {
    // This module tests return expressions with different formatting and expressions
    struct Data has copy, drop {
        value: u64,
    }

    fun return_simple(u: u64): u64 {
        return u + 10;
    }

    fun return_complex_format(a: u64): u64 {
        if (a < 5) return a * 2 else return a / 2;
        0
    }

    fun return_reference(s: &Data): &u64 {
        return &s.value;
    }

    fun return_nested_block(r: u64): u64 {
        let x = {
            if (r > 0) {
                return r - 1;
            }
            0
        };
        x
    }
}

//# run 0x123::ReturnTest::return_simple --args 5

//# run 0x123::ReturnTest::return_complex_format --args 4

//# run 0x123::ReturnTest::return_reference --args 0x123::ReturnTest::Data { value: 42 }

//# run 0x123::ReturnTest::return_nested_block --args 3


//# publish
module 0x456::MutableRefTest {
    // This module tests mutable references involving nested blocks and conditionals
    fun modify_value(r: u64): u64 {
        let mut x = r;
        let r_ref = &mut x;
        if (r < 4) {
            *r_ref = *r_ref + 5;
        } else {
            *r_ref = *r_ref + 10;
        }
        // nested block with reference
        let y = {
            let y_temp = *r_ref;
            let y_ref = &mut y_temp;
            *y_ref = *y_ref + 3;
            *y_ref
        };
        // Final value
        y
    }

    fun modify_struct(s: &mut Data): u64 {
        s.value = s.value + 7;
        let val_ref = &mut s.value;
        *val_ref = *val_ref + 1;
        s.value
    }

    struct Data has copy, drop {
        value: u64,
    }

    public fun test_modification(): u64 {
        let x = modify_value(3) + modify_value(5); // expecting 3+5 + 8+15 depending on conditional
        let mut s = Data { value: 10 };
        let total = x + modify_struct(&mut s);
        total
    }
}

//# run 0x456::MutableRefTest::test_modification


//# publish
module 0x789::HelperFunctions {
    // Helper to return reference to expression evaluated inside nested blocks
    fun get_ref_inner(a: u64, b: u64): &u64 {
        let c = {
            let x = a + b;
            &x
        };
        c
    }

    fun get_value_inner(a: u64, b: u64): u64 {
        let c = {
            let x = a * b;
            x + 1
        };
        c
    }

    // Function that returns a reference involving complex nested expressions
    fun complex_return(r: u64): &u64 {
        return {
            let temp = if (r > 0) {
                get_ref_inner(r, r)
            } else {
                get_value_inner(1, 2)
            };
            temp
        };
        // Implicit return in move
    }
}

//# run 0x789::HelperFunctions::complex_return --args 5
