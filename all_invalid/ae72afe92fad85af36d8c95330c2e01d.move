//# publish
module 0xCAFE::BigInt256 {
    use std::vector;
    use std::math;

    struct Uint256 has copy, drop, store {
        high: u128,
        low: u128
    }

    public fun add(a: Uint256, b: Uint256): Uint256 {
        let (low, carry) = math::u128_add_with_overflow(a.low, b.low);
        let high = a.high + b.high + (carry as u128);
        Uint256 { high, low }
    }

    public fun sub(a: Uint256, b: Uint256): Uint256 {
        let (low, borrow) = math::u128_sub_with_borrow(a.low, b.low);
        let high = a.high - b.high - (borrow as u128);
        Uint256 { high, low }
    }

    public fun mul(a: Uint256, b: Uint256): Uint256 {
        // Only multiply low parts for simplicity; full 256-bit mul is complex
        let low64 = (a.low as u64) * (b.low as u64);
        Uint256 { high: 0, low: low64 as u128 }
    }

    public fun div(a: Uint256, b: Uint256): Uint256 {
        assert!(b.high != 0 || b.low != 0, 101);
        // Division implementation simplified: assuming a fits in u128 and b fits in u128
        assert!(a.high == 0, 102);
        assert!(b.high == 0, 103);
        let divres = (a.low / b.low) as u128;
        Uint256 { high: 0, low: divres }
    }

    public fun mod(a: Uint256, b: Uint256): Uint256 {
        assert!(b.high != 0 || b.low != 0, 104);
        // Modulus simplified similarly to div
        assert!(a.high == 0, 105);
        assert!(b.high == 0, 106);
        let modres = (a.low % b.low) as u128;
        Uint256 { high: 0, low: modres }
    }

    friend 0xCAFE::FriendModule;
}

//# publish
module 0xCAFE::FriendModule {
    use 0xCAFE::BigInt256;

    // Access friend module feature
    public fun friend_add(a: BigInt256::Uint256, b: BigInt256::Uint256): BigInt256::Uint256 {
        BigInt256::add(a, b)
    }

    public fun friend_sub(a: BigInt256::Uint256, b: BigInt256::Uint256): BigInt256::Uint256 {
        BigInt256::sub(a, b)
    }

    public fun friend_mul(a: BigInt256::Uint256, b: BigInt256::Uint256): BigInt256::Uint256 {
        BigInt256::mul(a, b)
    }

    public fun friend_div(a: BigInt256::Uint256, b: BigInt256::Uint256): BigInt256::Uint256 {
        BigInt256::div(a, b)
    }

    public fun friend_mod(a: BigInt256::Uint256, b: BigInt256::Uint256): BigInt256::Uint256 {
        BigInt256::mod(a, b)
    }

    public fun direct_variable_usage(): u128 {
        let x = 5u128;
        let y = 7u128;
        // Use variable by name in expression
        let z = x * y + x - y;
        z
    }

    public fun variable_move_copy() {
        let x = 15u128;
        let y = x;
        // copy x and y, then add
        let sum = x + y;
        assert!(sum == 30, 200);

        let z = x;
        let _ = z; // move z (actually copy for u128)
    }

    // Runner function for friend call tests
    public fun runner_no_arg() {
        let a = BigInt256::Uint256 {high: 0, low: 20};
        let b = BigInt256::Uint256 {high: 0, low: 10};
        let _ = friend_add(a, b);
        let _ = friend_sub(a, b);
        let _ = friend_mul(a, b);
        let _ = friend_div(a, b);
        let _ = friend_mod(a, b);
    }
}

//# run 0xCAFE::FriendModule::direct_variable_usage

//# run 0xCAFE::FriendModule::variable_move_copy

//# run 0xCAFE::FriendModule::runner_no_arg

//# run 0xCAFE::BigInt256::add --args 0u128 20u128 0u128 30u128

//# run 0xCAFE::BigInt256::sub --args 0u128 50u128 0u128 25u128

//# run 0xCAFE::BigInt256::mul --args 0u128 10u128 0u128 20u128

//# run 0xCAFE::BigInt256::div --args 0u128 100u128 0u128 5u128

//# run 0xCAFE::BigInt256::mod --args 0u128 100u128 0u128 30u128

//# run 0xCAFE::BigInt256::div --args 0u128 100u128 0u128 0u128

//# run 0xCAFE::BigInt256::mod --args 0u128 50u128 0u128 0u128