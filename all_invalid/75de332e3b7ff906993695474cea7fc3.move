//# publish
module 0xCAFE::LogicNegCompound {

    /// This function tests the behavior of logical negation and compound assignment on booleans.
    /// It takes an initial boolean input and a boolean flag to decide compound assignment.
    public fun test_logical_negation_and_compound_assignment(flag: bool, initial: bool): bool {
        // negate the flag
        let mut result = !flag;

        // compound assignment style: simulate using "result = result && initial"
        result = result && initial;

        // negate again just for extra coverage
        result = !result;

        // compound assign OR
        result = result || flag;

        result
    }

    /// A runner function without arguments for ease of testing callability.
    /// Will call the main test function with some preset values.
    public fun runner(): bool {
        // call with true, false
        let res1 = Self::test_logical_negation_and_compound_assignment(true, false);

        // call with false, true
        let res2 = Self::test_logical_negation_and_compound_assignment(false, true);

        // call with true, true
        let res3 = Self::test_logical_negation_and_compound_assignment(true, true);

        // Combine results with || to return a single bool for simplicity.
        res1 || res2 || res3
    }
}
//# run 0xCAFE::LogicNegCompound::runner

//# run 
script {
    use 0xCAFE::LogicNegCompound;

    fun main() {
        let a = 0xCAFE as u64;
        let b = 0x10 as u8;

        // call the module function directly with variables
        let res = LogicNegCompound::test_logical_negation_and_compound_assignment(true, false);
        let res2 = LogicNegCompound::test_logical_negation_and_compound_assignment(false, true);

        // A simple usage of hex literals to confirm parsing
        let sum = (a + (b as u64));
        // simulate some logic with hex literals and boolean
        let flag = if (sum > 0xCAF) { true } else { false };

        let final_res = LogicNegCompound::test_logical_negation_and_compound_assignment(flag, res && res2);

        // no assertions; just logic covered
    }
}

// Featurres:
// 5cee685862c557c647152db0d4254887: Test the behavior of the logical negation and compound assignment within the function to ensure it correctly evaluates the boolean expressions based on different input values.
// 90d36a822934d2597867f63ae66682ef: Use hexadecimal literals starting with '0x' for numerical values.
// 9b9fa9ee559a089db3ff7787f80e82c0: Avoid using references as captured arguments in lambdas.
