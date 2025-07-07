// The test address
address 0xCAFE {}

//# publish
module 0xCAFE::DeprecatedModule {
    // This module is deprecated, simulate by using a dummy attribute message (actual deprecated attribute may not exist)
    #[deprecated]
    public fun deprecated_function(): u64 {
        42
    }
}

//# publish
module 0xCAFE::SpecModule {
    // This module has a spec block that annotates module behavior

    spec module {
        // Module invariant example
        invariant exists_some_value: true;
    }

    public fun dummy(): u8 {
        0
    }
}

//# publish
module 0xCAFE::LocalVarsToString {
    use std::string;
    use std::vector;

    // Runner function to test string representation of locals
    public fun run(): string::String {
        let x: u8 = 10;
        let y: u64 = 20;
        let z: bool = true;

        // create a vector of string with formatted locals
        let mut parts = vector::empty<string::String>();

        vector::push_back(&mut parts, string::utf8(b"x = 10"));
        vector::push_back(&mut parts, string::utf8(b"y = 20"));
        vector::push_back(&mut parts, string::utf8(b"z = true"));

        let joined = string::join(string::utf8(b", "), parts);

        let mut result = string::utf8(b"Locals: {");
        result = string::append(&result, &joined);
        result = string::append(&result, &string::utf8(b"}"));

        result
    }
}
//# run 0xCAFE::LocalVarsToString::run

//# run
script {
    use 0xCAFE::DeprecatedModule;
    use 0xCAFE::SpecModule;
    use 0xCAFE::LocalVarsToString;
    use std::debug;

    fun main() {
        // Call deprecated function to generate diagnostic
        let _val = DeprecatedModule::deprecated_function();

        // Call module with spec block, just dummy call
        let _dummy = SpecModule::dummy();

        // Call run function for local vars string representation
        let s = LocalVarsToString::run();
        debug::print(&s);
    }
}

// Featurres:
// cc34729450c4cd057130f86dfbdd72b3: Be warned when using deprecated modules via diagnostic messages
// a1d4a8ec512c31e216a4963faae9cc3c: Annotate module-level behavior by writing 'spec module { ... }' blocks.
// 7eccfd4c9a6c43b8e2ecec7b482edad8: Generate a string representation of local variables enclosed in braces with a header prefix.
