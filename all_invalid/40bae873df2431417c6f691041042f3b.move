//# publish
module 0xCAFE::FlowControl {
    use std::debug;

    /// A simple enum for demonstration
    enum Status has copy, drop {
        Ok,
        Error(u8),
    }

    #[deprecated] // Deprecate this function
    public fun deprecated_function(): u8 {
        42
    }

    #[deprecated] // Deprecate this struct
    struct DeprecatedStruct has copy, drop {
        value: u8
    }

    public fun use_labeled_blocks(x: u8): u8 {
        let mut result = 0;

        'outer: {
            for (i in 0..5) {
                'inner: {
                    if (i == x) {
                        result = i;
                        break 'outer;
                    };
                    if (i == 3) {
                        break 'inner;
                    };
                    result = result + 1;
                };
                result = result + 10;
            };
        };

        result
    }

    public fun valid_variant_use(y: bool): u8 {
        let status = if (y) {
            Status::Ok
        } else {
            Status::Error(7)
        };

        let code = match status {
            Status::Ok => 0,
            Status::Error(code) => code,
        };

        code
    }
}

//# run 0xCAFE::FlowControl::use_labeled_blocks --args 3u8

//# run 0xCAFE::FlowControl::valid_variant_use --args true

//# run 0xCAFE::FlowControl::valid_variant_use --args false

//# run 0xCAFE::FlowControl::deprecated_function

// Featurres:
// 5156b774d6d26dae1be19f17198217c1: Use labeled blocks to control flow with explicit labels.
// 30fa2870ed7f90ec112d4947d57010b2: Ensure that variant names are used only in valid contexts to prevent invalid variant access.
// a2d7fbb8193d7979e093ba1c6ea49a06: Annotate module members with deprecated annotations
