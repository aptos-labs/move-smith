
//# publish
module 0xCAFE::SpecFeatures {
    use std::debug;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    struct Rectangle has copy, drop, store {
        top_left: Point,
        bottom_right: Point,
    }

    spec Point {
        invariant self.x <= self.y;
        invariant self.x + self.y <= 100;
        let z: u64 = 42;

        function addition(a: u64, b: u64): u64 {
            a + b
        }

        spec fun get_x(self: &Point): u64 {
            self.x
        }

        spec fun get_y(self: &Point): u64 {
            self.y
        }

        // Code rich spec block
        const CONST_VAL: u64 = 999;

        function complex_spec_func(a: u64, b: u64): u64 {
            let temp = (a + b) * CONST_VAL;
            temp / 2
        }
    }

    spec Rectangle {
        invariant self.top_left.x <= self.bottom_right.x;
        invariant self.top_left.y >= self.bottom_right.y;
        spec fun width(self: &Rectangle): u64 {
            self.bottom_right.x - self.top_left.x
        }
    }

    public fun unpack_point(p: Point): u64 {
        // Destructure with named field unpacking
        let Point {x, y} = p;
        x + y
    }

    public fun create_point(x: u64, y: u64): Point {
        Point {x, y}
    }

    public fun create_rectangle(
        tl: Point,
        br: Point
    ): Rectangle {
        Rectangle {top_left: tl, bottom_right: br}
    }

    public fun unpack_rectangle(rect: Rectangle): u64 {
        let Rectangle {top_left, bottom_right} = rect;
        let Point {x: x1, y: y1} = top_left;
        let Point {x: x2, y: y2} = bottom_right;
        // Just sum all coordinates here
        x1 + y1 + x2 + y2
    }

    public fun call_spec_functions() {
        let p = Point {x: 3, y: 4};
        let rectangle = Rectangle {top_left: p, bottom_right: Point {x: 10, y: 1}};
        let _ = Point::addition(5, 6);
        let _ = Point::complex_spec_func(2, 3);
        let _ = Rectangle::width(&rectangle);
    }
}


//# run 0xCAFE::SpecFeatures::unpack_point --args 5u64 10u64


//# run 0xCAFE::SpecFeatures::create_point --args 7u64 8u64


//# run 0xCAFE::SpecFeatures::create_rectangle --args 5u64 5u64 10u64 1u64


//# run 0xCAFE::SpecFeatures::unpack_rectangle --args 5u64 6u64 8u64 2u64


//# run 0xCAFE::SpecFeatures::call_spec_functions


// Featurres:
// ee5a0f621a575cb5ff249c843181b8ec: Create code-rich spec sections enclosed in '{' and '}' within a spec block.
// 4d17e29b8395df65d47bd8c1abe74d5f: Destructure structs in 'let' statements using named field unpacking.
// 47a2fb680c8ad45b47ce3cbb8cb7ce80: Define and use comma-separated lists of items (such as function parameters, struct fields, or type arguments) in Move source code.
