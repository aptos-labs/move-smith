// --------------- 1. Phantom Type Parameters and Attributes ---------------
//# publish
module 0xA1::PhantomDemo {
    #[known_attribute]
    struct MyStruct<phantom T> has copy, drop { 
        #[unknown_attribute]
        val: u64,
    }

    // Phantom type parameter is unused directly
    public fun make_mystruct<T>(v: u64): MyStruct<T> {
        MyStruct { val: v }
    }

    public fun runner() {
        let _a = make_mystruct<u8>(100);
    }
}
//# run 0xA1::PhantomDemo::runner --signers 0xA1

// --------------- 2. Module Attribute Filtering ---------------
//# publish
// Filter: only compile modules with "FilterMe" in the name
#[filter_me]
module 0xA2::FilterMe {
    struct S has store { val: u8 }
    public fun runner() {
        let _ = S { val: 99 };
    }
}
//# run 0xA2::FilterMe::runner --signers 0xA2

//# publish
module 0xA3::DontFilterMe {
    struct S1 has store {}
    public fun runner() { let _ = S1{}; }
}
//# run 0xA3::DontFilterMe::runner --signers 0xA3

// --------------- 3. Specifications and Variable Bindings ---------------
//# publish
module 0xA4::Specs {
    struct Data has store { v: u64 }

    public fun new_data(x: u64): Data acquires Data {
        Data { v: x }
    }
    spec module {
        pragma aborts_if (false);
        let bound_val: u64 = 42;
        invariant bound_val == 42;
    }

    spec fun new_data {
        ensures result.v == x;
    }

    public fun runner() {
        let _d = new_data(123);
    }
}
//# run 0xA4::Specs::runner --signers 0xA4

// --------------- 4. Script - attributes and out-of-gas in loop ---------------
//# run
script {
    use std::signer;
    #[my_attr]
    fun loop_script(s: &signer) {
        let i = 0;
        let mut sum = 0u64;
        // Deliberately large loop to consume lots of gas
        // On execution, expect an out-of-gas error at runtime if the runtime gas limit is set small.
        while (i < 1_000_000) {
            sum = sum + i;
            i = i + 1;
        }
    }
}