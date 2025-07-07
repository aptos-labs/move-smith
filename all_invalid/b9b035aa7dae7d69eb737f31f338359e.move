//# publish
module 0xCAFE::ListFormatter {
    use std::string;
    use std::vector;
    use std::ascii;

    /// Formats a vector of strings into a single comma-separated string
    public fun format_comma_separated(items: vector<string::String>): string::String {
        let len = vector::length(&items);
        if (len == 0) {
            return string::utf8(b"");
        }
        let mut result = string::copy(&vector::borrow(&items, 0));
        let mut i = 1;
        while (i < len) {
            result = string::concat(&result, &string::utf8(b","));
            result = string::concat(&result, &vector::borrow(&items, i));
            i = i + 1;
        }
        result
    }

    /// Runner function with no arguments to check formatting a sample list
    public fun runner(): string::String {
        let list = vector::empty<string::String>();
        vector::push_back(&mut list, string::utf8(b"apple"));
        vector::push_back(&mut list, string::utf8(b"banana"));
        vector::push_back(&mut list, string::utf8(b"carrot"));
        format_comma_separated(list)
    }
}

//# run 0xCAFE::ListFormatter::runner


//# publish
module 0xCAFE::ModuleAnalyzer {
    use std::vector;
    use std::string;

    struct Info has copy, drop, store {
        name: string::String,
        address: address,
    }

    /// Returns a vector of Info struct representing modules "analyzed"
    /// (dummy implementation since Move does not provide reflection, just returns a vector with self info)
    public fun analyze_modules(): vector<Info> {
        let infos = vector::empty<Info>();
        let self_info = Info {
            name: string::utf8(b"ModuleAnalyzer"),
            address: @0xCAFE,
        };
        vector::push_back(&mut infos, self_info);
        infos
    }

    public fun runner() {
        let infos = analyze_modules();
        let length = vector::length(&infos);
        let mut i = 0;
        while (i < length) {
            let info = *vector::borrow(&infos, i);
            // No assertions or events, just dummy looping
            i = i + 1;
        }
    }
}

//# run 0xCAFE::ModuleAnalyzer::runner


//# publish
module 0xCAFE::ChainAccess {
    struct Outer has copy, drop, store {
        inner: Inner,
    }

    struct Inner has copy, drop, store {
        value: u64,
    }

    public fun new_outer(val: u64): Outer {
        Outer {
            inner: Inner { value: val }
        }
    }

    public fun get_value(outer: &Outer): u64 {
        outer.inner.value
    }

    /// Runner calls new_outer and get_value demonstrating chain access
    public fun runner(): u64 {
        let outer = new_outer(42);
        get_value(&outer)
    }
}

//# run 0xCAFE::ChainAccess::runner

// Featurres:
// eb777228a1668300b377b91da334f529: Format a list of displayable items as a comma-separated string.
// a5be9ce890cfa7e0f7f96cbb96aac464: Use modules in the environment to analyze their structures.
// 9a8847f893559f4ccdce63ae8c9c6dc0: Access modules and types through a chain of names using a specific syntax.
