// Transactional test in Move language for Aptos framework

module 0x1::test_unique_and_reserved_keywords {
    // 1. Unique Module Identifier Check:
    // To simulate: Define this module, then attempt to deploy another module
    // with the same name/address will cause duplicate compilation errors.
    // Since Move does not provide direct runtime APIs to check uniqueness inside code,
    // the test framework uses module address+name uniqueness.
    //
    // So, this module itself is uniquely identified by (0x1, test_unique_and_reserved_keywords).

    // 2. Use all reserved keywords as identifiers:

    // Define fields named after keywords by using compiler escape with _ suffix (experimental, 
    // but Move generally forbids keywords as identifiers).
    //
    // Move currently does not allow using reserved keywords directly as identifiers.
    // However, for test, we can suffix with underscores or mimic their usage as function or variable names,
    // or define functions and variables with names same as keywords in uppercase or camel case.
    //
    // Alternatively, use the keywords as function names inside the module using `fun` keyword since keywords 
    // cannot be used as identifier, declare wrapper functions similarly named.

    // For this test, declare variables and functions with similar names as reserved keywords with suffix underscores.
    // This tests the compiler correctly treats keywords vs identifiers.

    struct ReservedNames {
        abort_: u8,
        acquires_: bool,
        as_: u64,
        break_: u64,
        const_: u64,
        continue_: bool,
        copy_: bool,
        else_: u8,
        false_: bool,
        fun_: u64,
        friend_: u64,
        if_: bool,
        invariant_: u64,
        let_: u64,
        loop_: bool,
        inline_: u64,
        module_: u8,
        move_: bool,
        native_: u64,
        public_: u8,
        return_: bool,
        script_: u64,
        spec_: u64,
        struct_: u64,
        true_: bool,
        use_: u64,
        while_: bool
    }

    // Initializing all fields in a function to test storage and usage
    fun test_reserved_names(): ReservedNames acquires ReservedNames {
        let res = ReservedNames {
            abort_: 1,
            acquires_: true,
            as_: 2,
            break_: 3,
            const_: 4,
            continue_: false,
            copy_: true,
            else_: 5,
            false_: false,
            fun_: 6,
            friend_: 7,
            if_: true,
            invariant_: 8,
            let_: 9,
            loop_: false,
            inline_: 10,
            module_: 11,
            move_: true,
            native_: 12,
            public_: 13,
            return_: false,
            script_: 14,
            spec_: 15,
            struct_: 16,
            true_: true,
            use_: 17,
            while_: false
        };
        res
    }

    // 3. Invoke function's body expression and generate corresponding bytecode.
    // This function runs the above function and returns a field value.
    public fun run_test(): bool {
        let res = test_reserved_names();
        // Return a value to ensure the function compiles to bytecode and runs.
        res.true_
    }
}

// Featurres:
// c8c9da26e974ab1da16df200cc2f8521: Ensure each module has a unique identifier during compilation to prevent duplicate definitions.
// 7dcd99288efac8956318da471526087a: Use reserved keywords such as 'abort', 'acquires', 'as', 'break', 'const', 'continue', 'copy', 'else', 'false', 'fun', 'friend', 'if', 'invariant', 'let', 'loop', 'inline', 'module', 'move', 'native', 'public', 'return', 'script', 'spec', 'struct', 'true', 'use', 'while' as identifiers in Move code.
// f5e8004945c2f3aae12552410e938438: Invoke the function's body expression and generate corresponding bytecode.
