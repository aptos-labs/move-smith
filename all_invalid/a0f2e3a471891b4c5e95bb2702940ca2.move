//# publish
module 0xCAFE::CodeGenHelpers {
    use std::string;
    use std::vector;

    struct TypeParameter has store {
        name: vector<u8>,
        is_copy: bool,
        is_drop: bool,
        is_store: bool,
        is_key: bool,
    }

    /// Format a list of TypeParameter into a string like:
    /// "<T: copy + drop + store + key, U, V: store>"
    public fun format_type_parameters(params: vector<TypeParameter>): vector<u8> {
        let mut parts = vector::empty<vector<u8>>();
        let len = vector::length(&params);
        let mut i = 0;
        while (i < len) {
            let param = vector::borrow(&params, i);
            let mut part = string::utf8(&param.name);

            // Build constraints string as "+ copy + drop + store + key", only if true
            let mut constraints = vector::empty<vector<u8>>();
            if (param.is_copy) {
                vector::push_back(&mut constraints, b"copy");
            };
            if (param.is_drop) {
                vector::push_back(&mut constraints, b"drop");
            };
            if (param.is_store) {
                vector::push_back(&mut constraints, b"store");
            };
            if (param.is_key) {
                vector::push_back(&mut constraints, b"key");
            };

            if (vector::length(&constraints) > 0) {
                part = string::concat(&part, b": ");
                let mut j = 0;
                let c_len = vector::length(&constraints);
                while (j < c_len) {
                    part = string::concat(&part, vector::borrow(&constraints, j));
                    if (j + 1 < c_len) {
                        part = string::concat(&part, b" + ");
                    };
                    j = j + 1;
                };
            };

            vector::push_back(&mut parts, part);
            i = i + 1;
        };

        // Join parts with ", "
        let mut joined = b"<";
        let parts_len = vector::length(&parts);
        let mut k = 0;
        while (k < parts_len) {
            joined = string::concat(&joined, vector::borrow(&parts, k));
            if (k + 1 < parts_len) {
                joined = string::concat(&joined, b", ");
            };
            k = k + 1;
        };
        joined = string::concat(&joined, b">");
        joined
    }

    // Format reference type string: mutable flag, inner type string
    public fun format_reference(mutable: bool, inner_type: vector<u8>): vector<u8> {
        if (mutable) {
            string::concat(&b"&mut ", &inner_type)
        } else {
            string::concat(&b"&", &inner_type)
        }
    }
}

/// Struct to hold Linters configuration
struct LintersConfig has store {
    check_unused_vars: bool,
    check_unreachable_code: bool,
    check_deprecated_syntax: bool,
    check_naming_conventions: bool,
}

public fun default_linters_config(): LintersConfig {
    LintersConfig {
        check_unused_vars: true,
        check_unreachable_code: true,
        check_deprecated_syntax: true,
        check_naming_conventions: true,
    }
}

/// Apply linters configuration
public fun apply_linters_cfg(cfg: &LintersConfig) {
    let _ = cfg.check_unused_vars;
    let _ = cfg.check_unreachable_code;
    let _ = cfg.check_deprecated_syntax;
    let _ = cfg.check_naming_conventions;
}

/// Runner function to demonstrate the formatting and lint config usage
public fun runner() {
    let t1 = TypeParameter {
        name: vector::from_bytes(b"T"),
        is_copy: true,
        is_drop: true,
        is_store: false,
        is_key: false,
    };
    let t2 = TypeParameter {
        name: vector::from_bytes(b"U"),
        is_copy: false,
        is_drop: false,
        is_store: false,
        is_key: false,
    };
    let t3 = TypeParameter {
        name: vector::from_bytes(b"V"),
        is_copy: false,
        is_drop: false,
        is_store: true,
        is_key: false,
    };
    let params = vector::empty<TypeParameter>();
    vector::push_back(&mut (params), t1);
    vector::push_back(&mut (params), t2);
    vector::push_back(&mut (params), t3);

    let formatted_params = format_type_parameters(params);
    let ref_immutable = format_reference(false, b"u8".to_vec());
    let ref_mutable = format_reference(true, b"bool".to_vec());

    let cfg = default_linters_config();
    apply_linters_cfg(&cfg);

    // We ignore the values, just run without errors
}

//# run 0xCAFE::CodeGenHelpers::runner

// Featurres:
// 4122afb27c5fe0f1f8211da9cf3e0924: Format a list of type parameters with their names and constraints into a string suitable for code generation.
// 731e7b66c340e61a359477160d73dcb1: Define reference types with mutable and immutable qualifiers using '&' and '&mut' syntax.
// ec97d2e34e377a9fff9157a5c5e07d6b: Configure the set of expression linters to apply during code analysis.
