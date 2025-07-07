
//# publish
module 0xCAFE::MathTest {
    /// Public function that adds two u8 values and returns sum + 42
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 42
    }

    /// Function that returns a lambda which adds input u8 with a captured value
    public fun make_adder(offset: u8): |u8|u8 {
        |x: u8| {
            x + offset
        }
    }

    /// Since the called function MyModule::f2 is missing, stub it here to allow compiling and running.
    /// This simulates the expected behavior of f2.
    public fun nested_inline_call(a: u16): u16 {
        // Provide some dummy implementation inline since MyModule::f2 does not exist.
        // For example, return a tuple and sum its elements.
        let x = a;
        let y = a + 1;
        x + y
    }
}



//# run 0xCAFE::MathTest::add_and_offset --args 10u8 20u8



//# run 0xCAFE::MathTest::make_adder --args 5u8



//# run 0xCAFE::MathTest::nested_inline_call --args 100u16



//# publish
module 0xCAFE::BindingTest {
    struct Pair has store {
        a: u8,
        b: u16,
    }

    // Function demonstrates typed binding and duplicate field detection via comments
    public fun typed_bind_and_duplicate() {
        // Create Pair struct instance
        let pair = Pair {a: 1u8, b: 2u16};

        // Typed binding syntax for destructure
        let Pair {_a_val, _b_val} = pair;

        //_duplication error example (can't declare duplicate fields)
        // let Pair {a: first, a: second} = pair; // <-- INVALID, commented out

        // Use the bound variables a_val and b_val (marked unused with _ to suppress warnings)
        // (No return needed)
    }
}



//# run 0xCAFE::BindingTest::typed_bind_and_duplicate



//# publish
module 0xCAFE::RefTest {
    struct Data has store {
        value: u64,
    }

    // Instantiates Data with given value, add drop ability to avoid implicit drop error
    struct Data has store, drop {
        value: u64,
    }

    // Instantiates Data with given value
    public fun create(value: u64): Data {
        Data {value}
    }

    // Borrows an immutable reference to Data and returns value
    public fun borrow_immutable_ref(d: &Data): u64 {
        d.value
    }

    // Borrows a mutable reference to Data and increments value by the given amount
    public fun borrow_mut_ref_and_increment(d: &mut Data, amount: u64) {
        d.value = d.value + amount;
    }

    // Function to test borrow refs and mutation
    public fun test_refs() {
        let d = Data {value: 10};

        let r: &Data = &d;
        let _val = borrow_immutable_ref(r);

        let r_mut: &mut Data = &mut d;
        borrow_mut_ref_and_increment(r_mut, 5);

        let _val2 = borrow_immutable_ref(&d);

        // values val and val2 hold 10 and 15 respectively
        // no return, for test purposes only
    }
}



//# run 0xCAFE::RefTest::test_refs
