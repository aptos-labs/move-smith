//# publish
module 0xCAFE::BooleanTest {
    // Function to produce true and false literals for testing
    public fun produce_bools(): (bool, bool) {
        (true, false)
    }

    // Function to declare let bindings with intermediate spec variables
    public fun declare_intermediate_bools(): (bool, bool) {
        let bool_true = true;
        let bool_false = false;
        (bool_true, bool_false)
    }

    // Function to test abilities in variant definitions
    // Define an enum with abilities
    enum AbilityEnum with copy, drop, store {
        VariantA,
        VariantB,
    }

    // Function to instantiate variants with abilities
    public fun create_variants(): AbilityEnum {
        AbilityEnum::VariantA
    }
}

//# run 0xCAFE::BooleanTest::produce_bools
script {
    fun main() {
        let (b1, b2) = 0xCAFE::BooleanTest::produce_bools();
        // b1 should be true, b2 should be false
    }
}
//# run 0xCAFE::BooleanTest::declare_intermediate_bools
script {
    fun main() {
        let (b_true, b_false) = 0xCAFE::BooleanTest::declare_intermediate_bools();
        // b_true should be true, b_false should be false
    }
}
//# run 0xCAFE::BooleanTest::create_variants --signers 0xCAFE
script {
    fun main() {
        let v = 0xCAFE::BooleanTest::create_variants();
        // v should be VariantA
    }
}

// Featurres:
// bce76d7eb4e4a72455e298b5a2a97100: Write boolean literals 'true' and 'false'.
// 9aa56961a65355e102a789dddf4f842d: Declare let bindings in spec blocks to name intermediate specification values, optionally for post-state.
// 2731021478adb70b395236d2630f22ed: Declare abilities before or after variant lists with optional postfix ability declarations.
