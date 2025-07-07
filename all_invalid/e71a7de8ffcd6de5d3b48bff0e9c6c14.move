
//# publish
module 0xCAFE::SpecExample {
    use std::vector;
    use std::string;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    struct Rect has copy, drop, store {
        top_left: Point,
        bottom_right: Point,
    }

    spec struct Point {
        spec field x: u64;
        spec field y: u64;

        spec fun magnitude_squared(&self): u64 {
            self.x * self.x + self.y * self.y
        }
    }

    spec struct Rect {
        spec field top_left: Point;
        spec field bottom_right: Point;

        spec fun width(&self): u64 {
            if (self.top_left.x >= self.bottom_right.x) {
                0
            } else {
                self.bottom_right.x - self.top_left.x
            }
        }

        spec fun height(&self): u64 {
            if (self.top_left.y >= self.bottom_right.y) {
                0
            } else {
                self.bottom_right.y - self.top_left.y
            }
        }

        spec fun area(&self): u64 {
            self.width() * self.height()
        }
    }

    /// Creates a point given x and y coordinates.
    public fun new_point(x: u64, y: u64): Point {
        Point { x, y }
    }

    /// Creates a rect from two points
    public fun new_rect(top_left: Point, bottom_right: Point): Rect {
        Rect { top_left, bottom_right }
    }

    /// Computes the area of the rectangle
    public fun compute_area(r: &Rect): u64 {
        let w = r.bottom_right.x - r.top_left.x;
        let h = r.bottom_right.y - r.top_left.y;
        w * h
    }

    public fun example_spec_usage() {
        let p = new_point(3, 4);
        let msq = spec magnitude_squared(&p);

        let rect = new_rect(new_point(0, 5), new_point(10, 0));
        let w = spec width(&rect);
        let h = spec height(&rect);
        let a = spec area(&rect);
    }
}


//# run 0xCAFE::SpecExample::example_spec_usage


// Featurres:
// 4802739e395318325d8585930d38a715: Write Move specification blocks (spec blocks) containing multiple specification members.
// d7f37301c80f39e25c622a37f4594d19: Specify specifications and variable bindings with `Spec` expressions.
// 227ad258a66ad82ed33365ca2fc3d83a: Define structs with named fields in Move modules
