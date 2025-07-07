
//# publish
module 0xCAFE::DestructAndSpec {
    use std::signer;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    struct Rectangle has store {
        top_left: Point,
        bottom_right: Point,
        width_height: (u64, u64),
    }

    // Test mutable reference updates during construction and pattern matching with destructuring
    public fun create_and_update(x1: u64, y1: u64, x2: u64, y2: u64): Rectangle {
        // First create Points
        let p1 = Point { x: x1, y: y1 };
        let p2 = Point { x: x2, y: y2 };

        // Update p2 using mutable reference
        let p2_ref: &mut Point = &mut p2;
        p2_ref.x = p2_ref.x + 10;
        p2_ref.y = p2_ref.y + 20;

        // Construct Rectangle with destructuring assignment for width and height
        let width = p2.x - p1.x;
        let height = p2.y - p1.y;

        let rect = Rectangle {
            top_left: p1,
            bottom_right: p2,
            width_height: (width, height),
        };

        rect
    }

    // Pattern matching and destructuring for Rectangle
    public fun area(rect: Rectangle): u64 {
        let (w, h) = rect.width_height;
        w * h
    }

    // Test specification block target on struct Rectangle
    spec struct Rectangle {
        invariant field_width_positive: self.width_height.0 >= 0;
        invariant field_height_positive: self.width_height.1 >= 0;
    }

    // Inline lambda function test: arithmetic mean of two u64s
    public fun inline_lambda_example(a: u64, b: u64): u64 {
        let mean: |u64, u64|u64 has copy+drop = |x: u64, y: u64| {
            (x + y) / 2
        };
        mean(a, b)
    }
}


//# run 0xCAFE::DestructAndSpec::create_and_update --args 5u64 5u64 10u64 10u64


//# run 0xCAFE::DestructAndSpec::inline_lambda_example --args 10u64 20u64


//# run
script {
    use 0xCAFE::DestructAndSpec;

    fun main() {
        // Create a rectangle
        let rect = DestructAndSpec::create_and_update(2u64, 3u64, 12u64, 13u64);

        // Compute area
        let a = DestructAndSpec::area(rect);

        // Call inline lambda
        let mean = DestructAndSpec::inline_lambda_example(100u64, 200u64);
    }
}
