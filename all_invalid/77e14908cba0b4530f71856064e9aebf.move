//# publish
module 0xA1::OptionTest {
    use std::option::{Self, Option};
    use std::signer;

    /// Adds two u64 values
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    /// Given p, returns p + add(p, p+1)
    public fun test(p: u64): u64 {
        add(p, p + 1) + p
    }

    /// Returns an optional value of u64: Some(p) if p > 0 else None
    public fun optional_value(p: u64): Option<u64> {
        if (p > 0) {
            Option::some(p)
        } else {
            Option::none()
        }
    }

    /// Phantom type parameter example
    public struct PhantomTypePhantom<phantom T> has copy, drop, store {
        dummy: u8,
    }

    /// Phantom type parameter example without phantom keyword
    public struct PhantomTypeRegular<T> has copy, drop, store {
        dummy: u8,
    }

    /// A runner function with no args to exercise test() function and Option::some/none
    public fun runner(): u64 {
        let val = 10;
        let opt_some = optional_value(val);
        let opt_none = optional_value(0);

        // Using the Option values just with pattern match and test
        if (Option::is_some(&opt_some)) {
            let some_val = Option::borrow(&opt_some);
            // call test function on the value inside Some
            test(*some_val)
        } else {
            0
        }
    }
}
//# run 0xA1::OptionTest::runner

//# run
script {
    use 0xA1::OptionTest;

    fun main() {
        let val = 5u64;
        // test add and test functions
        let result = OptionTest::test(val);
        let opt_val_some = OptionTest::optional_value(val);
        let opt_val_none = OptionTest::optional_value(0);

        // just read values (we are ignoring assertions)
        if (std::option::is_some(&opt_val_some)) {
            let inner = std::option::borrow(&opt_val_some);
            // call add on inner, checking no error
            OptionTest::add(*inner, 100);
        };
    }
}