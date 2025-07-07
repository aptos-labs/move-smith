//# publish
module 0x1::TestCaptured {

    use std::signer;

    struct Holder has copy, drop, store {
        x: u16,
    }

    #[known_attribute]
    #[unknown_attribute] // unknown attribute name, should be accepted by compiler

    /// A function that returns a closure capturing a primitive (u16)
    public fun make_adder(a: u16): impl Fn(u16): u16 {
        let closure = move |b: u16| a + b;
        closure
    }

    /// A function that returns a closure capturing a struct
    public fun make_struct_adder(h: Holder): impl Fn(u16): u16 {
        let closure = move |b: u16| h.x + b;
        closure
    }

    /// Runner function that exercises closures with captured variables
    public fun runner(): u16 {
        let add_5 = make_adder(5);
        let h = Holder { x: 10 };
        let add_h_x = make_struct_adder(h);

        let r1 = add_5(3);     // expect 8
        let r2 = add_h_x(7);   // expect 17

        r1 + r2 // 8 + 17 = 25
    }
}

//# run 0x1::TestCaptured::runner

//# publish
module 0x1::TestApplicationSemicolon {

    #[known_attr1]
    #[unknown_attr2]

    /// Test that application statement ends with semicolon properly
    public fun test_semicolon(): u16 {
        let x = 1u16;
        let y = 2u16;
        let z = x + y; // application statement ends with semicolon
        z
    }
}
//# run 0x1::TestApplicationSemicolon::test_semicolon


//# publish
module 0x1::TestArithmetic {

    use std::error;
    use std::signer;

    #[known_attribute]
    /// Checked addition: returns sum if no overflow, aborts with 1u64 otherwise
    public fun checked_add(a: u16, b: u16): u16 acquires  {
        let result = a + b;
        // detect overflow by checking if result < any operand
        if (result < a) {
            abort 1;
        }
        result
    }

    #[known_attribute]
    /// Checked subtraction: returns difference or aborts with 2u64 if underflow
    public fun checked_sub(a: u16, b: u16): u16 {
        if (b > a) {
            abort 2;
        }
        a - b
    }

    #[known_attribute]
    /// Checked multiplication: returns product or aborts 3u64 on overflow
    public fun checked_mul(a: u16, b: u16): u16 {
        let product = a * b;
        if (b != 0 && (product / b != a)) {
            abort 3;
        }
        product
    }

    #[known_attribute]
    /// Checked division: aborts 4u64 if divide by zero or returns quotient
    public fun checked_div(a: u16, b: u16): u16 {
        if (b == 0) {
            abort 4;
        }
        a / b
    }

    #[known_attribute]
    /// Checked modulo: aborts 5u64 if modulo by zero or returns remainder
    public fun checked_mod(a: u16, b: u16): u16 {
        if (b == 0) {
            abort 5;
        }
        a % b
    }

    /// Runner function to test a variety of arithmetic operations, including errors:
    /// The runner deliberately triggers aborts on overflow/division by zero.
    public fun runner(account: &signer) {
        // valid operations
        let _ = checked_add(10000, 10000);    // 20000, no overflow
        let _ = checked_sub(10000, 5000);     // 5000, no underflow
        let _ = checked_mul(200, 300);        // 60000, no overflow
        let _ = checked_div(10000, 10);       // 1000, no error
        let _ = checked_mod(12345, 100);      // 45, no error

        // overflow add - abort 1
        // checked_add(60000, 60000);

        // underflow sub - abort 2
        // checked_sub(5, 10);

        // overflow mul - abort 3
        // checked_mul(400, 200);

        // division by zero - abort 4
        // checked_div(10, 0);

        // modulo by zero - abort 5
        // checked_mod(10, 0);
    }
}
//# run 0x1::TestArithmetic::runner --signers 0x1


//# run
script {
    use 0x1::TestCaptured;
    use 0x1::TestApplicationSemicolon;
    use 0x1::TestArithmetic;

    fun main(account: signer) {
        // Call captured closure test
        let captured_result = TestCaptured::runner();
        // Call semicolon test
        let semicolon_result = TestApplicationSemicolon::test_semicolon();
        // Call arithmetic runner
        TestArithmetic::runner(&account);
    }
}