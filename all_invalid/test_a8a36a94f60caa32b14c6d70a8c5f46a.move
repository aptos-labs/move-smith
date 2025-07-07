module 0xabcde::mut_ref_tests {
    // Function that multiplies a mutable reference by 3
    fun triple(r: &mut u64): &mut u64 {
        *r *= 3;
        r
    }

    // Function that decreases a mutable reference's value by a given delta
    fun decrease_by(r: &mut u64, delta: u64) {
        *r -= delta;
    }

    // Runner function to test mutability and modification
    public fun run_mutable_tests() {
        let x = 5;
        *{triple(&mut x)} += 2; // x should become (5 *3)+2=17
        assert!(x == 17, 1);

        // Further modification
        *{decrease_by(&mut x, 7)}; // x should become 10
        assert!(x == 10, 2);
    }
}

//# publish
module 0xabcde::resource_borrow_tests {
    struct Config<T> has key {
        value: T
    }

    fun init_resource(s: &signer) {
        move_to(s, Config<u64> { value: 42 });
    }

    // Function that borrows global resource, expecting type match
    fun get_config_value() reads Config<u64> {
        let config_ref = borrow_global<Config<u64>>(@0x1);
        config_ref.value
    }

    // Function that attempts to borrow a mismatched type, should error (simulate)
    // Note: In actual Move, this would be a compile error, but for the test, we just demonstrate an attempt.
    // We include it as a commented example or as a placeholder because the test framework may not catch it at runtime.
    // fun get_wrong_type() reads Config<bool> {
    //     borrow_global<Config<bool>>(@0x1).value
    // }

    // Runner to initialize resource and test borrows
    public fun run_borrow_tests() {
        // Init global resource
        init_resource(@0x1);
        // Borrow with matching type
        let val = get_config_value();
        assert!(val == 42, 3);
        // The following line is commented out because it would cause a type error at compile time
        // get_wrong_type();
    }
}

//# publish
module 0xabcde::inline_func_tests {
    inline fun compute_sum(f: |u64| u64, g: |u64| u64, x: u64): u64 {
        f(x) + g(x)
    }

    fun identity(_: u64): u64 {
        _ // identity function
    }

    fun double(x: u64): u64 {
        x * 2
    }

    // Test that `compute_sum` applies functions correctly
    public fun run_inline_tests() {
        let res1 = compute_sum(|_| 1, |_| 2, 10); // should return 1+2=3
        assert!(res1 == 3, 4);

        let res2 = compute_sum(::identity, ::double, 4); // should be 4 + 8=12
        assert!(res2 == 12, 5);
    }
}

//# run --verbose -- 0xabcde::mut_ref_tests::run_mutable_tests
//# run --verbose --signers 0x1 -- 0xabcde::resource_borrow_tests::run_borrow_tests
//# run --verbose -- 0xabcde::inline_func_tests::run_inline_tests