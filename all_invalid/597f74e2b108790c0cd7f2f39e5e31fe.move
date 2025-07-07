//# publish
module 0x1::ArithmeticTest {
    use std::error;

    // Testing unsigned 16-bit arithmetic correctness and overflow detection
    resource struct U16Wrapper {
        value: u16,
    }

    // Function to perform safe addition, returns error if overflow
    public fun add_u16(a: u16, b: u16): result<u16, u8> {
        if (a > u16::max_value() - b) {
            // overflow
            error::err(1)
        } else {
            error::ok(a + b)
        }
    }

    // Similarly for subtraction
    public fun sub_u16(a: u16, b: u16): result<u16, u8> {
        if (a < b) {
            // underflow
            error::err(2)
        } else {
            error::ok(a - b)
        }
    }

    // Multiplication
    public fun mul_u16(a: u16, b: u16): result<u16, u8> {
        if (a == 0 || b == 0) {
            error::ok(0)
        } else if (a > u16::max_value() / b) {
            // overflow
            error::err(3)
        } else {
            error::ok(a * b)
        }
    }

    // Division
    public fun div_u16(a: u16, b: u16): result<u16, u8> {
        if (b == 0) {
            error::err(4)
        } else {
            error::ok(a / b)
        }
    }

    // Modulus
    public fun mod_u16(a: u16, b: u16): result<u16, u8> {
        if (b == 0) {
            error::err(5)
        } else {
            error::ok(a % b)
        }
    }

    // Repeatedly modify a struct's field
    resource struct Counter {
        count: u64,
    }

    public fun new_counter(): Counter {
        Counter { count: 0 }
    }

    public fun increment_counter(counter: &mut Counter): u64 {
        counter.count = counter.count + 1;
        counter.count
    }

    // Function with a valid name and body
    public fun valid_function() {
        // simple no-op
    }

    // Enforce visibility restrictions
    // (Assuming private function to test restriction)
    fun private_helper() {
        // do nothing
    }

    // Declare abilities with 'has'
    resource struct AbleStruct has copy, drop, store {}

    // Incorporating parameters and free variables into modifications
    public fun modify_with_params(
        counter: &mut Counter,
        delta: u64,
        free_var: u64,
    ): u64 {
        counter.count = counter.count + delta + free_var;
        counter.count
    }

    // Runner function to test above
    public fun run_tests() {
        // Initialize counter
        let mut counter = new_counter();

        // Call increment multiple times
        let res1 = increment_counter(&mut counter);
        let res2 = increment_counter(&mut counter);
        // Results should be 1 and 2
        assert(res1 == 1);
        assert(res2 == 2);

        // Test arithmetic operations
        let add_res = add_u16(65535, 1); // overflow
        assert(add_res.is_err());
        let add_ok = add_u16(1000, 2000);
        assert(add_ok.is_ok());
        assert*(add_ok) == 3000;

        let sub_res = sub_u16(10, 20); // underflow
        assert(sub_res.is_err());
        let sub_ok = sub_u16(2000, 1000);
        assert(sub_ok.is_ok());
        assert*(sub_ok) == 1000;

        let mul_res = mul_u16(300, 300); // should overflow
        assert(mul_res.is_err());
        let mul_ok = mul_u16(10, 20);
        assert(mul_ok.is_ok());
        assert*(mul_ok) == 200;

        let div_err = div_u16(10, 0);
        assert(div_err.is_err());
        let div_ok = div_u16(10, 2);
        assert(div_ok.is_ok());
        assert*(div_ok) == 5;

        let mod_err = mod_u16(10, 0);
        assert(mod_err.is_err());
        let mod_ok = mod_u16(10, 3);
        assert(mod_ok.is_ok());
        assert*(mod_ok) == 1;

        // Test modify_with_params
        let result = modify_with_params(&mut counter, 5, 10);
        assert(result == 17); // 2 + 5 + 10 =17
        // Ensure counter.count updated
        assert(counter.count == 17);
    }
}
//# run
0x1::ArithmeticTest::run_tests()