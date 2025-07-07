//# publish
module 0xCAFE::FailAttributes {
    use std::vector;

    struct Dummy has copy, drop {
        val: u8
    }

    #[fail] // Expected failure attribute with no parameters
    public fun fail_no_param() {
        let x = 1u8;
        let _ = x + 1u8;
    }

    #[fail] // Another fail without parameters
    public fun fail_another() {
        let s = Dummy { val: 5u8 };
        let _ = s.val;
    }

    // Function capturing a primitive variable and returning a closure that uses it
    public fun captured_primitive_closure(x: u8): |u8| u8 has copy+drop {
        let captured = x + 10u8;
        let closure = |y: u8| {
            captured + y
        };
        closure
    }

    // Function capturing a struct variable and returning a closure using it
    public fun captured_struct_closure(x: u8): |u8| u8 has copy+drop {
        let dummy = Dummy { val: x };
        let closure = |y: u8| {
            dummy.val + y
        };
        closure
    }

    fun _dummy_runner() {
        let closure1 = captured_primitive_closure(5u8);
        let _ = closure1(3u8);

        let closure2 = captured_struct_closure(7u8);
        let _ = closure2(2u8);
    }
}

//# run 0xCAFE::FailAttributes::fail_no_param

//# run 0xCAFE::FailAttributes::fail_another

//# run 0xCAFE::FailAttributes::captured_primitive_closure --args 10u8

//# run 0xCAFE::FailAttributes::captured_struct_closure --args 20u8

// Featurres:
// 42b25b93e4183728f064e19bece2cde4: Annotate code with expected failure attributes that do not take any parameters or assigned values.
// 65dff158b55a6f29b2a47bb6a97de359: Test that functions with captured variables (including primitives and structs) correctly retain their environment and produce expected results when invoked with specific arguments.
// 1b8090c716e7400a1b3e5125a5644828: Automatically add dependency edges from modules outside the `vector` dependency closure to the `vector` module if it exists.
