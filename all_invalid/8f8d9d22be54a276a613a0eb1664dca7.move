
//# publish
module 0xBADD::ModuleX {
    use std::vector;
    use 0xBADD::Other;

    struct Data has copy, drop, store {
        value: u64,
        label: vector<u8>,
    }

    public fun get_data(id: u64): Data {
        Data { value: id * 10, label: vector::empty<u8>() }
    }
}


//# publish
module 0xBADD::ModuleY {
    use std::vector;
    use 0xBADD::ModuleX;
    use 0xBADD::ModuleX as MX;

    // Alias for the get_data function
    fun retrieve_data(id: u64): ModuleX::Data {
        ModuleX::get_data(id)
    }

    // Function that calls retrieve_data
    public fun call_and_return(id: u64): ModuleX::Data {
        retrieve_data(id)
    }

    // Inline function accepting a lambda (closure)
    public fun apply_lambda<A: copy + drop, R: copy + drop>(
        x: A,
        lambda: |A| R
    ): R {
        lambda(x)
    }

    // Apply a nested lambda: lambda returns another lambda, which is then applied
    public fun nested_lambda_example(val: u8): u8 {
        let outer = |a: u8| -> |u8| u8 {
            |b: u8| a + b
        };
        let inner_lambda = outer(val);
        inner_lambda(10)
    }
}


//# run 0xBADD::ModuleY::call_and_return --args 42u64

//# run 0xBADD::ModuleY::apply_lambda --args 5u8 --signers 0x0000000000000000000000000A550C0DE --args 5u8

//# run 0xBADD::ModuleY::nested_lambda_example --args 7u8

// Featurres:
// 026cd8206f4d5015790a5be20bf2b7af: Test that a function in module Y correctly calls and returns a struct instance from a function in module X.
// e5a715fbeb59c9ecf5bedade3cc590d2: Use module member aliasing to refer to module members more conveniently.
// 41ec3c2a8d515c6874c92a56ba658423: Test that inline function parameters can accept and apply lambda expressions (closures) as arguments, including when lambdas are nested within each other.
