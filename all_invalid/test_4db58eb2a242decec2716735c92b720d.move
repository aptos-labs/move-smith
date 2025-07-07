//# publish
module 0x10::struct_enum_test {
    struct S4 has copy, drop {
        a: u8,
        b: u64,
    }

    struct S5 {
        x: u16,
        y: bool,
    }

    enum E2 {
        Variant1,
        Variant2(S4),
        Variant3(u32, bool),
    }

    fun create_structs_and_enum(): (S4, S5, E2) {
        let s4 = S4 { a: 255, b: 9999 };
        let s5 = S5 { x: 1024, y: false };
        let e2 = E2::Variant2(s4);
        (s4, s5, e2)
    }

    fun test_assignments_and_match() {
        let s4 = S4 { a: 1, b: 2 };
        let mut s5 = S5 { x: 0, y: false };
        // mutable reference to s5
        let s5_ref = &mut s5;
        s5_ref.x = 2048;
        s5_ref.y = true;

        let e2_value: E2;
        if (s5.x > 1024) {
            e2_value = E2::Variant3(s5.x as u32, s5.y);
        } else {
            e2_value = E2::Variant1;
        }

        // Pattern match on enum
        match (e2_value) {
            E2::Variant1 => {
                // do nothing
            },
            E2::Variant2(s4_inner) => {
                s4_inner.a = s4_inner.a - 1;
            },
            E2::Variant3(val, bor) => {
                if (bor) {
                    s4.a = (val % 256) as u8;
                } else {
                    s4.b = val as u64;
                }
            }
        }
        // Use loops and control flow
        let mut count = 0;
        let mut temp_a = s4.a;
        while (temp_a > 0) {
            temp_a = temp_a - 1;
            count = count + 1;
        }
        count
    }

    fun create_and_match_enum(): u8 {
        let e = if (true) {
            E2::Variant2(S4 { a: 10, b: 500 })
        } else {
            E2::Variant3(42, false)
        };
        match (e) {
            E2::Variant1 => 0,
            E2::Variant2(s) => s.a,
            E2::Variant3(x, _) => (x % 10) as u8,
        }
    }

    fun test_control_flow_and_assign() {
        let mut s = S5 { x: 1, y: false };
        for _ in 0..5 {
            s.x = s.x + 1;
            if (s.x % 2 == 0) {
                s.y = true;
            } else {
                s.y = false;
            }
        }
        s.x + if (s.y) { 10 } else { 20 }
    }

    fun nested_loop_pattern_match() {
        let mut counter = 0;
        while (counter < 3) {
            let mut i = 0;
            loop {
                if (i >= 2) {
                    break;
                }
                match (i) {
                    0 => {
                        // do something
                        counter = counter + 1;
                        i = i + 1;
                    },
                    1 => {
                        i = i + 1;
                    },
                    _ => {
                        break;
                    },
                }
            }
        }
        counter
    }
}

//# run --verbose -- 0x10::struct_enum_test::test_assignments_and_match

//# run --verbose -- 0x10::struct_enum_test::create_and_match_enum

//# run --verbose -- 0x10::struct_enum_test::test_control_flow_and_assign

//# run --verbose -- 0x10::struct_enum_test::nested_loop_pattern_match