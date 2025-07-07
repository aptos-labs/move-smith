
//# publish
module 0xCAFE::PhantomTypesAndKeywords {
    use std::marker;

    // Generic struct with a phantom type parameter P
    struct PhantomStruct<P> has copy, drop {
        // phantom field to hold P type parameter without storing a value
        phantom: marker::PhantomData<P>
    }

    // Function named `for` - a Rust reserved keyword, allowed in Move identifiers
    public fun for(x: u8): u8 {
        x + 1
    }

    // Inline function returning PhantomStruct instantiated with u8
    public inline fun make_phantom(): PhantomStruct<u8> {
        PhantomStruct { phantom: marker::PhantomData<u8> }
    }

    // Inline function that calls the function named `for`
    public inline fun call_keyword_function(x: u8): u8 {
        for(x)
    }

    // Function that calls the inline functions above
    public fun test_inline_and_keyword(x: u8): u8 {
        let _phantom = make_phantom();
        call_keyword_function(x)
    }
}


//# run 0xCAFE::PhantomTypesAndKeywords::for --args 10u8


//# run 0xCAFE::PhantomTypesAndKeywords::make_phantom


//# run 0xCAFE::PhantomTypesAndKeywords::call_keyword_function --args 20u8


//# run 0xCAFE::PhantomTypesAndKeywords::test_inline_and_keyword --args 30u8


// Featurres:
// 11a4d1fe9892131da3fe1e15c5bf28ca: Write code that calls inline functions and benefit from having those callees' bodies inlined into the caller.
// d29c9d90bf170cbd1e3673cd3413f617: Mark type parameters as phantom in Move struct definitions
// 36c0747efc0d381d827c603922045c9c: Test that functions can be named using reserved keywords such as 'for' without causing parsing or compilation errors.
