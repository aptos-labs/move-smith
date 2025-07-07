//# publish
module 0xA11C::capture_tests {
    struct DataStruct has drop, copy {
        value: u128,
        flag: bool,
    }

    // Capture a primitive and use it inside the closure
    public fun capture_primitive(x: u64): u64 {
        let f = |y| x + y;
        f(10)
    }

    // Capture a struct and a primitive, combine their values
    public fun capture_struct_and_primitive(f: u32, s: DataStruct): u64 {
        let closure = |delta| s.value as u64 + delta + (if s.flag {1} else {0});
        closure(f as u64)
    }

    // Capture within nested structs and verify the captured environment
    public fun nested_capture(val: u16, s: DataStruct): u64 {
        struct Outer {
            inner: DataStruct,
            multiplier: u8,
        }

        let outer = Outer { inner: s, multiplier: 2 };
        let f = |x| outer.inner.value as u64 * outer.multiplier as u64 + x as u64;
        f(val as u64)
    }

    // Capture a primitive, but modify the captured variable before calling
    public fun modify_capture(x: u8): u8 {
        let mut captured = x;
        let f = |y| {
            captured = captured + y;
            captured
        };
        f(5)
    }

    // Capture an array (vector) of primitives and sum them
    public fun capture_array(arr: vector<u64>): u64 {
        let sum_fn = |_| {
            let mut total = 0u64;
            let len = vector::length(&arr);
            let mut i = 0;
            while (i < len) {
                total = total + *vector::borrow(&arr, i);
                i = i + 1;
            }
            total
        };
        sum_fn()
    }
}

//# run 0xA11C::capture_tests::capture_primitive --args 42
//# run 0xA11C::capture_tests::capture_struct_and_primitive --args 5 0x1 { value: 100, flag: true }
//# run 0xA11C::capture_tests::nested_capture --args 7 0x1 { value: 200, flag: false }
//# run 0xA11C::capture_tests::modify_capture --args 3
//# run 0xA11C::capture_tests::capture_array --args 1u64 2u64 3u64 4u64