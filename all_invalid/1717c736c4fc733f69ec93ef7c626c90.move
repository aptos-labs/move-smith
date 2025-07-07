
//# publish
module 0xCAFE::SpecConstants {
    /// Named constants to be referenced in spec blocks
    const CONST_A: u64 = 100;
    const CONST_B: u64 = 200;

    /// Spec block with multiple members referencing constants
    spec module {
        const CONST_SUM: u64 = CONST_A + CONST_B;
        const CONST_DOUBLE_A: u64 = CONST_A * 2;

        /// Invariant over constants sum to be under a limit
        invariant CONST_SUM < 500;

        /// Spec function that uses named constants and computes a value
        fun sum_and_double(): u64 {
            CONST_SUM + CONST_DOUBLE_A
        }
    }

    /// A real Move function using constants and spec function for cross-checking
    public fun values_match(): bool {
        let sum = CONST_A + CONST_B;
        let double_a = CONST_A * 2;
        let spec_sum_and_double = SpecConstants::spec_sum_and_double();

        // Check that runtime values match the spec function's computation
        sum + double_a == spec_sum_and_double
    }

    /// Accessor to spec function values for testing interaction
    public fun spec_sum_and_double(): u64 {
        CONST_A + CONST_B + CONST_A * 2
    }
}



//# run 0xCAFE::SpecConstants::values_match




//# publish
module 0xCAFE::MoreSpecMembers {
    /// Named constants reused and new constants
    const X: u64 = 7;
    const Y: u64 = 3;

    spec module {
        /// Multiple members using named constants and computed values
        const MUL: u64 = X * Y;
        const ADD: u64 = X + Y;
        const POW: u64 = 49;

        /// Invariant involving these members
        invariant ADD < POW;
        invariant MUL * MUL == POW;

        /// Spec function with multiple member references
        fun calculate(): u64 {
            MUL + ADD + POW
        }
    }

    /// Function using constants and checking compatibility with spec
    public fun check_calculation(): bool {
        let expected = (X * Y) + (X + Y) + 49u64;
        MoreSpecMembers::calculate() == expected
    }
}



//# run 0xCAFE::MoreSpecMembers::check_calculation




//# publish
module 0xCAFE::InterfaceFilesTest {
    use std::signer;

    /// Dummy resource to force interface generation
    struct Dummy has store, key {
        id: u64,
    }

    /// Initializes Dummy resource at signer's address
    public fun init(s: signer, id: u64) {
        let dummy = Dummy { id };
        move_to<Dummy>(&s, dummy);
    }

    /// Reads Dummy's id field
    public fun get_id(s: signer): u64 {
        let dummy_ref = borrow_global<Dummy>(signer::address_of(&s));
        dummy_ref.id
    }
}



//# run 0xCAFE::InterfaceFilesTest::init --signers 0xBABA --args 123u64



//# run 0xCAFE::InterfaceFilesTest::get_id --signers 0xBABA




//# publish
module 0xCAFE::InterfaceFilesDeterminism {
    /// This module only exists to test that interface files are created in a predictable path
    /// It has no runtime functions but exercises compilation and interface file generation.

    const CONSTANT_DETERMINISTIC: u64 = 202406;

    spec module {
        const SPEC_CONST: u64 = CONSTANT_DETERMINISTIC + 1;
        invariant SPEC_CONST > 0;
    }
}

// There is no run command for this module, only publishing is done to generate the interface file.
