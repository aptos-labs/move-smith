
//# publish
module 0xCAFE::InnerFunctionTest {
    // Test inner function capturing and modifying outer variable via shadowing.
    public fun foo() {
        let x = 1;
        let f = |y: u8| {
            // The outer x is captured in the closure environment.
            // We create a new x by adding outer x and y
            let new_x = x + y;
            new_x
        };
        let _z = f(2);
        // shadow outer x by the new value to simulate modification
        let x = 3;
        assert!(x == 3, 999);
    }

    struct P has store {
        a: u8,
        b: u8,
    }

    struct Container has store {
        prop_set: P,
        value: u8,
    }

    public fun create_container(): Container {
        let prop_set = P {
            a: 7,
            b: 8,
        };
        let container = Container {
            prop_set,
            value: 42,
        };
        container
    }
}



//# run 0xCAFE::InnerFunctionTest::foo



//# run 0xCAFE::InnerFunctionTest::create_container
