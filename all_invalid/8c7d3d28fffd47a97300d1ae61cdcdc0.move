
//# publish
module 0xCAFE::CompositeAndVersionTest {
    use std::signer;

    // Specify minimum language version 1.6
    // version(1, 6)]

    struct Composite has copy, drop {
        a: u8,
        b: u16,
        c: bool,
    }

    // Function to create a composite from three values using Pack expression
    public fun create_composite(a: u8, b: u16, c: bool): Composite {
        Pack<Composite> { a, b, c }
    }

    // Function to test multiple conditional reassignments and return final value
    public fun conditional_reassign(x: u8, y: u8, flag: bool): (u8, u8) {
        let v1 = x;
        let v2 = y;
        let res = if (flag) {
            v1 = v1 + 1;
            v2 = v2 + 2;
            v1 + v2
        } else {
            v1 = v1 + 3;
            v2 = v2 + 4;
            v1 * v2
        };
        (v1, v2)
    }

    // Runner function without args to trigger all above
    public fun runner() {
        let _comp = create_composite(5u8, 100u16, true);
        let (_v1, _v2) = conditional_reassign(1, 2, true);
        let (_v3, _v4) = conditional_reassign(1, 2, false);
    }
}


//# run 0xCAFE::CompositeAndVersionTest::create_composite --args 10u8 200u16 true


//# run 0xCAFE::CompositeAndVersionTest::conditional_reassign --args 7u8 8u8 true


//# run 0xCAFE::CompositeAndVersionTest::conditional_reassign --args 7u8 8u8 false


//# run 0xCAFE::CompositeAndVersionTest::runner


// Featurres:
// ea232e7fc6bfb3fbc1021bf0f590d7ee: Pack multiple values into a composite using `Pack` expressions.
// c7c03b22865a2794aedb301f75375262: Use language version directives to specify the minimum required language version for your code.
// 1e412a57ffc70a3d7841548f2d8239b5: Test that variables reassigned in multiple conditional branches within a single expression are evaluated in the correct order and produce the expected result.
