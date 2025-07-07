//# publish
module 0xCAFE::CustomCompare {
    use std::signer;

    struct Wrapper has store, key {
        val: u64,
    }

    public fun new_wrapper(value: u64): Wrapper {
        Wrapper { val: value }
    }

    public fun less_than(w1: &Wrapper, w2: &Wrapper): bool {
        w1.val < w2.val
    }

    public fun equal_to(w1: &Wrapper, w2: &Wrapper): bool {
        w1.val == w2.val
    }

    public fun compare_and_update(s: signer) {
        if (exists<Wrapper>(signer::address_of(&s))) {
            let w = borrow_global_mut<Wrapper>(signer::address_of(&s));
            let dummy = new_wrapper(42u64);
            if (less_than(&w, &dummy)) {
                w.val = 100u64;
            };
            if (equal_to(&w, &dummy)) {
                w.val = 200u64;
            };
        } else {
            let wrapper = new_wrapper(10u64);
            move_to<Wrapper>(&s, wrapper);
        };
    }
}

//# run 0xCAFE::CustomCompare::compare_and_update --signers 0x2000

//# publish
module 0xCAFE::AcquisitionTest {
    use std::signer;

    struct A has key {
        value: u8
    }

    struct B has key {
        value: u8
    }

    public fun acquire_both(s: signer) {
        let addr = signer::address_of(&s);
        if (!exists<A>(addr)) {
            move_to<A>(&s, A { value: 1 });
        };
        if (!exists<B>(addr)) {
            move_to<B>(&s, B { value: 10 });
        };

        // Proper acquisition annotations must be shown by passing both resources
        let a_ref: &mut A = borrow_global_mut<A>(addr);
        let b_ref: &mut B = borrow_global_mut<B>(addr);

        a_ref.value = a_ref.value + 5;
        b_ref.value = b_ref.value + a_ref.value;
    }

    public fun acquire_one(s: signer) {
        let addr = signer::address_of(&s);

        if (!exists<A>(addr)) {
            move_to<A>(&s, A { value: 7 });
        };

        let a_ref: &mut A = borrow_global_mut<A>(addr);
        a_ref.value = a_ref.value * 2;
    }
}

//# run 0xCAFE::AcquisitionTest::acquire_both --signers 0x3000

//# run 0xCAFE::AcquisitionTest::acquire_one --signers 0x3000


//# publish
module 0xCAFE::TestPlanGen {
    use std::signer;

    struct Sample has store, key { a: u8 }

    public fun create_sample(s: signer) {
        if (!exists<Sample>(signer::address_of(&s))) {
            move_to<Sample>(&s, Sample { a: 55 });
        };
    }

    public fun update_sample(s: signer, new_val: u8) {
        let sample_ref = borrow_global_mut<Sample>(signer::address_of(&s));
        sample_ref.a = new_val;
    }

    public fun retrieve_val(s: signer): u8 {
        let sample_ref = borrow_global<Sample>(signer::address_of(&s));
        sample_ref.a
    }

    // Intended to be called as a runner for tests that require compilation of test plans targeting this module
    public fun runner() {
        // no-op runner for test plan generation
    }
}

//# run 0xCAFE::TestPlanGen::create_sample --signers 0x4000

//# run 0xCAFE::TestPlanGen::update_sample --signers 0x4000 --args 99u8

//# run 0xCAFE::TestPlanGen::retrieve_val --signers 0x4000

//# run 0xCAFE::TestPlanGen::runner

// Featurres:
// 4d54e60e788ef2ff56d39867c98f8643: Use custom comparison operations that can be automatically rewritten by the compiler for supported functions.
// 7cb9e69f486261eb0a12a25ab96bab61: Check for proper acquisition annotations in code.
// 381f4759ca362b7a031847e4ff1b5c66: Generate test plans for primary target modules when test code compilation is enabled.
