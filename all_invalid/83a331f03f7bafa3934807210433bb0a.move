
//# publish
module 0xCAFE::ClosureShadowing {
    use std::debug;

    // deprecated = 123]
    // custom = 0xCAFE::ClosureShadowing]
    struct Dummy has copy, drop {}

    const CONST_VAL: u8 = 42;

    // test_attr(const_val = 10u8, module_ref = 0xCAFE::ClosureShadowing)]
    struct AnnotatedStruct has copy, drop {
        value: u8
    }

    // property_set(name = "TestProperties",
                   prop1 = CONST_VAL + 1,
                   prop2 = 0xCAFE::ClosureShadowing::CONST_VAL * 2)]
    struct PropertySetStruct has copy, drop {}

    public fun foo(x: u8, f: |u8| u8): u8 {
        // f shadows the captured x but we test updating x through shadow
        let x = f(x);
        x
    }

    public fun runner(): u8 {
        let x = 1u8;

        let f = |x_param: u8| {
            // shadow outer x by inner x_param but return 3 to update outer x
            3u8
        };

        let x = foo(x, f);
        debug::print(&x);
        x
    }
}


//# run 0xCAFE::ClosureShadowing::runner


// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// acf0a8237c18af53c3ab3a951204da8b: Annotate your Move code with attributes that have either constant values or module-qualified identifiers as their values.
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
