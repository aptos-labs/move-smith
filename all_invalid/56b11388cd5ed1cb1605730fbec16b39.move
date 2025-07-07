
//# publish
module 0xCAFE::SpecsWithTypeParam {
    use std::signer;

    struct Container<T> has store {
        value: T
    }

    spec Container<T> {
        // reusable property template for any Container type
        fun valid_property(c: &Container<T>): bool {
            exists(c.value)
        }
    }

    public fun create<T>(s: signer, val: T): Container<T> {
        Container { value: val }
    }

    public fun check_property<T>(c: &Container<T>): bool {
        //@ spec block is allowed to refer to the Container property
        //@ open Container::valid_property<T>(c);
        //@ assert Container::valid_property<T>(c);
        true
    }
}

//# run 0xCAFE::SpecsWithTypeParam::check_property



//# publish
module 0xCAFE::ScriptConstantsFiltering {
    /// A constant that should be filtered out in scripts
    const FILTER_ME: u64 = 999;

    /// Constants to keep in script
    const VALUE_ONE: u64 = 1;
    const VALUE_TWO: u64 = 2;

    public fun sum_constants(keep_filter: bool): u64 {
        if (keep_filter) {
            VALUE_ONE + VALUE_TWO
        } else {
            // simulate "removing" a constant by not using it in computation
            VALUE_ONE
        }
    }
}

//# run 0xCAFE::ScriptConstantsFiltering::sum_constants --args true


//# run 0xCAFE::ScriptConstantsFiltering::sum_constants --args false



//# publish
module 0xCAFE::QuantifiedExpr {
    use std::vector;

    /// Declare a function using Quant for quantifiers in specs
    spec foo {
        let nums: vector<u8> = vector[1, 2, 3, 4, 5];

        ensures forall i: u64 :: (i < vector::length(&nums)) ==> (vector::borrow(&nums, i as usize) > &0);
        // forall: all elements are > 0
    }

    /// Dummy function just to hold spec checked by VM
    public fun check_quantified(): bool {
        true
    }
}

//# run 0xCAFE::QuantifiedExpr::check_quantified


// Featurres:
// ec40b4e0854ce5b71390346074abe0ef: Attach specification blocks to schemas with type parameters for reusable property templates.
// e5f5fd47a3968d51b218de0613ea02db: Add or remove constants in scripts through filtering logic.
// c951db0d114554da0a2a964850089eed: Declare quantified expressions with `Quant` for logical or mathematical quantifiers.
