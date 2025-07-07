//# publish
module 0xCAFE::ArithmeticTest {
    // 1. Arithmetic operation tests for u16.
    // We will test normal cases, overflow, underflow, division by zero, modulo by zero.
    public fun test_add(): u16 {
        // Normal addition
        let a = 32767u16;
        let b = 2u16;
        a + b // Should yield 32769 (well under u16::MAX)
    }

    public fun test_add_overflow(): u16 {
        // This should overflow, expecting a Move abort
        let a = 65535u16;
        let b = 1u16;
        a + b // Should abort on overflow
    }

    public fun test_sub(): u16 {
        let a = 500u16;
        let b = 20u16;
        a - b // 480
    }

    public fun test_sub_underflow(): u16 {
        // This should underflow, expecting a Move abort
        let a = 0u16;
        let b = 1u16;
        a - b
    }

    public fun test_mul(): u16 {
        let a = 250u16;
        let b = 3u16;
        a * b // 750
    }

    public fun test_mul_overflow(): u16 {
        // Overflow, should abort
        let a = 5000u16;
        let b = 20u16;
        a * b // 100000, larger than 65535
    }

    public fun test_div(): u16 {
        let a = 100u16;
        let b = 4u16;
        a / b // 25
    }

    public fun test_div_zero(): u16 {
        // Should abort
        let a = 123u16;
        let b = 0u16;
        a / b
    }

    public fun test_mod(): u16 {
        let a = 101u16;
        let b = 10u16;
        a % b // 1
    }

    public fun test_mod_zero(): u16 {
        // Should abort
        let a = 101u16;
        let b = 0u16;
        a % b
    }

    // 2. Test id_mut
    public fun id_mut(x: &mut u16): &mut u16 { x }

    public fun test_mutation_via_id_mut(): u16 {
        let mut local = 123u16;
        let r = Self::id_mut(&mut local);
        *r = 777u16;
        local // Should now be 777
    }

    // 3. Field mutate with dotted and right-value
    struct Holder { v: u16 }
    struct Wrap { h: Holder }

    public fun test_field_mutate_expressions(): u16 {
        let mut x = Wrap { h: Holder { v: 10u16 } };
        // Right value field mutate (NOTE: This is invalid in Move; removed)
        // Wrap { h: Holder { v: 20u16 } }.h.v = 42u16;
        // Dotted field mutation
        x.h.v = 99u16;
        x.h.v // 99
    }

    // Runner so test case can call all in order
    public fun runner() {
        // normal cases
        ignore Self::test_add();
        ignore Self::test_sub();
        ignore Self::test_mul();
        ignore Self::test_div();
        ignore Self::test_mod();
        ignore Self::test_mutation_via_id_mut();
        ignore Self::test_field_mutate_expressions();
        // error cases will be invoked individually by run commands below
    }
}
//# run 0xCAFE::ArithmeticTest::runner --signers 0xCAFE
//# run 0xCAFE::ArithmeticTest::test_add_overflow --signers 0xCAFE
//# run 0xCAFE::ArithmeticTest::test_sub_underflow --signers 0xCAFE
//# run 0xCAFE::ArithmeticTest::test_mul_overflow --signers 0xCAFE
//# run 0xCAFE::ArithmeticTest::test_div_zero --signers 0xCAFE
//# run 0xCAFE::ArithmeticTest::test_mod_zero --signers 0xCAFE

// ------------- SCRIPT TESTS -------------
//# run
script {
    use 0xCAFE::ArithmeticTest;

    fun main() {
        // Test addition in script context
        let x = 100u16;
        let y = 20u16;
        let z = x + y;
        ignore z;
        // Test id_mut
        let mut a = 50u16;
        let p = ArithmeticTest::id_mut(&mut a);
        *p = 200u16;
        ignore a;
        // Test field mutate expression
        let mut holder = 0xCAFE::ArithmeticTest::Holder { v: 17u16 };
        holder.v = 99u16;
        ignore holder;
    }
}