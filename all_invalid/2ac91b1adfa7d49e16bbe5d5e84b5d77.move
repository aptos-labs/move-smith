
//# publish
module 0xCAFE::AssignmentTest {
    use std::signer;

    struct RefHolder has store {
        r: &u8,
    }

    public fun assign_to_block_result(x: u8): u8 {
        let a = x;
        (if (a < 5) {
            a = 10;
            &a
        } else {
            a = 20;
            &a
        }) = &(5u8);
        a
    }

    public fun assign_to_match_arm_result(flag: bool): u8 {
        let a = 0u8;
        (match flag {
            true => {
                a = 15;
                &a
            },
            false => {
                a = 25;
                &a
            }
        }) = &(7u8);
        a
    }

    public fun complex_expression_assignment(): u8 {
        let a = 0u8;
        let b = 1u8;
        let val_ref = if b > a { &a } else { &b };
        (*val_ref) = 42u8;
        a
    }

    public fun assign_ref_to_struct(s: &mut RefHolder, new_ref: &u8) {
        s.r = new_ref;
    }

    // friend(0xCAFE)] // custom attribute on friend declaration
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


// Featurres:
// baf5f481e5f8e194094529caea644273: Test that assignments to the result of block expressions or match arms—especially as references and within complex expressions—are correctly handled by the Move compiler and runtime.
// 019ec2b7f93cdef7c0d68e32b8cead1c: Annotate a friend declaration with attributes to specify custom metadata or behavior.
// ff1512edbab62479df53703ac4442701: Declare public functions or modules using the 'public' visibility modifier.
