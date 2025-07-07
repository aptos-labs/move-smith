
//# publish
module 0xCAFE::PhantomTest {
    use std::marker;

    // Define struct with a phantom type parameter
    struct PhantomStruct<T> has copy, drop, store {
        value: u8,
        phantom: marker::phantom<T>,
    }

    // Define struct without phantom for control
    struct NormalStruct has copy, drop, store {
        x: u8,
        y: u8,
    }

    // Function to create a PhantomStruct<T> given a value
    public fun make_phantom<T>(x: u8): PhantomStruct<T> {
        PhantomStruct<T> {value: x, phantom: marker::phantom}
    }

    // Function that captures a primitive and a struct and returns a closure using them
    public fun captured_primitive_and_struct(x: u8, s: NormalStruct):
        |u8, u8|(u8, u8) {
        let lambda: |u8, u8|(u8, u8) has copy + drop = 
            move |a: u8, b: u8| {
                // Use captured x and s fields with arguments
                let r1 = a + x + s.x;
                let r2 = b + s.y;
                (r1, r2)
            };
        lambda
    }

    // Runner function testing the phantom struct creation and closure capturing
    public fun runner(): (u8, u8, u8) {
        let p = make_phantom<u64>(42u8);
        let s = NormalStruct {x: 3u8, y: 4u8};
        let lambda = captured_primitive_and_struct(10u8, s);

        let (r1, r2) = lambda(1u8, 2u8);

        // Return sum of phantom value, and closure output
        (p.value, r1, r2)
    }
}
