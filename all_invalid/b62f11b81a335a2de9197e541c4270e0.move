
//# publish
module 0xBADD::ModuleX {
    use std::vector;

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
    // Removed use of 0xBADD::Other; as it causes unbound module error

    // Alias for the get_data function
    fun retrieve_data(id: u64): ModuleX::Data {
        ModuleX::get_data(id)
    }

    // Function that calls retrieve_data
    public fun call_and_return(id: u64): ModuleX::Data {
        retrieve_data(id)
    }

    // To emulate nested lambdas, define inner functions
    public fun nested_lambda_example(val: u8): u8 {
        // Outer function
        fun outer(a: u8): fn(b: u8): u8 {
            // Inner function returned by outer
            fun inner(b: u8): u8 {
                a + b
            }
            inner
        }

        let inner_fn = outer(val);
        inner_fn(10)
    }
}