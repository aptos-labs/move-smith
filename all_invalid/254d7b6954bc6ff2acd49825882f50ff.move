//# publish
module 0x1::DiagnosticsTest {
    use std::diagnostics;
    use std::option;
    use std::string;

    /// A public function that emits some diagnostics messages.
    public fun emit_diagnostics() {
        diagnostics::warning(b"Warning: this is a test warning");
        diagnostics::info(b"Info: testing diagnostic info message");
        diagnostics::error(b"Error: this is an error diagnostic");
    }

    /// Runner function to test diagnostics emission.
    public fun run() {
        emit_diagnostics();
    }
}
//# run 0x1::DiagnosticsTest::run

//# publish
module 0x1::ModuleIdTest {
    use std::option;
    use std::string;
    use std::address;
    use aptos_framework::address_util; // assuming this exists for alias resolution
    use std::diagnostics;

    /// Converts an optional module name string into an Option<ModuleId>.
    /// Resolves address aliases if present at the front of the string, e.g. "Aptos::MyModule".
    public fun optional_module_name_to_module_id(
        optional_module_name: option::Option<string::String>,
        alias_address: address,
    ): option::Option<address::ModuleId> {
        if (option::is_some(&optional_module_name)) {
            let module_name = option::extract(optional_module_name);
            // If the module_name contains "::", treat the part before as alias.
            // For simplicity, just parse as "<alias>::<modname>".
            // We split on "::"
            let parts = string::split(&module_name, b"::");
            if (vector::length(&parts) == 2) {
                let alias_str = vector::borrow(&parts, 0);
                let mod_str = vector::borrow(&parts, 1);

                // Resolve only if alias matches a known alias, else treat alias_str as address in hex.
                // For test purpose, if alias_str == "Aptos", resolve to given alias_address,
                // else treat as hex address string (could parse, but here just skip).
                if (string::bytes_equal(alias_str, b"Aptos")) {
                    let mod_name = string::utf8(mod_str);
                    let mod_id = address::ModuleId {
                        address: alias_address,
                        name: mod_name,
                    };
                    option::some(mod_id)
                } else {
                    // For simplicity, return none if unknown alias
                    option::none()
                }
            } else if (vector::length(&parts) == 1) {
                // No alias, treat as module name only, address 0x0
                let mod_name = string::utf8(&module_name);
                let mod_id = address::ModuleId {
                    address: @0x0,
                    name: mod_name,
                };
                option::some(mod_id)
            } else {
                option::none()
            }
        } else {
            option::none()
        }
    }

    /// Runner function: test this conversion.
    public fun run() {
        let alias_address = @0x1234;
        // Case 1: Some with alias "Aptos::TestModule"
        let some_modname = option::some(string::utf8(b"Aptos::TestModule"));
        let res1 = optional_module_name_to_module_id(some_modname, alias_address);
        diagnostics::info(b"Converted module id with alias");
        // Case 2: Some without alias "JustModule"
        let some_modname2 = option::some(string::utf8(b"JustModule"));
        let res2 = optional_module_name_to_module_id(some_modname2, alias_address);
        diagnostics::info(b"Converted module id without alias");
        // Case 3: None input
        let none_modname = option::none<string::String>();
        let res3 = optional_module_name_to_module_id(none_modname, alias_address);
        diagnostics::info(b"Converted none module name");
    }
}
//# run 0x1::ModuleIdTest::run

//# publish
module 0x1::NestedInlineTest {
    /// Nested inline functions
    /// Inline function that doubles a number
    inline fun double(x: u64): u64 {
        x * 2
    }

    /// Inline function that triples a number by calling double and adding x
    inline fun triple(x: u64): u64 {
        double(x) + x
    }

    /// Public function that calls the nested inline functions and returns their sum
    public fun sum_double_triple(x: u64): u64 {
        let a = double(x);
        let b = triple(x);
        a + b
    }

    /// Runner function that calls sum_double_triple with a fixed argument
    public fun run() {
        let result = sum_double_triple(5);
        // No assertions needed. Output the result using diagnostics.
        use std::diagnostics;
        // Writing the result as bytes, so convert u64 to string bytes manually
        let msg = b"Result of sum_double_triple(5) = ";
        diagnostics::info_vector(msg);
        let val_bytes = std::string::utf8(&std::string::string(&std::string::slice_u64(result)));
        diagnostics::info(val_bytes);
    }
}
//# run 0x1::NestedInlineTest::run

//# run
script {
    use std::diagnostics;
    use 0x1::DiagnosticsTest;
    use 0x1::ModuleIdTest;
    use 0x1::NestedInlineTest;

    fun main(account: signer) {
        DiagnosticsTest::emit_diagnostics();
        ModuleIdTest::run();
        let val = NestedInlineTest::sum_double_triple(7);
        diagnostics::info(b"Testing NestedInlineTest::sum_double_triple(7)");
        // Could output val here by diagnostics - convert u64 to bytes
        // Simple helper to convert u64 to bytes by printing decimal digits is not in std,
        // so here just dummy message.
        diagnostics::info(b"Completed NestedInlineTest test");
    }
}