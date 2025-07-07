
//# publish
module 0xCAFE::TestInferredAcquiresAndAbilities {
    use std::signer;
    use std::vector;

    const ERROR_CODE: u64 = 999u64;

    struct Inner has copy, drop {
        value: u64
    }

    struct Outer has copy, drop {
        inner: Inner
    }

    struct Singleton has key {
        id: u64,
        inner: Inner
    }

    struct MultiAbility<T: copy+drop+store> has store {
        field: T
    }

    enum VariantEnum<T: copy+drop+store> has copy, drop {
        VariantA,
        VariantB(T),
        VariantC {
            nested: T
        }
    }

    public fun create_singleton(s: signer, id: u64, v: u64) {
        let inner = Inner { value: v };
        let singleton = Singleton { id, inner };
        move_to<Singleton>(&s, singleton);
    }

    public fun read_singleton(s: signer): u64 {
        let singleton_ref = borrow_global<Singleton>(signer::address_of(&s));
        singleton_ref.inner.value
    }

    public fun create_multi_ability<T: copy+drop+store>(val: T): MultiAbility<T> {
        MultiAbility<T> { field: val }
    }

    public fun create_variant_with_inner(v: u64): VariantEnum<Inner> {
        VariantEnum::VariantC { nested: Inner { value: v } }
    }

    public fun complex_looping(mut_x: u64): u64 {
        let x = mut_x;
        loop {
            if (x == 0) {
                break;
            };
            if (x % 2 == 0) {
                // continue would skip to next iteration
                let _continue = true;
            } else {
                // Use abort if x is 3
                if (x == 3) {
                    abort ERROR_CODE;
                };
            };
            // emulate x -= 1;
            let x = x - 1;
            if (x == 1) {
                break;
            };
        };
        x
    }

    public inline fun inline_fun(a: u8): u8 {
        a + 42u8
    }

    public fun run_keywords() {
        let b = false;
        if (b) {
            let c = true;
            assert!(c, 1);
        } else {
            let d = false;
            assert!(!d, 2);
        };
        let _ = copy 5u8;
        let _ = move 10u8;
    }

}


//# run 0xCAFE::TestInferredAcquiresAndAbilities::create_singleton --signers 0xBEEF --args 7u64 555u64


//# run 0xCAFE::TestInferredAcquiresAndAbilities::read_singleton --signers 0xBEEF


//# run 0xCAFE::TestInferredAcquiresAndAbilities::create_multi_ability --args 42u64


//# run 0xCAFE::TestInferredAcquiresAndAbilities::create_variant_with_inner --args 111u64


//# run 0xCAFE::TestInferredAcquiresAndAbilities::complex_looping --args 5u64


//# run 0xCAFE::TestInferredAcquiresAndAbilities::inline_fun --args 1u8


//# run 0xCAFE::TestInferredAcquiresAndAbilities::run_keywords


//# publish
module 0xCAFE::TestAllKeywords {
    use std::signer;

    const ABORT_CODE: u64 = 42u64;

    struct K has copy, drop, store {}

    public fun example_all_keywords(s: signer, x: u8) {
        let mut_y = x + 1;

        if (mut_y > 1) {
            let z = mut_y * 2;
            if (z > 3) {
                abort ABORT_CODE;
            } else {
                let a = 0;
                let b = 1;
                let c = a + b;
                let _ = c;
            };
        } else {
            let _ = false;
        };

        let counter = 0;

        while (counter < 3) {
            if (counter == 1) {
                counter = counter + 1;
                continue;
            };
            if (counter == 2) {
                break;
            };
            counter = counter + 1;
        };

        loop {
            if (counter > 10) {
                break;
            };
            counter = counter + 2;
        };
    }

    public inline fun example_inline_fun(x: u8): u8 {
        x + 10u8
    }
}


//# run 0xCAFE::TestAllKeywords::example_all_keywords --signers 0xDEAD --args 1u8


//# run 0xCAFE::TestAllKeywords::example_inline_fun --args 13u8


// Featurres:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 9913fee717d4d1dd0dd2683b4bd7e734: Write Move code using keywords such as abort, acquires, as, break, const, continue, copy, else, false, fun, friend, if, invariant, let, loop, inline, module, move, native, public, return, script, spec, struct, true, use, and while.
