// The test address to use:
const TEST_ADDRESS: address = 0xCAFE;

//# publish
module 0xCAFE::AbilityModule {
    use std::abilities::Ability;

    // A struct to test tracking abilities declared explicitly.
    // Note: Abilities annotation order testing here.
    struct TestAbilities has store key copy drop {
        a: u8,
        b: bool,
    }

    public fun runner() {
        // This function exists just to be called by run command.
    }
}
//# run 0xCAFE::AbilityModule::runner --signers 0xCAFE

//# publish
module 0xCAFE::CastModule {
    public fun cast_examples() {
        // Cast integer expression where sub-expression itself casts
        let a = ((3 as u8) as u64);
        let b = ((5 + (2 as u64)) as u8); // note: this will truncate if > u8 max
        let c = (10 as u32);

        // Complex nested cast with arithmetic
        let d = (((4 as u8) + (1 as u8)) as u64);

        // for coverage, cast a boolean expression. This is invalid and should cause compiler error if uncommented:
        // let e = (true as u8);

        // just have variables to silence unused warning
        let _ = a;
        let _ = b;
        let _ = c;
        let _ = d;
    }

    public fun runner() {
        cast_examples();
    }
}
//# run 0xCAFE::CastModule::runner --signers 0xCAFE

//# publish
module 0xCAFE::ScriptModule {
    public fun script_function(): u8 {
        42
    }

    public fun call_script_function(): u8 {
        script_function()
    }
}
//# run 0xCAFE::ScriptModule::call_script_function --signers 0xCAFE

//# run
script 0xCAFE::CallScriptFunctionScript {
    use 0xCAFE::ScriptModule;

    fun main() {
        let x = ScriptModule::script_function();
        let y = ScriptModule::call_script_function();

        // cast the returned result from ScriptModule::script_function to u64
        let z = (x as u64);

        let _ = y;
        let _ = z;
    }
}

// Featurres:
// 477f6a0d7e3e657c8ff5d179eb8af0c8: Declare scripts with associated function names.
// 6f8dd25f8a7d8da62724449569e19dd6: Create cast or annotate expressions with sub-expressions and types.
// 1831330fadc45f430f99ce2e8c9b6445: List each ability in the provided AbilitySet separated by spaces.
