
//# publish
module 0xCAFE::AddressAndResourceAccess {
    use std::signer;
    use std::vector;

    struct Data has key {
        value: u64,
    }

    struct NamedData has key {
        id: u8,
        content: vector<u8>,
    }

    /// Create and publish Data under the signer's address
    public fun create_data(s: signer, val: u64) {
        let addr = signer::address_of(&s);
        let data = Data { value: val };
        move_to<Data>(&s, data);
    }

    /// Create and publish NamedData under the signer's address
    public fun create_named_data(s: signer, id: u8) {
        let content = vector::empty<u8>();
        let content = vector::push_back(&content, 0xCA);
        let content = vector::push_back(&content, 0xFE);
        let named_data = NamedData { id, content };
        move_to<NamedData>(&s, named_data);
    }

    /// Reads Data.value from a known numerical address 0xBEEF
    public fun read_data_at_BEEF(): u64 acquires Data {
        let addr = @0xBEEF;
        let data_ref = borrow_global<Data>(addr);
        data_ref.value
    }

    /// Reads NamedData.id from a known named address 0xCAFE
    public fun read_named_data_at_cafe(): u8 acquires NamedData {
        let addr: address = 0xCAFE;
        let named_data_ref = borrow_global<NamedData>(addr);
        named_data_ref.id
    }

    /// Using wildcard * resource acquisition - read values at 0xBEEF
    public fun read_any_resource_at_BEEF() acquires * {
        let addr = @0xBEEF;
        // Attempt to borrow Data resource under wildcard at 0xBEEF to demonstrate acquisition
        // We only borrow if exists, but in a test it is guaranteed.
        let _data_ref = borrow_global<Data>(addr);
    }

    /// Using wildcard * resource acquisition - read values at 0xCAFE
    public fun read_any_resource_at_cafe() acquires * {
        let addr = @0xCAFE;
        let _named_ref = borrow_global<NamedData>(addr);
    }

    /// Runner function with no args to trigger resource access
    public fun runner() acquires Data, NamedData {
        let _val = read_data_at_BEEF();
        let _id = read_named_data_at_cafe();
    }
}


//# run 0xCAFE::AddressAndResourceAccess::create_data --signers 0xBEEF --args 12345u64


//# run 0xCAFE::AddressAndResourceAccess::create_named_data --signers 0xCAFE --args 42u8


//# run 0xCAFE::AddressAndResourceAccess::read_data_at_BEEF


//# run 0xCAFE::AddressAndResourceAccess::read_named_data_at_cafe


//# run 0xCAFE::AddressAndResourceAccess::read_any_resource_at_BEEF


//# run 0xCAFE::AddressAndResourceAccess::read_any_resource_at_cafe


//# run 0xCAFE::AddressAndResourceAccess::runner


// Featurres:
// dfcd98ac9f2f7d5b2a6467540fe5b143: Write code that can reference both numerical (anonymous) and named addresses in address positions
// ea874dba7c85a3b76c3080088ee75368: Use resource access specifiers with a single wildcard '*' to refer to any resource at a specified address.
// 73d4b20956f885ed998d023491815143: Ensure that all target modules and functions correctly declare the resources they acquire, or have those acquisitions inferred by the compiler.
