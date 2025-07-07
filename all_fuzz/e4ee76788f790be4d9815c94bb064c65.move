
//# publish
module 0xCAFE::InnerFuncTest {
    public fun foo(mut_x: &mut u8, f: |()|()) {
        f();
        *mut_x = 3;
    }

    // A runner function to test foo and inner function variable capture/shadowing
    public fun test_inner_function() {
        let x = 1u8;
        // Define an inner function as a lambda that shadows outer x and updates outer x through mut ref
        let inner = || {
            let x = 2u8; // shadowing outer x
            *(&mut x) = 2; // update shadowed x (local)
            *mut_x = x + 1; // update outer x through pointer - Though outer x is in mut_x pointer
        };
        foo(&mut x, inner);
        // After foo, x should be updated to 3
    }

    public fun test_property_set() {
        let obj = Obj { a: 1u8, b: 2u8 };
        let new_obj = Obj { a: obj.a + 1, b: 5u8 };
        let _ = new_obj;
    }

    struct Obj has copy, drop {
        a: u8,
        b: u8,
    }
}


//# run 0xCAFE::InnerFuncTest::test_inner_function


//# run 0xCAFE::InnerFuncTest::test_property_set


// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
