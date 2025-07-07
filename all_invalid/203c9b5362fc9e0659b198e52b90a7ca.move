// specs, custom attributes, compiler options, and attribute resolution in a comprehensive manner.

// The following code will define modules, structs, functions, and attribute annotations as per the test features.



//# publish
module 0xBADD::DeprecationAttr {
    // Mark entire namespace as deprecated
    // deprecated]
    public fun deprecated_function() {
        0
    }

    // Attribute for structs
    // attribute]
    public fun get_attr(): u64 {
        42
    }
}



//# publish
module 0xCAFE::NestedAccess {
    use std::vector;

    // Struct with nested fields to test dot notation
    struct ComplexStruct has store, key {
        inner: InnerStruct,
        count: u64,
    }

    struct InnerStruct has store {
        depth: u8,
        info: InfoStruct,
    }

    struct InfoStruct has store {
        description: vector<u8>,
        flags: u8,
    }

    // Function to create complex nested struct
    public fun create_complex_struct(): ComplexStruct {
        let info = InfoStruct {description: b"nested", flags: 1};
        let inner = InnerStruct {depth: 5, info};
        let complex = ComplexStruct {inner, count: 10};
        complex
    }

    // Function to access nested field using dot notation
    public fun access_deep_field(c: &ComplexStruct): u8 {
        c.inner.info.flags
    }
}

# Usage of deprecated attribute at address namespace
// deprecated(address = "0xBADD")]

//# publish
module 0xBADD::DeprecatedNamespace {
    // Nested module inside deprecated namespace
    public fun legacy_call() {
        0
    }
}



//# publish
module 0xCAFE::FirstClassFunctions {
    use std::vector;

    // Function with generics
    public fun generic_identity<T: copy + drop>(x: T): T {
        x
    }

    // Function assigned to a variable
    public fun assign_fun(): (u8) -> u8 {
        copy fun(x: u8): u8 {
            x + 1
        }
    }

    // Passing function as parameter
    public fun call_func(f: (u8) -> u8, val: u8): u8 {
        f(val)
    }

    // Higher-order function that takes a function and returns its result
    public fun invoke_closure(f: (u8) -> u8, val: u8): u8 {
        f(val)
    }
}



//# publish
module 0xCAFE::Attributes {
    // Custom attribute attached to structs
    // attribute]
    public fun get_custom_attr(): u64 {
        777
    }

    attribute AttrExample {
        value: u64
    }
}



//# publish
module 0xCAFE::CompilerOptions {
    // Simulate a module controlling inline function retention
    // This is a placeholder: in actual compiler tests, inline retention
    // is controlled via compile flags. Here, we just define functions
    // and annotate them accordingly.
    
    // inline(always)]
    public fun inline_func(): u64 {
        1234
    }

    // inline(never)]
    public fun no_inline_func(): u64 {
        5678
    }
}



//# publish
module 0xCAFE::AttrResolution {
    // Attribute at address and module level used for resolution check
    
    // attribute(address = "0xDEADBEEF")]
    public fun resolve_this(): u64 {
        999
    }
}


// We invoke the create_complex_struct and access_deep_field functions


//# run 0xCAFE::NestedAccess::create_complex_struct


//# run 0xCAFE::NestedAccess::access_deep_field --args 0xCAFE::NestedAccess::create_complex_struct

// Step 2: Call deprecated namespace function and verify attribute inheritance


//# run 0xBADD::DeprecatedNamespace::legacy_call

// Step 3: Use a generic function


//# run 0xCAFE::FirstClassFunctions::generic_identity --args 42u8

// Step 4: Assign function to variable and invoke
let id_func = 0xCAFE::FirstClassFunctions::assign_fun();
let result = id_func(10u8);
// result should be 11u8

// Step 5: Pass function as argument and invoke


//# run 0xCAFE::FirstClassFunctions::call_func --args 0xCAFE::FirstClassFunctions::assign_fun() 7u8

// Step 6: Invoke closure function


//# run 0xCAFE::FirstClassFunctions::invoke_closure --args 0xCAFE::FirstClassFunctions::assign_fun() 5u8

// Step 7: Check custom attribute value


//# run 0xCAFE::Attributes::get_custom_attr

// Step 8: Verify compiler options - retain inline functions
// The inline functions are test points, here we call them directly
let inline_value = 0xCAFE::CompilerOptions::inline_func();
// Should be 1234
let no_inline_value = 0xCAFE::CompilerOptions::no_inline_func();
// Should be 5678

// Step 9: Attribute resolution check by calling resolve_this


//# run 0xCAFE::AttrResolution::resolve_this
