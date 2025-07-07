
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}


//# publish
module 0xCAFE::ComputeAdd {
    public fun add_then_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(5u8, 6u8)
    }

    public fun call_inline_and_return(a: u16): u16 {
        let (x, _y) = 0xCAFE::MyModule::f2(a);
        x
    }

    public fun test_typed_binding_optional() {
        let x: u8 = 10u8;
        let y = 20u8;
        let z: u8 = x + y;
    }
}



//# run 0xCAFE::ComputeAdd::add_then_increment --args 10u8 15u8



//# run 0xCAFE::ComputeAdd::run_lambda_example



//# run 0xCAFE::ComputeAdd::call_inline_and_return --args 100u16



//# run 0xCAFE::ComputeAdd::test_typed_binding_optional



//# publish
module 0xCAFE::ControlStructEnum {
    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    enum Direction has copy, drop {
        North,
        East,
        South,
        West(u8),
    }

    public fun manipulate_point_and_direction(): u8 {
        let p = Point {x: 0u8, y: 0u8};
        let d = Direction::West(10u8);

        // mutable reference to p
        let p_ref: &mut Point = &mut p;

        // control flow: loop increments p.x until p.x == 5
        loop {
            if (p_ref.x == 5) {
                break;
            };
            p_ref.x = p_ref.x + 1;
        };

        let val = match (d) {
            Direction::North => 1u8,
            Direction::East => 2u8,
            Direction::South => 3u8,
            Direction::West(distance) => p_ref.x + distance,
        };

        val
    }
}



//# run 0xCAFE::ControlStructEnum::manipulate_point_and_direction
