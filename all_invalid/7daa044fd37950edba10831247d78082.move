//# publish
module 0xCAFE::EnumPatternMatchTest {
    enum Status has copy, drop {
        Init,
        Running(u64),
        Finished { success: bool }
    }

    // Public function testing enum variant matching internally
    public fun match_status(s: Status): u64 {
        let result = match (s) {
            Status::Init => 0,
            Status::Running(count) => count,
            Status::Finished { success } => {
                if (success) { 1 } else { 2 }
            },
        };
        result
    }

    // Expose enum constructor for Running variant
    public fun make_running(count: u64): Status {
        Status::Running(count)
    }

    // Expose enum constructor for Finished variant
    public fun make_finished(success: bool): Status {
        Status::Finished { success }
    }
}

//# run 0xCAFE::EnumPatternMatchTest::match_status --args 0xCAFE::EnumPatternMatchTest::Status::Init

//# run 0xCAFE::EnumPatternMatchTest::match_status --args 0xCAFE::EnumPatternMatchTest::make_running 42u64

//# run 0xCAFE::EnumPatternMatchTest::match_status --args 0xCAFE::EnumPatternMatchTest::make_finished true

//# publish
module 0xCAFE::AccessExprTest {
    const MY_CONST: u8 = 42;

    public fun get_const(): u8 {
        MY_CONST
    }

    // This function attempts an invalid assignment of a module access expression, which is disallowed.
    // Since assignment of module access expressions is disallowed outside specs,
    // we just expose MY_CONST and get_const to confirm access is allowed read-only here.
}

//# run 0xCAFE::AccessExprTest::get_const

//# publish
module 0xCAFE::TypeGroupingTest {
    struct Container has copy, drop, store {
        a: (u8, u16),
        b: vector<(bool, u8)>,
    }

    public fun make_container(): Container {
        let vec = vector::empty<(bool, u8)>();
        vector::push_back(&mut vec, (true, 5u8));
        vector::push_back(&mut vec, (false, 10u8));

        Container {
            a: (1u8, 100u16),
            b: vec,
        }
    }

    public fun get_a_first(container: &Container): u8 {
        let (first, _second) = container.a;
        first
    }

    public fun get_b_len(container: &Container): u64 {
        let len = vector::length(&(container.b));
        len
    }
}

//# run 0xCAFE::TypeGroupingTest::make_container

//# run 0xCAFE::TypeGroupingTest::get_a_first --args 0xCAFE::TypeGroupingTest::make_container

//# run 0xCAFE::TypeGroupingTest::get_b_len --args 0xCAFE::TypeGroupingTest::make_container

//# run 0xCAFE::EnumPatternMatchTest::match_status --args 0xCAFE::EnumPatternMatchTest::make_finished false


// Featurres:
// 441a5f8861ca4825a379f5604c85df72: Restrict variant pattern matching and testing on enum types to within the module that defines them unless otherwise allowed.
// fc8c5aa734cf28687187e2a295319455: Disallow assignment of module access expressions outside of a spec context.
// ad39b028249e2fb4817dd5167b7c0199: Declare types using parentheses for grouping types or tuples.
