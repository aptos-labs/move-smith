//# publish
module 0xA550C3D3E4F3B2C1::TestModule {
    use std::string;

    // Function to trim leading whitespace characters
    public fun trim_leading_ws(s: &string::String): string::String {
        let bytes = string::bytes(s);
        let mut index = 0;

        while (index < vector::length(&bytes) && is_whitespace(move &vector::borrow(&bytes, index))) {
            index = index + 1;
        }

        string::slice(s, index, string::length(s))
    }

    fun is_whitespace(b: &u8): bool {
        *b == 0x20 || *b == 0x09 || *b == 0x0A || *b == 0x0D
    }

    // Function to add two u64 values
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    // Empty struct variants with no fields
    struct VariantA {}
    struct VariantB {}
    struct VariantC {}
}

//# run 0xA550C3D3E4F3B2C1::TestModule::trim_leading_ws --args "   \t\n  Hello World"
 //# run 0xA550C3D3E4F3B2C1::TestModule::add --args 42 58
 //# run 0xA550C3D3E4F3B2C1::TestModule::VariantA
 //# run 0xA550C3D3E4F3B2C1::TestModule::VariantB
 //# run 0xA550C3D3E4F3B2C1::TestModule::VariantC