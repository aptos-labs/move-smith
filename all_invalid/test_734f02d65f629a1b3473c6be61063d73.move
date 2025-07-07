//# publish
module 0xA11c::test_loop_with_return {

    fun run_loop_with_unconditional_return() {
        // Loop with an unconditional return inside
        loop {
            return;
        }
        // Code here should be skipped
        assert!(false, 123);
    }

    public fun test_unconditional_return_in_loop() {
        run_loop_with_unconditional_return();
    }
}

//# run 0xA11c::test_loop_with_return::test_unconditional_return_in_loop


//# publish
module 0xBEEf::mutable_ref_and_loop {

    fun update_and_check(mut x: &mut u64): bool {
        *x = *x + 5;
        *x > 10
    }

    public fun main(): u64 {
        let mut value = 2;
        let mut i = 0;
        while (update_and_check(&mut value)) {
            i = i + 1;
            if (i >= 3) {
                break;
            }
        }
        value
    }
}

//# run 0xBEEf::mutable_ref_and_loop::main --signers 0xBEEf


//# publish
module 0xC0FFEE::map_transform {

    use std::option;

    public inline fun map<Element, OtherElement>(
        t: option::Option<Element>,
        f: |Element| OtherElement
    ): option::Option<OtherElement> {
        if (option::is_some(&t)) {
            option::some(f(option::extract(&mut t)))
        } else {
            option::none()
        }
    }

    // Additional function that applies map to a nested option
    public fun apply_map_to_option(opt: option::Option<u64>): option::Option<u64> {
        map(opt, |e| e * 2)
    }
}

//# publish
module 0xC0FFEE::test_map {

    use std::option;
    use 0xC0FFEE::map_transform;

    public fun test(): u64 {
        let some_value = option::some(7);
        let mapped = map_transform::apply_map_to_option(some_value);
        option::extract(&mut mapped) // should be 14
    }
}

//# run 0xC0FFEE::test_map::test
