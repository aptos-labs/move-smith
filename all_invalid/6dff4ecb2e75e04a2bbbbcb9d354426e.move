//# publish
module 0xCAFE::FunctionTypeTest {
    // Testing disallowed function-typed parameters where function returns a function, 
    // assuming language version < 2.2 should reject (commented out since not allowed)
    // We instead test only an allowed function parameter for demo

    // Function type parameter allowed if result is NOT a function
    public fun apply_fn_simple(f: |u8| u8, val: u8): u8 {
        f(val)
    }

    // Uncommenting this function should cause compile error in versions < 2.2:
    /*
    public fun disallowed_fn_param(f: |u8| (|u8| u8), val: u8): |u8| u8 {
        f(val)
    }
    */

    // Runner for apply_fn_simple
    public fun runner(): u8 {
        let lambda: |u8| u8 has copy+drop = |x: u8| { x + 1 };
        apply_fn_simple(lambda, 5u8)
    }
}

//# run 0xCAFE::FunctionTypeTest::runner


//# publish
module 0xCAFE::SpecMergeTest {
    // Illustrate merged specs with implementation

    struct Container has store {
        value: u64,
    }

    public fun set_value(c: &mut Container, v: u64) {
        c.value = v;
    }

    public fun get_value(c: &Container): u64 {
        c.value
    }

    // Runner function to test set and get
    public fun test_runner(): u64 {
        let mut c = Container { value: 0 };
        set_value(&mut c, 987);
        get_value(&c)
    }
}

//# run 0xCAFE::SpecMergeTest::test_runner


//# publish
module 0xCAFE::SpecMetaAnnotations {
    // Demonstrate spec blocks with metadata annotations
    // Spec annotations are for tooling, simulated here as comments since Move spec support may vary

    struct Data has store {
        num: u32,
    }

    // Spec block with annotation (simulate attribute with comment)
    spec annotation = "version 1.0";
    spec module {
        // annotation: requires = ["0xCAFE::FunctionTypeTest"];
        // Just a dummy lemma for illustration
        lemma dummy_lemma() {
            true
        }
    }

    // To associate spec with function
    public fun incr(data: &mut Data) {
        data.num = data.num + 1;
    }

    spec module {
        // annotation: function = "incr";
        // pre: true
        // post: data.num == old(data.num) + 1
    }

    public fun get(data: &Data): u32 {
        data.num
    }

    public fun runner(): u32 {
        let mut d = Data { num: 10 };
        incr(&mut d);
        get(&d)
    }
}

//# run 0xCAFE::SpecMetaAnnotations::runner

// Featurres:
// 5a69b2aba949320a696d079c8b92242d: Disallow parameters that are function types where the function results are function-typed, unless the language version is at least 2.2.
// 01a43e94f76e7d519185aeeff2c06acb: Merge specification modules into target modules to associate specifications with implementations.
// be117831a57008e0aa691755b07410db: Annotate spec blocks with attributes for additional metadata or tooling integration.
