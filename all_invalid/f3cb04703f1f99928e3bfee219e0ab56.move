
//# publish
module 0xCAFE::CheckerNames {
    use std::signer;

    /// Expose distinct checker names as public constants for external access
    pub const CHECKER_1: u8 = 1;
    pub const CHECKER_2: u8 = 2;

    /// Checker verification function 1, returns checker id
    public fun check_name_one(): u8 {
        CHECKER_1
    }

    /// Checker verification function 2, returns checker id
    public fun check_name_two(): u8 {
        CHECKER_2
    }
}


//# run 0xCAFE::CheckerNames::check_name_one


//# run 0xCAFE::CheckerNames::check_name_two


//# publish
module 0xCAFE::RefAndFuncs {
    use std::signer;

    /// Struct with immutable and mutable references as fields
    struct RefStruct has copy, drop {
        immut_ref: &u8,
        mut_ref: &mut u8,
    }

    /// Function with unique name 1; takes immutable reference, returns u8
    public fun unique_func1(x: &u8): u8 {
        *x + 1
    }

    /// Function with unique name 2; takes mutable reference and increments
    public fun unique_func2(x: &mut u8) {
        *x = *x + 1;
    }

    /// Function with unique name 3; returns a RefStruct containing references
    public fun unique_func3(x: &mut u8, y: &u8): RefStruct {
        RefStruct {immut_ref: y, mut_ref: x}
    }

    /// Function with unique name 4; takes RefStruct, returns sum of referenced values
    public fun unique_func4(r: RefStruct): u8 {
        *r.immut_ref + *r.mut_ref
    }
}


//# run 0xCAFE::RefAndFuncs::unique_func1 --args 10u8


//# run 0xCAFE::RefAndFuncs::unique_func2 --args 10u8


//# run 0xCAFE::RefAndFuncs::unique_func3 --args 10u8  5u8


//# run 0xCAFE::RefAndFuncs::unique_func4 --args 10u8  5u8


//# publish
module 0xCAFE::CombinedModule {
    use std::signer;
    use 0xCAFE::CheckerNames;
    use 0xCAFE::RefAndFuncs;

    /// Struct holding a checker name value and a mutable reference to u8
    struct CheckerRefHolder has store {
        checker_id: u8,
        mut_ref: &mut u8,
    }

    /// Returns checker_id from CheckerNames::CHECKER_1
    public fun get_checker1_id(): u8 {
        CheckerNames::check_name_one()
    }

    /// Returns checker_id from CheckerNames::CHECKER_2
    public fun get_checker2_id(): u8 {
        CheckerNames::check_name_two()
    }

    /// Function that mutates a referenced u8 and returns checker id 1
    public fun mutate_and_check(x: &mut u8): u8 {
        RefAndFuncs::unique_func2(x);
        get_checker1_id()
    }

    /// Function that creates CheckerRefHolder struct and reads sum via RefAndFuncs
    public fun create_and_sum(mut_ref: &mut u8, immut_val: &u8): u8 {
        let checker_id = get_checker2_id();
        let holder = CheckerRefHolder {checker_id, mut_ref};
        let ref_struct = RefAndFuncs::unique_func3(holder.mut_ref, immut_val);
        RefAndFuncs::unique_func4(ref_struct)
    }
}


//# run 0xCAFE::CombinedModule::get_checker1_id


//# run 0xCAFE::CombinedModule::get_checker2_id


//# run 0xCAFE::CombinedModule::mutate_and_check --args 7u8


//# run 0xCAFE::CombinedModule::create_and_sum --args 5u8 3u8


// Featurres:
// 4c1004e16d45b2b625df1cd00661b686: Expose new checker names for use in external module and bytecode validation.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
// b387efbdd298facc38789550100cc99b: Use reference types (both mutable and immutable) as part of your function and struct definitions.
