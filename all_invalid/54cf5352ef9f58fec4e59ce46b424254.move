
//# publish
module 0xCAFE::WarningSuppressor {
    // skip(boilerplate)]
    public fun suppressed_function(x: u8): u8 {
        let y = x + 1;
        y
    }

    // test]
    // test(inner_test)]
    public fun nested_test_attributes() {
        let a = 1u8;
        let b = 2u8;
        let _sum = a + b;
    }

    public fun bind_range_example() {
        let x = 10u8;
        let y = 20u8;

        let r1 = 0..5;
        let r2 = 6..10;

        // Pretend to bind ranges to context (conceptual, no actual binding code)
        let _bound_r1 = r1;
        let _bound_r2 = r2;

        let z = x + y;
        z
    }
}


//# run 0xCAFE::WarningSuppressor::suppressed_function --args 42u8


//# run 0xCAFE::WarningSuppressor::nested_test_attributes


//# run 0xCAFE::WarningSuppressor::bind_range_example


// Featurres:
// e909c181c5601375ca40711cd95148ab: Suppress warnings for specific checks by annotating functions or modules with `#[skip(checker_name)]`.
// 73703d960f7376d7a440b975128e33cd: Apply nested test attributes within main test attribute blocks to organize or configure tests.
// 6f53858d98e5fdab1fdd66c0cd78c269: Bind each range 'r' associated with variables to the unbound context, enabling correct scoping and usage.
