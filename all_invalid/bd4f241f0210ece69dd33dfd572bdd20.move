
//# publish
module 0xCAFE::MathUtils {
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun is_prime(n: u64): bool {
        if (n < 2) { false } else {
            let i = 2u64;
            let prime = true;
            while (i * i <= n) {
                if (n % i == 0) {
                    prime = false;
                    break;
                };
                i = i + 1;
            };
            prime
        }
    }

    // Removed the use of &fun pointer; instead directly inline the logic
    public fun lambda_add_then_const(x: u8, y: u8): u8 {
        let sum = add_u8(x, y);
        sum + 5u8
    }

    // To test combining inline function calls across modules
    public fun nested_add(a: u8, b: u8, c: u8): u8 {
        let ab = add_u8(a, b);
        add_u8(ab, c)
    }

    // Dummy attribute location simulator
    struct AttrLocation has copy, drop {
        start: u64,
        end: u64
    }

    public fun get_attr_location(): AttrLocation {
        AttrLocation { start: 42u64, end: 99u64 }
    }

    public fun multi_value_iteration(): u64 {
        let values = Vector::from_bytes(b"\x0a\x00\x00\x00\x00\x00\x00\x00\
                                        \x14\x00\x00\x00\x00\x00\x00\x00\
                                        \x1e\x00\x00\x00\x00\x00\x00\x00");
        let keys = Vector::from_bytes(b"\x03\x00\x00\x00\x00\x00\x00\x00\
                                     \x06\x00\x00\x00\x00\x00\x00\x00\
                                     \x09\x00\x00\x00\x00\x00\x00\x00");

        let sum = 0u64;
        let len = 3;
        let i = 0; // changed i to mutable so can reassign

        while (i < len) {
            let v = *Vector::borrow(&values).borrow(i);
            let k = *Vector::borrow(&keys).borrow(i);
            sum = sum + v + k;
            i = i + 1;
        };
        sum
    }
}



//# run 0xCAFE::MathUtils::add_u8 --args 12u8 34u8



//# run 0xCAFE::MathUtils::lambda_add_then_const --args 7u8 8u8



//# run 0xCAFE::MathUtils::nested_add --args 1u8 2u8 3u8



//# run 0xCAFE::MathUtils::get_attr_location



//# run 0xCAFE::MathUtils::multi_value_iteration



//# run 0xCAFE::MathUtils::is_prime --args 1u64



//# run 0xCAFE::MathUtils::is_prime --args 2u64



//# run 0xCAFE::MathUtils::is_prime --args 17u64



//# run 0xCAFE::MathUtils::is_prime --args 20u64
