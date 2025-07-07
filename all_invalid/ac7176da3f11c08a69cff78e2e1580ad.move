//# publish
module 0xCAFE::InlineLambdaTest {
    /// A struct with no fields just to organize functions.
    struct Collector has store {}

    /// An inline function that accepts a lambda returning u64 and returns u64
    fun apply_and_double<F: copy + drop + store>(f: &F): u64
        where F: Fn() -> u64
    {
        let result = f();
        result * 2
    }

    /// A function to test combining two lambda results:
    /// Runs two lambdas, combines their results by addition.
    fun combine_lambdas<F1, F2>(f1: &F1, f2: &F2): u64
        where F1: Fn() -> u64,
              F2: Fn() -> u64
    {
        f1() + f2()
    }

    /// Runner function that uses the inline functions with lambdas and returns a final sum.
    public fun runner(): u64 {
        let res1 = apply_and_double(&move || 5);
        let res2 = apply_and_double(&move || 3);
        let sum = combine_lambdas(&move || res1, &move || res2);
        sum
    }

    spec module {
        /// Spec for runner.
        fun runner_spec(): u64;
        /// Proof that runner returns expected 5*2 + 3*2 = 10 + 6 = 16
        spec fun proof_runner() {
            let r = runner();
            assert!(r == 16, 1);
        }
    }
}
//# run 0xCAFE::InlineLambdaTest::runner

//# publish
module 0xCAFE::AnnotatedStructVariants {
    use std::option;

    /// Attributes on struct variants are supported - annotate with an attribute.
    #[addr(0xCAFE)]
    struct MyVariant has copy, store {
        one: u64,
    }

    #[addr(0xDEAD)]
    struct MyVariant2 has copy, store {
        two: bool,
    }

    /// An enum with two variants as a struct tagging pattern.
    // Note: Move doesn't support enum variants with attributes directly,
    // but it supports struct variants that we can annotate.
    struct EnumWrapper has store {
        variant_one: option::Option<MyVariant>,
        variant_two: option::Option<MyVariant2>,
    }

    public fun new_enum_wrapper(): EnumWrapper {
        EnumWrapper {
            variant_one: option::some(MyVariant { one: 42 }),
            variant_two: option::none<MyVariant2>(),
        }
    }

    /// Runner function returning 1 if variant_one present with one=42, else 0.
    public fun runner(): u64 acquires EnumWrapper {
        let enum_val = new_enum_wrapper();
        if (option::is_some(&enum_val.variant_one)) {
            let v = option::borrow(&enum_val.variant_one);
            if (v.one == 42) {
                1
            } else {
                0
            }
        } else {
            0
        }
    }
}
//# run 0xCAFE::AnnotatedStructVariants::runner

//# publish
module 0xCAFE::SpecBlocks {
    /// A struct with some field, to write specs for it.
    struct SpecStruct has store {
        x: u8,
        y: u64,
    }

    public fun new_spec_struct(x: u8, y: u64): SpecStruct {
        SpecStruct { x, y }
    }

    /// A public function that returns sum inside SpecStruct
    public fun sum(ss: &SpecStruct): u64 {
        (ss.x as u64) + ss.y
    }

    /// A runner that returns sum(SS) with example values.
    public fun runner(): u64 {
        let s = new_spec_struct(10, 32);
        sum(&s)
    }

    spec struct SpecStruct {
        var spec_x: u8;
        var spec_y: u64;

        invariant spec_x <= 100;
        invariant spec_y >= 0;
    }

    spec module {
        /// Specifies constructor sets fields correctly
        fun new_spec_struct_spec(x: u8, y: u64): SpecStruct {
            new_spec_struct(x, y)
        }

        /// Specification for sum function: returns sum of fields
        fun sum_spec(ss: &SpecStruct): u64 {
            (ss.x as u64) + ss.y
        }

        /// Runner spec correctness: sum(10,32) == 42
        spec fun proof_runner() {
            let s = new_spec_struct(10, 32);
            let res = sum(&s);
            assert!(res == 42, 1);
        }
    }
}
//# run 0xCAFE::SpecBlocks::runner

// Featurres:
// b8d7ff4ae6d6e90875a046b42d7e209a: Test that the inline functions accepting lambda parameters correctly compute and combine their results to produce the expected sum.
// c0c9c254b1d78a10525d37ba3131e85a: Annotate struct variants with attributes
// 4802739e395318325d8585930d38a715: Write Move specification blocks (spec blocks) containing multiple specification members.
