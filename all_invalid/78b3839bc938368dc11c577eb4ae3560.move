
//# publish
module 0xCAFE::AssignmentTest {
    use std::signer;

    struct RefHolder has store {
        r: &u8,
    }

    public fun assign_to_block_result(x: u8): u8 {
        let a = x;
        let val_ref = if (a < 5) {
            a = 10;
            &a
        } else {
            a = 20;
            &a
        };
        *val_ref = 5u8;
        a
    }

    public fun assign_to_match_arm_result(flag: bool): u8 {
        let a = 0u8;
        let val_ref = match flag {
            true => {
                a = 15;
                &a
            },
            false => {
                a = 25;
                &a
            }
        };
        *val_ref = 7u8;
        a
    }

    public fun complex_expression_assignment(): u8 {
        let a = 0u8;
        let b = 1u8;
        let val_ref = if b > a { &mut a } else { &b };
        *val_ref = 42u8;
        a
    }

    public fun assign_ref_to_struct(s: &mut RefHolder, new_ref: &u8) {
        s.r = new_ref;
    }

    friend 0xCAFE;
}



//# publish
module 0xCAFE::PublicTest {
    public fun public_function_no_args(): u8 {
        123u8
    }

    public fun public_function_with_args(x: u8, y: u8): u8 {
        x + y
    }

    public fun runner() {
        let _ = public_function_no_args();
        let _ = public_function_with_args(1u8, 2u8);
    }
}



//# run 0xCAFE::AssignmentTest::assign_to_block_result --args 3u8



//# run 0xCAFE::AssignmentTest::assign_to_match_arm_result --args true



//# run 0xCAFE::AssignmentTest::complex_expression_assignment



//# run 0xCAFE::PublicTest::runner
