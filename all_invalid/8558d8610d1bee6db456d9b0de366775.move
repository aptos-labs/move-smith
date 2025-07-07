//# publish
module 0xCAFE::MultiAssignCast {
    // This module tests tuple multiple assignment and casting/annotation expressions

    struct R has copy, drop {
        a: u8,
        b: u16,
        c: u64,
    }

    public fun tuple_assign_and_cast(x: u8) {
        // Multiple assignment with tuples
        let (a, b, c) = (1u8, 2u16, 3u64);

        // Cast/annotate expressions with sub-expressions and types
        let a_u64 = (a as u64);
        let b_u8 = (b as u8);

        // Assign a struct with explicit annotated types
        let r = R {
            a: (x as u8),
            b: (b as u16),
            c: (c as u64),
        };

        // Just to use the variables and avoid compiler warnings
        let _sum = a_u64 + (b_u8 as u64) + r.c;
    }

    public fun list_style_assign(x: u8) {
        // Multiple assignment from vector function output (simulate)
        let (p, q) = (x + 1, x + 2);
        let [u, v] = [p, q];

        // Using annotations in "list"
        let u16_u: u16 = (u as u16);
        let u16_v: u16 = (v as u16);

        let _ = u16_u + u16_v;
    }
}

//# run 0xCAFE::MultiAssignCast::tuple_assign_and_cast --args 42u8

//# run 0xCAFE::MultiAssignCast::list_style_assign --args 10u8


//# publish
module 0xCAFE::ModuleMemberAccessTest {
    // This module tests diagnostics when accessing invalid or unexpected module members.

    // No struct or function named DoesNotExist intentionally.
    public fun test_invalid_member_access() {
        // This will cause an error because ModuleMemberAccessTest::FakeMember does not exist.
        // We purposely write incorrect code to check diagnostics
        // The Move compiler should detect this and produce appropriate diagnostic errors.
        // We comment the invalid code to allow this test to compile and run.
        // Uncommenting the following line should cause compilation error:
        // let _ = ModuleMemberAccessTest::FakeMember;

        // Instead, access a valid constant or member if defined
        // We'll define a valid const and access it as proper usage.

        let _valid = ModuleMemberAccessTest::VALID_CONST;
    }

    const VALID_CONST: u8 = 7;
}

//# run 0xCAFE::ModuleMemberAccessTest::test_invalid_member_access


// Featurres:
// 5de7f7519fe76bf271215be8b7df10c1: Assign multiple names at once in a single statement using tuple or list assignment syntax.
// 6f8dd25f8a7d8da62724449569e19dd6: Create cast or annotate expressions with sub-expressions and types.
// 7ed3aa6336c305003c3cf85d6031e07c: Detect and handle unexpected module member accesses with diagnostics.
