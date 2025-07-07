//# publish
module 0xCAFE::TestAbilities {
    use std::debug;
    
    #[test]
    public fun ability_debug_test() {
        // Variables with different abilities
        let x = 42; // primitive, has debug
        let b = true; // primitive, has debug
        
        // Struct with copy and drop abilities
        struct CopyDropStruct {
            val: u64,
            flag: bool,
        }
        // Compose a struct with copy and drop abilities
        let s = CopyDropStruct { val: 100u64, flag: true };
        
        // Render debug info for primitive integers
        debug::print(&debug::ast_debug(&x));        // Should output debug for 42
        debug::print(&debug::ast_debug(&b));        // Should output debug for true
        
        // Render debug info for struct with abilities
        debug::print(&debug::ast_debug(&s));
        
        // Conditional expression: Using 'if-else' to assign based on a condition
        let condition = (x > 10); // true
        let result = if condition { 
            debug::ast_debug(&x) 
        } else { 
            debug::ast_debug(&b as u8) 
        };
        // Render the result of the condition-based expression
        debug::print(&result);
        
        // Exclude 'CopyDropStruct' pattern from debug output
        debug::ast_debug(&CopyDropStruct { val: 999, flag: false }); // Normal debug
        // Note: 'except' pattern filtering is simulated by only rendering certain expressions
        // in real test it may be part of a larger debug or filter mechanism
    }
}

//# run 0xCAFE::TestAbilities::ability_debug_test

// Featurres:
// f020765f96160effa4351ae0e6b2c22f: Create conditional expressions with 'if-else' branches.
// c059f67bd264316dd375a6847d9579dc: Render each ability's debug representation using its ast_debug method.
// e22221b32e33aa69eef00d30b5419f3e: Optionally exclude specific patterns from an 'apply' by adding 'except <patterns>' in the same syntax.
