
//# publish
module 0xCAFE::AdvancedTest {
    use std::signer;

    struct R has key, store {
        a: u8,
        b: u8
    }

    /// Store resource R at signer's address with given values for a and b
    public fun store_resource(s: signer, a: u8, b: u8) {
        let r = R {a, b};
        move_to<R>(&s, r);
    }

    /// Access resource R explicitly by full path, return sum a + b
    public fun access_explicit(address: address): u8 {
        // explicitly specify full path to resource type in borrow_global
        let r_ref: &0xCAFE::AdvancedTest::R = borrow_global<0xCAFE::AdvancedTest::R>(address);
        r_ref.a + r_ref.b
    }

    /// Update resource R fields by explicit path and pattern matching with location info on a range list
    public fun pattern_match_update(address: address) {
        let r_mut_ref: &mut 0xCAFE::AdvancedTest::R = borrow_global_mut<0xCAFE::AdvancedTest::R>(address);
        // pattern matching with location info that binds variable to ranges
        let bnd: loc!((0..5, 10, 12..15)) = loc!((0..5, 10, 12..15));
        // use location info variable in a dummy let to use it, though no runtime effect
        let _loc_var = bnd;

        // pattern match bool for whether a in 0..5 or 10 or 12..15, simplified via if
        if ((r_mut_ref.a >= 0 && r_mut_ref.a < 5) ||
            (r_mut_ref.a == 10) ||
            (r_mut_ref.a >= 12 && r_mut_ref.a < 15)) {
            r_mut_ref.b = 100;
        } else {
            r_mut_ref.b = 200;
        };
    }

    /// Declare native spec function that simulates external implementation
    native spec fun native_spec_function(x: u8): bool;

    /// Public wrapper that calls native spec function and returns string vector based on result
    public fun call_native_spec(x: u8): vector<u8> {
        // simulate different results per native spec function
        let cond = native_spec_function(x);
        if (cond) {
            b"native_true"
        } else {
            b"native_false"
        }
    }
}


//# run 0xCAFE::AdvancedTest::store_resource --signers 0xABCD --args 3u8 7u8


//# run 0xCAFE::AdvancedTest::access_explicit --args 0xABCD


//# run 0xCAFE::AdvancedTest::pattern_match_update --args 0xABCD


//# run 0xCAFE::AdvancedTest::access_explicit --args 0xABCD


//# run 0xCAFE::AdvancedTest::call_native_spec --args 1u8


//# run 0xCAFE::AdvancedTest::call_native_spec --args 0u8


// Featurres:
// 65ad6f247c2aefde45cf07a9943712b6: Access members within a module or resource by specifying the address, module, and resource name explicitly.
// 36c72e3edbdbc4d4c017c081addfe2f5: Annotate spec functions with the 'native' keyword to indicate that their implementation is external or unavailable.
// aab8db647c4ef1c04b48e80cb40955b7: Use pattern matching with location information for variable binding with range lists.
