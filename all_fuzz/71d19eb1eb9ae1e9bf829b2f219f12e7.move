
//# publish
module 0xCAFE::TestFeatures {
    use std::signer;

    // Define the enum E inside this module
    public enum E {
        V1,
        V2(u8, u8),
        V3 { a: bool }
    }

    // Define struct S
    struct S has key {
        x: u32,
        y: u32,
    }

    // Define a function f2 that returns a tuple (u8, u8)
    public fun f2(a: u16): (u8, u8) {
        // For simplicity, return low and high bytes of 'a' truncated to u8
        let low = (a & 0x00FF) as u8;
        let high = ((a >> 8) & 0x00FF) as u8;
        (low, high)
    }

    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10
        } else {
            sum
        };
        42u8
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let product = lambda(x, y);
        product + 1
    }

    public fun nested_inline_call(a: u16): u32 {
        let (x, y) = f2(a);
        let sum = (x as u32) + (y as u32);
        sum
    }

    public fun match_expression(e: E): u8 {
        let res = match (e) {
            E::V1 => 1u8,
            E::V2(x, y) => (x + y) as u8,
            E::V3 { a } => if (a) { 2u8 } else { 3u8 },
        };
        res
    }

    public fun reference_safety(s: signer) {
        let obj = S {x: 1u32, y: 2u32};
        move_to<S>(&s, obj);

        let obj_ref: &S = borrow_global<S>(signer::address_of(&s));
        let x_ref: &u32 = &(obj_ref.x);
        let y_ref: &u32 = &(obj_ref.y);
        let _sum = *x_ref + *y_ref;

        let obj_mut_ref: &mut S = borrow_global_mut<S>(signer::address_of(&s));
        obj_mut_ref.x = 10u32;
        obj_mut_ref.y = 20u32;

        let obj = move_from<S>(signer::address_of(&s));
        // consume the moved value by unpacking it; this avoids implicit drop
        let S { x: _, y: _ } = obj;
    }
}
