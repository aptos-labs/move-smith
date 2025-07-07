//# publish
module 0x123::interaction_tests {
    struct Point has copy, drop {
        x: u64,
        y: u64,
    }

    enum Status has drop {
        Active,
        Inactive,
        Error(u8),
    }

    fun create_point(): Point {
        Point { x: 10, y: 20 }
    }

    fun update_point(p: &mut Point, dx: u64, dy: u64) {
        p.x = p.x + dx;
        p.y = p.y + dy;
    }

    fun print_status(s: &Status): bool {
        match (s) {
            Status::Active => true,
            Status::Inactive => false,
            Status::Error(code) => *code == 255,
        }
    }

    fun toggle_status(s: &mut Status) {
        match (s) {
            Status::Active => *s = Status::Inactive,
            Status::Inactive => *s = Status::Active,
            Status::Error(code) => *s = Status::Error(*code / 2),
        }
    }

    fun sum_coords(p: &Point): u64 {
        p.x + p.y
    }

    fun build_enum_chain(flag: bool): Status {
        if (flag) {
            Status::Error(255)
        } else {
            Status::Active
        }
    }

    fun test_struct_enum() {
        let mut p = create_point();
        update_point(&mut p, 5, 5);
        let coord_sum = sum_coords(&p);
        // Create status enums
        let mut s1 = Status::Active;
        toggle_status(&mut s1);
        let s2 = build_enum_chain(false);
        let s3 = build_enum_chain(true);

        // test pattern matching on enum
        assert!(print_status(&s1) == true);
        assert!(print_status(&s2) == true);
        assert!(print_status(&s3) == true);
        // toggle error status
        toggle_status(&mut (s3));
        // test that error code is halved
        match (s3) {
            Status::Error(code) => assert!(code == 127),
            _ => assert!(false), // should not reach here
        }
        // test the sum of coords
        assert!(coord_sum == 20);
    }
}

//# run --verbose -- 0x123::interaction_tests::test_struct_enum
