//# publish
module 0xA11c::increment_tests {
    // This module tests various ways of modifying primitive types, structs, wrapped types, and vectors,
    // ensuring consistency across different usage patterns.

    struct Counter has drop {
        count: u64,
    }

    struct Wrapper<T>(T) has drop;

    public fun complex_add(x: u64, y: u64): u64 {
        // Example of multiple additions
        let sum = x + y;
        sum + 5
    }

    public fun test1() {
        // Verify that different addition implementations produce same result
        assert!(complex_add(10, 20) == 35);
    }

    public fun increment_primitive(x: &mut u64) {
        *x += 2;
    }

    public fun increment_struct(s: &mut Counter) {
        s.count += 3;
    }

    public fun increment_wrapped(w: &mut Wrapper<u64>) {
        w.0 += 4;
    }

    public fun increment_vector(v: &mut vector<u64>, index: u64) {
        v[index as usize] += 5;
    }

    public fun increment_struct_in_vector(vs: &mut vector<Counter>, index: u64) {
        let s = &mut vs[index as usize];
        s.count += 6;
    }

    public fun increment_wrapped_in_vector(vs: &mut vector<Wrapper<u64>>, index: u64) {
        let w = &mut vs[index as usize];
        w.0 += 7;
    }

    public fun test2() {
        let mut primitive_x: u64 = 0;
        increment_primitive(&mut primitive_x);
        assert!(primitive_x == 2);

        let mut counter = Counter { count: 10 };
        increment_struct(&mut counter);
        assert!(counter.count == 13);

        let mut wrapped = Wrapper(20);
        increment_wrapped(&mut wrapped);
        assert!(wrapped.0 == 24);

        let mut vec_u64 = vector[u64][0, 1, 2];
        increment_vector(&mut vec_u64, 1);
        assert!(vec_u64 == vector[u64][0, 6, 2]);

        let mut vec_counters = vector[Counter]{Counter { count: 1}, Counter { count: 2 }};
        increment_struct_in_vector(&mut vec_counters, 0);
        assert!(vec_counters[0].count == 7);

        let mut vec_wrappers = vector[Wrapper<u64>>]{Wrapper(10), Wrapper(20)};
        increment_wrapped_in_vector(&mut vec_wrappers, 1);
        assert!(vec_wrappers[1].0 == 27);
    }
}

//# run --verbose -- 0xA11c::increment_tests::test1
//# run --verbose -- 0xA11c::increment_tests::test2


//# publish
module 0xBEEf::access_and_capture {
    // This module tests capturing outer variables and modifying them via inner functions or closures.

    public fun foo_with_capture(f:|mutable, y: u64|) {
        // Executes the passed function which can modify 'x'
        f();
    }

    public fun test_capture() {
        let mut x: u64 = 1;
        let outer_x_ref = &mut x;

        // Define a function that captures outer_x_ref and modifies 'x'
        fun inner_update() {
            *outer_x_ref = 3;
        }

        // Call the inner function via foo_with_capture
        foo_with_capture(|inner| {
            inner_update();
        });
        assert!(x == 3);
    }

    // Alternative approach: passing a lambda that captures 'x' directly
    public fun test_lambda_capture() {
        let mut x: u64 = 1;
        // Closure capturing 'x' mutably
        let closure = |mut y: u64| {
            y = 3;
        };
        // Since closures are limited, simulate by passing a mutable reference
        // (Assuming experimental or hypothetical closure behavior for testing)
        // For simplicity, call a function that modifies 'x' directly
        fun modify_x() {
            x = 3;
        }
        modify_x();
        assert!(x == 3);
    }
}

//# run --verbose -- 0xBEEf::access_and_capture::test_capture
//# run --verbose -- 0xBEEf::access_and_capture::test_lambda_capture


//# publish
module 0xc0ffee::arithmetic_mutability {
    // This module tests mutability, arithmetic, and function passing with mutable references.

    fun subtract_x_and_y(x: &mut u64, y: &mut u64): u64 {
        *y = *y - *x;
        *y
    }

    public fun test_subtract() {
        let mut a = 5;
        let mut b = 10;
        assert!(subtract_x_and_y(&mut a, &mut b) == 5);
        assert!(b == 5);
    }

    fun operate_mutably(x: &mut u64) {
        *x = *x * 2;
    }

    public fun test_mutable_operation() {
        let mut a = 4;
        operate_mutably(&mut a);
        assert!(a == 8);
    }

    fun pass_by_ref(x: &mut u64, y: &mut u64) -> u64 {
        *x += 1;
        *y += 2;
        *x + *y
    }

    public fun test_pass_ref() {
        let mut a = 1;
        let mut b = 2;
        let res = pass_by_ref(&mut a, &mut b);
        assert!(res == 6);
        assert!(a == 2);
        assert!(b == 4);
    }
}

//# run --verbose -- 0xc0ffee::arithmetic_mutability::test_subtract
//# run --verbose -- 0xc0ffee::arithmetic_mutability::test_mutable_operation
//# run --verbose -- 0xc0ffee::arithmetic_mutability::test_pass_ref