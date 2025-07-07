//# publish
module 0xCAFE::SpecTest {
    use std::spec::global;

    spec module {
        global spec_var1: u64;
    }

    #[skip(box_unused)]
    public fun sum_two(a: u64, b: u64): u64 {
        let x: u64 = a;
        let y: u64 = b;
        let z: u64 = x + y;
        z
    }

    public fun runner(): u64 {
        let local_var: u64 = 100;
        let result = sum_two(local_var, 23);
        result
    }
}

//# run 0xCAFE::SpecTest::runner

// Featurres:
// 3237041cd3e3a0a9176d527051ce4718: Declare specification variables using either the 'global' or 'local' keyword in a spec block.
// 465eefaa6e81bf15308d01b6a6fa82e8: Test that local variable declaration, initialization, and summation work correctly within a function.
// 84c8cd1da70fe50076541bf9c4b58477: Annotate attributes with `#[skip(...)]` to specify lint checks to be skipped.
