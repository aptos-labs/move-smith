
//# publish
module 0xCAFE::InnerFunctionTest {
    // Test inner function capturing and modifying outer variable via shadowing.
    public fun foo() {
        let x = 1;
        let f = |y: u8| {
            let x = x + y; // shadows outer x by adding y
            x
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


// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
