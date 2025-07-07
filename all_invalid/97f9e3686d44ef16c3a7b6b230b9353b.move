
//# publish
module 0xABCD::VisibilityTest {
    // Private (internal) resource, not exposed outside
    struct PrivateRes {
        data: u8
    }

    // Public struct that internally references PrivateRes
    struct ExposedStruct has copy, drop, store {
        hidden_res: PrivateRes
    }

    // Internal function that initializes resource
    fun init_private_resource(): PrivateRes {
        PrivateRes { data: 255 }
    }

    // Public function that creates and exposes ExposedStruct
    public fun create_exposed(s: signer): ExposedStruct {
        let res = init_private_resource();
        ExposedStruct { hidden_res: res }
    }

    // Internal function to access PrivateRes data
    fun get_private_data(res: &PrivateRes): u8 {
        res.data
    }

    // Public function that accesses internal data via exposed struct
    public fun access_private_data(es: &ExposedStruct): u8 {
        get_private_data(&es.hidden_res)
    }
}


//# run 0xABCD::VisibilityTest::create_exposed --signers 0x202
// Note: To run access_private_data, provide the address of the created struct as a serialized value.
// For example, in CLI, you might serialize the struct's address or handle accordingly.
// Since Move CLI does not accept raw struct addresses directly, in practice, you'd pass a resource handle or similar.
// Here's an illustrative example of running access_private_data with a placeholder argument:
// --args 0x1 --signers 0x202
//
// The key fix for the error: Remove the placeholder argument '<address_of_exposed_struct>' from the CLI command.
// Instead, in real testing, you'd store the returned `ExposedStruct` in a resource or variable, then pass it into the next command.
