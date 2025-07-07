
//# publish
module 0xCAFE::PrimaryExpressionsTest {
    use std::signer;

    const CONST_U8: u8 = 42;
    const CONST_BOOL: bool = true;
    const CONST_ADDRESS: address = @0xCAFE;
    const CONST_BYTESTRING: vector<u8> = b"TestBytes";

    struct Container has store {
        flag: bool,
        count: u8,
        data: vector<u8>,
        owner: address,
    }

    public fun create_container(s: signer): Container {
        let flag = CONST_BOOL;
        let count = CONST_U8;
        let data = CONST_BYTESTRING;
        let owner = signer::address_of(&s);
        Container { flag, count, data, owner }
    }

    public fun test_literals_and_names(): (u8, bool, address, vector<u8>) {
        let n: u8 = 100u8;
        let b: bool = false;
        let a: address = @0xCAFE;
        let bs: vector<u8> = b"Hello\nWorld";

        (n, b, a, bs)
    }

    public fun nested_expressions(): u8 {
        let a = 10u8;
        let b = 20u8;
        let c = (a + b) * 2u8;
        c
    }
}


//# run 0xCAFE::PrimaryExpressionsTest::create_container --signers 0xBEEF


//# run 0xCAFE::PrimaryExpressionsTest::test_literals_and_names


//# run 0xCAFE::PrimaryExpressionsTest::nested_expressions


// Featurres:
// 8e6fca7ad7a41c88c6b4a550ff9e7b3e: Create primary expressions such as name references and value literals (like numbers, booleans, byte strings).
// 1d9fa496d61af9b5404ccf32b1548863: Use module keys that include an optional address and a module name.
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
