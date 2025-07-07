
//# publish
module 0xCAFE::DottedExpressions {
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    struct Line has copy, drop, store {
        start: Point,
        end: Point,
    }

    public fun new_point(x: u64, y: u64): Point {
        Point { x, y }
    }

    public fun new_line(x1: u64, y1: u64, x2: u64, y2: u64): Line {
        let p1 = new_point(x1, y1);
        let p2 = new_point(x2, y2);
        Line { start: p1, end: p2 }
    }

    public fun distance_x(line: &Line): u64 {
        // Access nested fields via dotted expression
        if (line.end.x > line.start.x) {
            line.end.x - line.start.x
        } else {
            line.start.x - line.end.x
        }
    }

    public fun distance_y(line: &Line): u64 {
        if (line.end.y > line.start.y) {
            line.end.y - line.start.y
        } else {
            line.start.y - line.end.y
        }
    }

    public fun total_distance(line: &Line): u64 {
        distance_x(line) + distance_y(line)
    }

    public fun runner(): u64 {
        let line = new_line(10, 20, 15, 25);
        total_distance(&line)
    }
}


//# run 0xCAFE::DottedExpressions::runner



//# publish
module 0xCAFE::TypeCheckValidation {
    use 0xCAFE::DottedExpressions;

    struct Wrapper has copy, drop, store {
        p: DottedExpressions::Point,
        label: vector<u8>,
    }

    public fun create_wrapper(x: u64, y: u64, label: vector<u8>): Wrapper {
        let pt = DottedExpressions::new_point(x, y);
        Wrapper { p: pt, label }
    }

    public fun get_point_x(wrapper: &Wrapper): u64 {
        // Access nested module struct
        wrapper.p.x
    }

    public fun get_label_length(wrapper: &Wrapper): u64 {
        vector::length(&wrapper.label) as u64
    }

    public fun runner(): u64 {
        let label = b"test_label";
        let wrapper = create_wrapper(7, 8, vector::from_bytes(label));
        get_point_x(&wrapper) + get_label_length(&wrapper)
    }
}


//# run 0xCAFE::TypeCheckValidation::runner



//# publish
module 0xCAFE::ModuleIdentifierAccess {
    use 0xCAFE::DottedExpressions;
    use 0xCAFE::TypeCheckValidation;

    public fun access_other_modules(): (u64, u64) {
        // Call functions from other modules by specifying address and name
        let dx = 0xCAFE::DottedExpressions::distance_x(&DottedExpressions::new_line(3,4,7,10));
        let label_len = 0xCAFE::TypeCheckValidation::get_label_length(&TypeCheckValidation::create_wrapper(1, 1, b"ok"));
        (dx, label_len)
    }

    public fun runner(): (u64, u64) {
        access_other_modules()
    }
}


//# run 0xCAFE::ModuleIdentifierAccess::runner


// Featurres:
// 232b89599d79eae82e64e4ab36d5a3e8: Create dotted expressions involving field access.
// 8a4214d7f93d2bf8a5968333d6e54117: Write code that uses the Move type checker to validate modules and scripts for correctness.
// a4ced2ee76fee4b1c8a50dfdf54ba003: Access a module's identifier by specifying its address and name.
