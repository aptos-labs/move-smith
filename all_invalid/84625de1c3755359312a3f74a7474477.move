
//# publish
module 0xBADD::TestModule {
    use std::vector;

    // Test struct with fields
    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    // Test enum with multiple variants
    enum Direction has copy, drop {
        North,
        East,
        South,
        West,
        Custom(u8, u8),
        Named { name: bool },
    }

    // Public function that returns a Point
    public fun create_point(x: u64, y: u64): Point {
        Point { x, y }
    }

    // Function with match expression with block in arm
    public fun move_direction(dir: Direction): u64 {
        match (dir) {
            Direction::North => {
                1
            }
            Direction::East => {
                2
            }
            Direction::South => {
                3
            }
            Direction::West => {
                4
            }
            Direction::Custom(a, b) => {
                a + b
            }
            Direction::Named { name } => {
                if (name) {
                    99
                } else {
                    0
                }
            }
        }
    }

    // Function with if-else condition and nested expressions
    public fun compare_points(p1: Point, p2: Point): u8 {
        if (p1.x > p2.x) {
            1
        } else {
            if (p1.y > p2.y) {
                2
            } else {
                3
            }
        }
    }

    // Function demonstrating match with expressions
    public fun handle_direction(dir: Direction): u8 {
        match (dir) {
            Direction::North => 10,
            Direction::East => 20,
            Direction::South => 30,
            Direction::West => 40,
            Direction::Custom(a, b) => {
                a + b
            }
            Direction::Named { name } => {
                if (name) {
                    255
                } else {
                    0
                }
            }
        }
    }

    // Inline fun with generic type parameter
    public inline fun identity<T>(val: T): T {
        val
    }

    // Function calling inline generic
    public fun test_identity() {
        let v1 = identity<u8>(5u8);
        let v2 = identity<bool>(true);
        let v3 = identity<Point>(Point { x: 1, y: 2 });
    }

    // Function with vector usage, including push and pop
    public fun vector_ops() {
        let v: vector<u64> = vector::empty<u64>();
        vector::push_back(&v, 100);
        vector::push_back(&v, 200);
        let first = *vector::borrow(&v, 0);
        let last = vector::pop_back(&v);
        let second = *vector::borrow(&v, 0);
    }
}



//# run 0xBADD::TestModule::move_direction --args 0u8

//# run 0xBADD::TestModule::move_direction --args 1u8

//# run 0xBADD::TestModule::move_direction --args 2u8

//# run 0xBADD::TestModule::move_direction --args 3u8

//# run 0xBADD::TestModule::move_direction --args 4u8

//# run 0xBADD::TestModule::move_direction --args 5u8


//# run 0xBADD::TestModule::compare_points --args 1u64 2u64

//# run 0xBADD::TestModule::compare_points --args 5u64 3u64

//# run 0xBADD::TestModule::compare_points --args 1u64 4u64


//# run 0xBADD::TestModule::handle_direction --args 0u8

//# run 0xBADD::TestModule::handle_direction --args 1u8

//# run 0xBADD::TestModule::handle_direction --args 2u8

//# run 0xBADD::TestModule::handle_direction --args 3u8

//# run 0xBADD::TestModule::handle_direction --args 4u8

//# run 0xBADD::TestModule::handle_direction --args 5u8


//# run 0xBADD::TestModule::test_identity

//# run 0xBADD::TestModule::vector_ops
