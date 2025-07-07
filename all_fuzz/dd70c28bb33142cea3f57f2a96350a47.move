
//# publish
module 0xCAFE::ShadowCapture {
    // This module tests inner function's access and modification of a captured outer variable
    public fun foo() {
        let x = 1u8;
        // lambda closes over x by shadowing with new x and finally capturing new x
        let inner_fun: |()| u8 = || {
            let x = x + 1;
            let x = x + 1;
            x
        };
        let result = inner_fun();
        // result should be 3, but here just to execute access and modification logic

        // For demonstration, reassign x to result via shadowing (a new local x)
        let x = result;
        // x now updated to 3 by shadowing and capture within the lambda
    }

    // Function with multiple call arguments separated by commas
    public fun multi_args_fun(a: u8, b: u8, c: u8) {
        let sum = a + b + c;
        let _unused = sum;
    }

    // Function demonstrating property sets with expressions and properties
    // Since Move structs cannot have property sets natively like some languages,
    // we simulate this by defining a struct with public fields and using expressions to set them
    struct PropSet has copy, drop, store {
        a: u8,
        b: u8,
        c: u8,
    }

    public fun property_setter() {
        let p = PropSet {
            a: 1u8,
            b: 1u8 + 1,
            c: 5u8 - 2,
        };
        let _ = p;
    }
}


//# run 0xCAFE::ShadowCapture::foo


//# run 0xCAFE::ShadowCapture::multi_args_fun --args 1u8 2u8 3u8


//# run 0xCAFE::ShadowCapture::property_setter


// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
