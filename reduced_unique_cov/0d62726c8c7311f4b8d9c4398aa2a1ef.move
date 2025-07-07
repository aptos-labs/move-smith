
//# publish
module 0xCAFE::CalcModule {
    use std::signer;

    /// Simple function that adds two u8 values and returns a fixed u8 value 42
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        42u8
    }

    /// Function with a lambda (anonymous function) that multiplies a u8 by 2 and adds a constant
    public fun lambda_example(x: u8): u8 {
        let multiply_by_two: |u8|u8 has copy+drop = |v: u8| {
            v * 2
        };
        let doubled = multiply_by_two(x);
        let add_five: |u8|u8 has copy+drop = |v: u8| {
            v + 5
        };
        add_five(doubled)
    }

    /// Inline function returning a tuple of two u64 values
    public inline fun inline_tuple(x: u64): (u64, u64) {
        (x + 1, x * 2)
    }

    /// Invariant enforcing that the sum of the two fields is less than 100
    struct InvariantStruct has key, store {
        a: u8,
        b: u8
    }
    invariant [self] {
        self.a + self.b < 100
    }

    /// Create InvariantStruct with values that satisfy invariant
    public fun create_invariant_struct(s: signer, a: u8, b: u8) {
        assert!(a + b < 100, 999);
        let obj = InvariantStruct { a, b };
        move_to<InvariantStruct>(&s, obj);
    }

    /// Get the sum of fields from InvariantStruct stored at signer address
    public fun get_sum(s: signer): u8 {
        let obj_ref = borrow_global<InvariantStruct>(signer::address_of(&s));
        obj_ref.a + obj_ref.b
    }

    /// Global invariant that checks some constant condition (just an example)
    spec module {
        invariant global_invariant {
            1u8 + 1u8 == 2u8
        }
    }

    /// Function that performs various integer, boolean, byte, and hex operations and returns true if all are valid
    public fun complex_operations_test(): bool {
        let b1 = 5u8 < 10u8;
        let b2 = false || true;
        let b3 = !false;
        let b4 = (15u8 >> 2) == 3u8;
        let b5 = (5u8 & 3u8) == 1u8;
        let b6 = (0xAeu8 ^ 0xFFu8) == 0x51u8;
        let b7 = (3u8 + 4u8 * 2u8) == 11u8;
        let byte_str = b"test\nline";
        let hex_str = x"ABCDEF";

        b1 && b2 && b3 && b4 && b5 && b6 && b7 && vector::length(&byte_str) == 9 && vector::length(&hex_str) == 3
    }
}


//# publish
module 0xCAFE::UseInline {
    use 0xCAFE::CalcModule;

    /// Function calling inline_tuple from CalcModule and summing its returned elements
    public fun nested_inline_call(x: u64): u64 {
        let (a, b) = CalcModule::inline_tuple(x);
        a + b
    }
}


//# run 0xCAFE::CalcModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::CalcModule::lambda_example --args 7u8


//# run 0xCAFE::UseInline::nested_inline_call --args 5u64


//# run 0xCAFE::CalcModule::complex_operations_test


//# run 0xCAFE::CalcModule::create_invariant_struct --signers 0xDEAD --args 40u8 50u8


//# run 0xCAFE::CalcModule::get_sum --signers 0xDEAD


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 3ea5beee6df2e4d0b7ced8ade6f7eb75: Write invariants (data invariants and global invariants) for structs and modules to enforce and verify global and local properties.
// 01c07410bb29126435b9a267dac6f7bf: Verify that various integer, boolean, byte, and hexadecimal operations—including comparisons, logical operators, shifts, arithmetic, and bitwise operations—evaluate correctly and produce expected results.
// 589bafd564685e861ca60dff00b00b06: Associate type parameters with spec apply patterns
