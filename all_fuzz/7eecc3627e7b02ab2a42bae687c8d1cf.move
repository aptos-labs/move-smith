
//# publish
module 0xCAFE::ClosureTest {

    // Simple struct with public properties
    struct Properties has store {
        a: u8,
        b: u8,
        c: u8,
    }

    // Public function 'foo' accepts a closure and calls it.
    // Demonstrates capturing and shadowing outer variable 'x'.
    public fun foo() {
        let x = 1u8;
        // closure that shadows x and mutates outer x by capturing it via reference pattern (simulate)
        let inner_func = || {
            x = 3u8;
        };
        inner_func();
        // outer x updated to 3
        // (If needed, you could return x or assert its value here to test)
    }

    // Another function to test capture and modification of outer variable by reference-like pattern.
    public fun foo_with_capture(): u8 {
        let x = 1u8;
        let f = || {
            let x_inner = x + 2u8;
            x_inner
        };
        let x = f();
        x
    }

    // Testing multiple arguments passed in a call separated by commas
    public fun multiple_args_test(x: u8, y: u8, z: u8): u8 {
        x + y + z
    }

    // Function that returns a Properties struct with a property set and expressions
    // Demonstrates construction using expressions
    public fun create_properties(): Properties {
        Properties {
            a: 1u8,
            b: 2u8 + 3u8,
            c: 4u8 * 5u8,
        }
    }

    // Nested functions with captured variables that perform arithmetic
    public fun nested_functions(): u8 {
        let x = 1u8;
        let inc = |v: u8| {
            v + x
        };
        let inner = || {
            let y = 2u8;
            inc(y)
        };
        inner() + x
    }

    // Function composition with captures
    public fun compose_functions(): u8 {
        let x = 2u8;
        let f = |v: u8| v + x;
        let g = |v: u8| f(v) * 2u8;
        g(3u8)
    }
}



//# run 0xCAFE::ClosureTest::foo



//# run 0xCAFE::ClosureTest::foo_with_capture



//# run 0xCAFE::ClosureTest::multiple_args_test --args 1u8 2u8 3u8



//# run 0xCAFE::ClosureTest::create_properties



//# run 0xCAFE::ClosureTest::nested_functions



//# run 0xCAFE::ClosureTest::compose_functions


// Extra attributes tests outside functions and structs

// my_attr]

// my_attr = 42]

// my_attr(Param1)]

// We write an empty module with attributes to test attribute syntax

// my_attr = 123u8]
// my_attr("hello")]

//# publish
module 0xCAFE::AttributeTest {
    public fun empty() {}
}
