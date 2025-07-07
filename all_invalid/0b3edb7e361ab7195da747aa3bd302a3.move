//# publish
module 0xCAFE::NamedParamsResults {
    /// Demonstrate named parameters and return named results
    public fun calculate_area(length: u32, width: u32): u32 {
        let area = length * width;
        area
    }

    /// Use code block with variable binding through assignment
    public fun assign_in_code_block(x: u32): u32 {
        let y = {
            let z = x * 2;
            // This block returns z + 3
            z + 3
        };
        y
    }
}

/// Module for tests with #[test] attribute
#[test]
module 0xCAFE::TestNamedParamsResults {
    use 0xCAFE::NamedParamsResults;

    #[test]
    public fun test_calculate_area() {
        let area = NamedParamsResults::calculate_area(4u32, 5u32);
        let _ = area;  // We just bind the result here, no assertions needed
    }

    #[test]
    public fun test_assign_in_code_block() {
        let result = NamedParamsResults::assign_in_code_block(7u32);
        let _ = result;
    }
}

//# run 0xCAFE::NamedParamsResults::calculate_area --args 10u32 20u32

//# run 0xCAFE::NamedParamsResults::assign_in_code_block --args 15u32

//# run 0xCAFE::TestNamedParamsResults::test_calculate_area

//# run 0xCAFE::TestNamedParamsResults::test_assign_in_code_block

// Features:
// 4ee2a0b08f4677e897745bd9fd7b3e2e: Use named parameters and results in functions
// b8b4d99ddcfacf16a1f3237a788b31bb: Bind and assign values to variables within code blocks using assignment
// 9813d01e7c0cc1c0e64383ab4f725517: Use test attributes with the syntax `#[test]` in Move code to mark test functions or modules.