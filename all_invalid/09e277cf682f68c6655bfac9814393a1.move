//# publish
module 0xCAFE::AttributeAndOptimizationTest {
    use std::vector;

    // Attributes applied to struct
    #[phantom]
    struct PhantomStruct has store {
        a: u8,
    }

    // Abilities declared as postfix (correct syntax): 
    struct PrefixAbilityStruct has copy, drop, key {
        x: u64,
    }

    // Abilities declared as postfix, for variation
    struct PostfixAbilityStruct has copy, drop, store {
        flag: bool,
    }

    // Attribute on a function
    #[inline]
    public fun get_sum(x: u64, y: u64): u64 {
        if (x > y) {
            x
        } else {
            y
        };
        let z = x + y;
        z
    }

    // Attribute on a constant
    #[constant]
    const CONF_VALUE: u8 = 42;

    // Attribute on an enum
    #[derive(copy, drop)]
    enum Status {
        Active,
        Inactive,
        Pending(u8),
    }

    // Public function to exercise all above features
    public fun runner(): u8 {
        let _p = PhantomStruct {a: 1};
        let p_ab = PrefixAbilityStruct {x: 10};
        let post_ab = PostfixAbilityStruct {flag: true};

        let s1 = Status::Active;
        let s2 = Status::Pending(CONF_VALUE);

        let max_val = get_sum(10, 20);

        // Use vector to help with optimization pass testing
        let mut v = vector::empty<u8>();
        vector::push_back(&mut v, CONF_VALUE);
        vector::push_back(&mut v, max_val as u8);

        // Return first element of vector + some constant
        *vector::borrow(&v, 0) + 1
    }
}

//# run 0xCAFE::AttributeAndOptimizationTest::runner