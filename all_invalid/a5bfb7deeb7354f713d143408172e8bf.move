
//# publish
module 0xCAFE::CompileDiagnostics {
    use std::signer;
    use std::debug;
    use std::string;
    use std::vector;

    struct ColoredDiagnostics has store {
        enabled: bool,
        color_code: vector<u8>,
    }

    public fun publish_diagnostics_setting(enabled: bool, color_code: vector<u8>): ColoredDiagnostics {
        ColoredDiagnostics {enabled, color_code}
    }

    public fun diagnostics_env_set() {
        // simulate environment variable check by hardcode
        let enabled = true;
        let color_code = b"\x1b[31m"; // red color code in ANSI
        let _diag = publish_diagnostics_setting(enabled, vector::copy(&color_code));
    }

    public fun diagnostics_env_off() {
        let enabled = false;
        let color_code = b"\x1b[0m"; // reset color code
        let _diag = publish_diagnostics_setting(enabled, vector::copy(&color_code));
    }

    public fun runner() {
        diagnostics_env_set();
        diagnostics_env_off();
    }
}


//# run 0xCAFE::CompileDiagnostics::runner


//# publish
module 0xCAFE::BindPatterns {
    struct Container has copy, drop {
        a: u8,
        b: u8,
        c: u8,
    }

    public fun bind_patterns_example(): (u8, u8, u8) {
        let (a, b, c) = (1u8, 2u8, 3u8);
        let container = Container {a, b, c};

        let Container {a: x, b: y, c: z} = container;
        (x, y, z)
    }
}


//# run 0xCAFE::BindPatterns::bind_patterns_example


//# publish
module 0xCAFE::GenericStructs {
    struct GenericStruct<T> has copy, drop {
        value: T,
    }

    public fun create_u8_struct(v: u8): GenericStruct<u8> {
        GenericStruct<u8> {value: v}
    }

    public fun create_bool_struct(v: bool): GenericStruct<bool> {
        GenericStruct<bool> {value: v}
    }

    public fun create_vector_struct(v: vector<u8>): GenericStruct<vector<u8>> {
        GenericStruct<vector<u8>> {value: v}
    }

    public fun runner() {
        let _a = create_u8_struct(42u8);
        let _b = create_bool_struct(true);
        let vec = b"test";
        let _c = create_vector_struct(vector::copy(&vec));
    }
}


//# run 0xCAFE::GenericStructs::runner


// Featurres:
// e814ab3a20d793364ad8e693cad02442: Display colored compiler diagnostics based on environment variable settings
// 506f045b6a788390d0f2f114626c1774: Bind patterns to values with associated source code ranges in a single statement
// 18fcecd82c824bb4e2905d9002af0910: Create struct types with type parameters and instantiate them with specific type arguments.
