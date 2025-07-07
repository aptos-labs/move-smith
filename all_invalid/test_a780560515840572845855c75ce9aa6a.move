//# publish
module 0xA1B2::test_type_reassign {
    fun type_and_reassign(): bool {
        // Declare u32 variable, increment it
        let mut count_u32: u32 = 10;
        count_u32 = count_u32 + 2; // Should be valid
        // Declare u64 variable, increment it
        let mut count_u64: u64 = 20;
        count_u64 = count_u64 + 3; // Should be valid

        // Verify the final values
        let u32_ok = (count_u32 == 12);
        let u64_ok = (count_u64 == 23);
        u32_ok && u64_ok
    }

    public fun check_reassignments() {
        assert!(type_and_reassign(), 0);
    }
}

//# run 0xA1B2::test_type_reassign::check_reassignments

//# publish
module 0xD4E5::pattern_matching {
    enum NumberVariant has drop {
        Zero,
        Succ { prev: u64 },
        Even { value: u64 },
        Odd { value: u64 },
    }

    fun match_zero_or_succ(n: NumberVariant): bool {
        // Match Zero or Succ
        (n is Zero) || (n is Succ)
    }

    fun match_even_or_odd(n: NumberVariant): bool {
        // Match either Even or Odd variants
        (n is Even) | (n is Odd)
    }

    public fun test_zero_succ() {
        let zero = NumberVariant { Zero };
        let succ = NumberVariant { Succ { prev: 1 } };
        assert!(match_zero_or_succ(zero), 0);
        assert!(match_zero_or_succ(succ), 0);
    }

    public fun test_even_odd() {
        let even = NumberVariant { Even { value: 4 } };
        let odd = NumberVariant { Odd { value: 5 } };
        assert!(match_even_or_odd(even), 0);
        assert!(match_even_or_odd(odd), 0);
    }
}

//# run 0xD4E5::pattern_matching::test_zero_succ
//# run 0xD4E5::pattern_matching::test_even_odd