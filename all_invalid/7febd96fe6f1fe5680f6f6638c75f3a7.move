
//# publish
module 0xCAFE::PhantomTypesAndKeywords {
    use std::marker::PhantomData;

    // Generic struct with a phantom type parameter P
    struct PhantomStruct<P> has copy, drop {
        // phantom field to hold P type parameter without storing a value
        phantom: PhantomData<P>
    }

    // Function named `for` - a Rust reserved keyword, allowed in Move identifiers
    public fun for(x: u8): u8 {
        x + 1
    }

    // Inline function returning PhantomStruct instantiated with u8
    public inline fun make_phantom(): PhantomStruct<u8> {
        PhantomStruct { phantom: PhantomData<u8> }
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
