
//# publish
module 0xBADD::TestInlineAndGenerics {
    use std::vector;

    struct Point<X, Y> has copy, drop, store {
        // layout("x: u64, y: u64")]
        x_coord: X,
        // layout("x: u64, y: u64")]
        y_coord: Y,
    }

    public fun inline_double(val: u8): u8 {
        val + val
    }

    public fun create_point<X: copy + drop, Y: copy + drop>(x: X, y: Y): Point<X, Y> {
        let p = Point {x, y};
        let doubled_x = inline_double(p.x_coord as u8);
        let doubled_y = inline_double(p.y_coord as u8);
        Point {x_coord: doubled_x as X, y_coord: doubled_y as Y}
    }

    public inline fun sum_two_u16(a: u16, b: u16): u16 {
        a + b
    }

    public fun test_struct_layout() {
        let p: Point<u64, u64> = create_point(7u64, 8u64);
        let _x = p.x_coord;
        let _y = p.y_coord;
        stay;
    }

    public fun test_inline_call() {
        let result = sum_two_u16(10u16, 20u16);
        stay;
    }
}

//# run 0xBADD::TestInlineAndGenerics::test_struct_layout


//# run 0xBADD::TestInlineAndGenerics::test_inline_call


// Featurres:
// f014b399e4686074b1fe7647b8e38e9b: Call inline functions within other functions to have them expanded at call sites.
// 62335aa7e34bb5c4b4fab043e532fdfa: Declare structs with type parameters
// 3794a54a82966bcb4bcc23ef66a9fbd9: Describe the layout of struct fields explicitly using layout annotations.
