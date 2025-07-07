// Test Move transactional test exercising
// 1. Inline functions
// 2. Optional type parameters during unpacking
// 3. Nested match statements and control flow

// Publish and test a base module

//# publish
module 0xCAFE::Inliner {
    // Inline-able function
    #[inline(always)]
    public fun inc(x: u64): u64 {
        x + 1
    }

    // Calls only inline functions; all calls should be inlined.
    public fun add_and_inc(x: u64, y: u64): u64 {
        let a = Self::inc(x);
        let b = Self::inc(y);
        a + b
    }

    // A "runner" with no arguments
    public fun run_inliner(s: &signer) {
        let _ = Self::add_and_inc(10, 20);
    }
}
//# run 0xCAFE::Inliner::run_inliner --signers 0xCAFE

// Test module for optional type params and unpacking

//# publish
module 0xCAFE::OptType {
    struct MyBox<T> has copy, drop, store {
        value: T,
    }

    // Unpacks with a type param; sometimes used as Option
    public fun get_val<T>(b: MyBox<T>): T {
        b.value
    }

    public fun run_opt_type(s: &signer) {
        // Used with concrete types
        let b1 = MyBox { value: 42u8 };
        let val1 = Self::get_val(b1);

        // Used as option-like (simulate Option by using an Option struct)
        let b2 = Option::some<MyBox<u64>>(MyBox { value: 99 });
        match b2 {
            option::Option::Some(boxed) => {
                let val2 = Self::get_val(boxed);
                let _ = val2;
            },
            option::Option::None => (),
        }
    }
}

//# run 0xCAFE::OptType::run_opt_type --signers 0xCAFE

// Needed Option for optional unpacking demonstration

//# publish
module 0xCAFE::Option {
    struct Option<T> has copy, drop, store {
        present: bool,
        value: T,
    }

    public fun some<T>(v: T): Option<T> {
        Option { present: true, value: v }
    }

    public fun none<T: copy + drop + store>(default: T): Option<T> {
        Option { present: false, value: default }
    }

    public fun is_some<T>(o: &Option<T>): bool {
        o.present
    }
}
        
// Test nested match and critical edges

//# publish
module 0xCAFE::MatchTest {
    struct Pair has copy, drop, store {
        x: u8,
        y: u8,
    }

    // Nested matches and critical control flow
    public fun nested_match_test(p: Pair): u8 {
        match p.x {
            0 => 0,
            1 => {
                match p.y {
                    0 => 10,
                    1 => 11,
                    _ => 12,
                }
            },
            2 => 20,
            _ => 99,
        }
    }

    public fun run_nested_match(s: &signer) {
        // Each branch
        let r0 = Self::nested_match_test(Pair { x: 0, y: 1 });
        let r1_0 = Self::nested_match_test(Pair { x: 1, y: 0 });
        let r1_1 = Self::nested_match_test(Pair { x: 1, y: 1 });
        let r1_2 = Self::nested_match_test(Pair { x: 1, y: 2 });
        let r2 = Self::nested_match_test(Pair { x: 2, y: 9 });
        let r_other = Self::nested_match_test(Pair { x: 99, y: 255 });
        let _ = (r0, r1_0, r1_1, r1_2, r2, r_other);
    }
}
//# run 0xCAFE::MatchTest::run_nested_match --signers 0xCAFE