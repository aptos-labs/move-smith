
//# publish
module 0xCAFE::ValidModuleName {
    // This module name is valid and does not start with an underscore

    // Function using tuple destructuring and sequential modification
    public fun tuple_modify(a: u8, b: u8): (u8, u8) {
        let (mut_x, mut_y) = (a, b);

        // Sequential modifications
        let mut_x = mut_x + 1;
        let mut_y = mut_y + 2;
        let mut_x = mut_x * 2;
        let mut_y = mut_y * 3;

        (mut_x, mut_y)
    }
}


//# run 0xCAFE::ValidModuleName::tuple_modify --args 2u8 3u8



//# publish
module 0xCAFE::TryInvalidModuleName {
    // Attempting to use an invalid module name starting with underscore is prohibited.
    // Move compiler will reject this module. However, to illustrate, we show it invalid.
    // This module should NOT be published in practice, but including here to test naming rules.
    // Uncommenting this module will cause compilation failure.

    /*
//# publish
    module 0xCAFE::_InvalidName {
        public fun dummy(): u8 {
            1u8
        }
    }
    */
}


//# publish
module 0xCAFE::PackageVisibility {
    // Testing package visibility functions callable from other modules in the same package.

    // This function has script visibility, callable from any module in this package
    public(script) fun increment_twice(x: u8): u8 {
        let x = x + 1;
        let x = x + 1;
        x
    }
}


//# publish
module 0xCAFE::CallPackageVisibility {
    use 0xCAFE::PackageVisibility;

    public fun call_increment_twice(x: u8): u8 {
        PackageVisibility::increment_twice(x)
    }
}


//# run 0xCAFE::CallPackageVisibility::call_increment_twice --args 5u8



//# publish
module 0xCAFE::TupleDestructurePkgVis {
    // Module demonstrating tuple destructuring and sequential modification with package visibility

    // A function with script visibility, returning modified tuple
    public(script) fun tuple_seq_modify(x: u8, y: u8): (u8, u8) {
        let (mut_a, mut_b) = (x, y);

        let mut_a = mut_a + 5;
        let mut_b = mut_b + 10;
        let mut_a = mut_a * 3;
        let mut_b = mut_b * 2;

        (mut_a, mut_b)
    }
}


//# publish
module 0xCAFE::CallTupleDestructurePkgVis {
    use 0xCAFE::TupleDestructurePkgVis;

    public fun test_call(x: u8, y: u8): (u8, u8) {
        TupleDestructurePkgVis::tuple_seq_modify(x, y)
    }
}


//# run 0xCAFE::CallTupleDestructurePkgVis::test_call --args 1u8 2u8


// Featurres:
// fa1f0755c83c8b79f78255984c60ae82: Specify module names and ensure they do not start with an underscore.
// cc11638eaf2be4fb0f94c7b89e32fee2: Test that multiple local variables can be assigned simultaneously using tuple destructuring and their values are correctly computed through sequential modifications within the function.
// 7042ca367147ef9da6aff64ec2f7255b: Declare functions with package visibility that can be called from any module in the same package.
