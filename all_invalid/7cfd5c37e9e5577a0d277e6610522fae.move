
//# publish
module 0xCAFE::UpperCaseTest {
    use std::vector;

    // Define constants starting with uppercase letters
    const Alpha: u8 = 10;
    const Beta: u16 = 20;

    // Define struct with uppercase starting name and uppercase field names
    struct Account has copy, drop, store, key {
        Address: address,
        Balance: u64,
    }

    // Define schema with uppercase name
    struct Schema has copy, drop, store {
        Data: u8,
    }

    // Function that creates Account resource
    public fun create_account(addr: address, bal: u64): Account {
        Account { Address: addr, Balance: bal }
    }

    // Function returning constant Alpha
    public fun get_alpha(): u8 {
        Alpha
    }

    // Function to access builtin all_type_names and return as vector<u8>
    // This tests access to built-in type names set
    public fun get_all_type_names(): vector<vector<u8>> {
        all_type_names()
    }

    // Function demonstrating pragma properties for compiler directives
    // inline]
    public fun pragma_example(x: u8): u8 {
        x + (Beta as u8)
    }
}



//# run 0xCAFE::UpperCaseTest::get_alpha



//# run 0xCAFE::UpperCaseTest::get_all_type_names



//# run 0xCAFE::UpperCaseTest::pragma_example --args 5u8


// Features:
// e0625019b1a4d12e7166f2a441c05c98: Define constant, struct, and schema names that start with an uppercase letter ('A'..'Z').
// 83167d7245798f4b191535799142c0f7: Use the 'all_type_names' function to access a set containing all the built-in type names defined in the Move compiler.
// 0f102b2f4db900e14ca00b6b795a3b0d: Add pragma properties for compiler directives.
