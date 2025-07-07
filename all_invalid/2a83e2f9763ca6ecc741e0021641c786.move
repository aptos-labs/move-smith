//# publish
address 0xCAFE {
    #[deprecated]
    module DeprecatedModule {
        public fun runner() {
            let x = 42;
            if (true) {
                { let y = x + 1; }
            };
            let _z = { x * 2 };
        }

        public fun with_optional_types(
            optional_types: vector<type>
        ) {
            // just consume optional_types to suppress unused var warning
            let _ = optional_types;
        }
    }
}

//# run 0xCAFE::DeprecatedModule::runner
//# run 0xCAFE::DeprecatedModule::with_optional_types --args vector<0x1::u64::U64>

//// Script that uses braces and calls the deprecated module functions
//# run
script {
    use 0xCAFE::DeprecatedModule;

    fun main() {
        {
            DeprecatedModule::runner();
        }

        let optional_types = vector<type>{type_of<u64>()};
        DeprecatedModule::with_optional_types(optional_types);
    }
}

// Featurres:
// f232c0d4855b23d365d7a3b9d7fda571: Use braces '{...}' to denote a block of expressions in Move code.
// 61f09ed7a7df1ead29aa123b533315c4: Annotate functions or modules with `#[deprecated]` to mark them as deprecated.
// 0e12a1b2edb5efe353962ad8146a7927: Pass an optional vector of types to functions to handle cases where type information might be absent, enabling flexible type assignments in your code.
