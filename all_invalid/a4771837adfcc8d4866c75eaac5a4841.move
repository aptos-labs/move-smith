//# publish
module 0xCAFE::EvalTest {
    use std::signer;

    struct Counter has store {
        count: u8,
    }

    public fun create_counter(s: signer) {
        let c = Counter {count: 0};
        move_to<Counter>(&s, c);
    }

    public fun get_count(s: signer): u8 {
        let c_ref: &Counter = borrow_global<Counter>(signer::address_of(&s));
        c_ref.count
    }

    fun increment_counter(s: signer) {
        let c_ref_mut: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        c_ref_mut.count = c_ref_mut.count + 1;
    }

    public fun test_short_circuit_and(s: signer): u8 {
        // reset count
        let c_ref_mut = borrow_global_mut<Counter>(signer::address_of(&s));
        c_ref_mut.count = 0;

        // left side false short-circuits right side (which increments)
        if (false && {increment_counter(s); true}) {
            // never run
        } else {
            // do nothing
        };
        let c_ref_1: &Counter = borrow_global<Counter>(signer::address_of(&s));
        let count_after_first = c_ref_1.count;

        // left side true, right side executes and increments
        if (true && {increment_counter(s); true}) {
            // do nothing
        };
        let c_ref_2: &Counter = borrow_global<Counter>(signer::address_of(&s));
        let count_after_second = c_ref_2.count;

        // Final output: low nibble count_after_first, high nibble count_after_second
        // e.g. 0x12 means first 1, second 2
        (count_after_first as u8) + ((count_after_second as u8) << 4)
    }

    public fun test_short_circuit_or(s: signer): u8 {
        // reset count
        let c_ref_mut = borrow_global_mut<Counter>(signer::address_of(&s));
        c_ref_mut.count = 0;

        // left side true short-circuits right side (which increments)
        if (true || {increment_counter(s); false}) {
            // do nothing
        };
        let c_ref_1: &Counter = borrow_global<Counter>(signer::address_of(&s));
        let count_after_first = c_ref_1.count;

        // left side false, right side executes and increments
        if (false || {increment_counter(s); true}) {
            // do nothing
        };
        let c_ref_2: &Counter = borrow_global<Counter>(signer::address_of(&s));
        let count_after_second = c_ref_2.count;

        // Final output: low nibble count_after_first, high nibble count_after_second
        (count_after_first as u8) + ((count_after_second as u8) << 4)
    }

    struct Nested has copy, drop {
        a: u8,
        b: u8,
    }

    struct Outer has copy, drop {
        x: u8,
        nested: Nested,
    }

    public fun test_positional_unpacking(): u8 {
        let o = Outer { x: 10u8, nested: Nested {a: 20u8, b: 30u8} };

        // Positional unpacking of outer struct: x and nested fields
        let Outer(x_val, nested_val) = o;

        // Positional unpacking of nested struct via reference
        let nested_ref = &nested_val;
        let Nested(a_val, b_val) = *nested_ref;

        // sum all values
        x_val + a_val + b_val
    }
}

//# run 0xCAFE::EvalTest::create_counter --signers 0xBEEF

//# run 0xCAFE::EvalTest::test_short_circuit_and --signers 0xBEEF

//# run 0xCAFE::EvalTest::test_short_circuit_or --signers 0xBEEF

//# run 0xCAFE::EvalTest::test_positional_unpacking

// Featurres:
// 7be173a5fe61e0236a3078da9563f47b: Define modules, scripts, or addresses that can be used in the Move codebase.
// 4eed1d44c7a27e29c3c4204b709fb414: Test that short-circuit evaluation in boolean expressions correctly skips or executes side-effects within code blocks for '&&' and '||' operators.
// f2ddebe7ab5d5fec40a8fffc3a2b297b: Process positional unpacking of struct fields in Move code, including nested unpacking of variable references.
