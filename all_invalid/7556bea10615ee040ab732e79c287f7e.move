
//# publish
module 0xCAFE::FilterAndMath {
    use std::vector;
    use std::string;

    /// Structure to associate an address with a vector of module names
    struct AddrModules has copy, drop, store {
        address: address,
        modules: vector<vector<u8>>, // Vector of module name byte vectors
    }

    /// Filters addresses that have at least one module whose name starts with 'A' (0x41)
    public fun filter_addresses_with_module_starting_a(addrs: vector<AddrModules>): vector<AddrModules> {
        let result = vector::empty<AddrModules>();
        let len = vector::length(&addrs);
        let i = 0;
        while (i < len) {
            let addr_mod = vector::borrow(&addrs, i);
            let has_a_module = false;
            let mod_len = vector::length(&addr_mod.modules);
            let j = 0;
            while (j < mod_len) {
                let mod_name = vector::borrow(&addr_mod.modules, j);
                let first_char = *vector::borrow(mod_name, 0);
                if (first_char == 0x41) { // ASCII 'A'
                    has_a_module = true;
                    break;
                };
                j = j + 1;
            };
            if (has_a_module) {
                vector::push_back(&mut result, *addr_mod);
            };
            i = i + 1;
        };
        result
    }

    /// Simple helper function to create AddrModules struct
    public fun make_addr_modules(addr: address, modules: vector<vector<u8>>): AddrModules {
        AddrModules {
            address: addr,
            modules
        }
    }

    /// Unsigned 16-bit integer addition with overflow check
    public fun add_u16(a: u16, b: u16): u16 {
        let sum = a + b;
        // Overflow if sum < either operand because of wraparound for unsigned
        assert!(sum >= a && sum >= b, 1);
        sum
    }

    /// Unsigned 16-bit integer subtraction with underflow check
    public fun sub_u16(a: u16, b: u16): u16 {
        assert!(a >= b, 2);
        a - b
    }

    /// Unsigned 16-bit integer multiplication with overflow check
    public fun mul_u16(a: u16, b: u16): u16 {
        if (a == 0 || b == 0) {
            0
        } else {
            let product = a * b;
            assert!(product / b == a, 3);
            product
        }
    }

    /// Unsigned 16-bit integer division with division by zero check
    public fun div_u16(a: u16, b: u16): u16 {
        assert!(b != 0, 4);
        a / b
    }

    /// Unsigned 16-bit integer modulo with division by zero check
    public fun mod_u16(a: u16, b: u16): u16 {
        assert!(b != 0, 5);
        a % b
    }

    /// Runner function to test math operations with safe values
    public fun runner() {
        let _ = add_u16(1000u16, 2345u16);
        let _ = sub_u16(5000u16, 1234u16);
        let _ = mul_u16(100u16, 20u16);
        let _ = div_u16(5000u16, 5u16);
        let _ = mod_u16(5000u16, 7u16);
    }

    /// Runner function to test error conditions, expects aborts
    public fun runner_abort_overflow() {
        // This addition overflows max u16 (65535)
        let _ = add_u16(60000u16, 6000u16);
    }

    public fun runner_abort_sub_underflow() {
        let _ = sub_u16(123u16, 234u16);
    }

    public fun runner_abort_mul_overflow() {
        // This multiplication overflows u16 max
        let _ = mul_u16(1000u16, 1000u16);
    }

    public fun runner_abort_div_zero() {
        let _ = div_u16(10u16, 0u16);
    }

    public fun runner_abort_mod_zero() {
        let _ = mod_u16(10u16, 0u16);
    }
}


//# run 0xCAFE::FilterAndMath::runner


//# run 0xCAFE::FilterAndMath::runner_abort_overflow


//# run 0xCAFE::FilterAndMath::runner_abort_sub_underflow


//# run 0xCAFE::FilterAndMath::runner_abort_mul_overflow


//# run 0xCAFE::FilterAndMath::runner_abort_div_zero


//# run 0xCAFE::FilterAndMath::runner_abort_mod_zero


// Featurres:
// bd55926960feba0d24f5bc21babb44c0: Filter addresses and their associated modules based on specific criteria.
// 527abebfabb1ebd69e625fa68b433419: Test that unsigned 16-bit integer arithmetic operations (addition, subtraction, multiplication, division, and modulus) behave correctly for valid inputs and properly fail or trigger errors on overflows or divisions by zero।
// 0e7641c7be14eddbfc10d5c5ff9b6a45: Skip specific lint checks for your code by listing their names in the #[skip(...)] attribute.
