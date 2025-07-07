
//# publish
module 0xCAFE::PrimaryExprTest {
    use std::signer;

    const VAL_U8: u8 = 42u8;
    const VAL_U64: u64 = 1234567890u64;
    const VAL_BOOL_TRUE: bool = true;
    const VAL_BOOL_FALSE: bool = false;
    const VAL_BYTE_STRING: vector<u8> = b"MoveTest";

    struct Data has copy, drop, store {
        a: u8,
        b: bool,
        c: vector<u8>,
    }

    public fun create_data(): Data {
        let a = VAL_U8;
        let b = VAL_BOOL_TRUE;
        let c = VAL_BYTE_STRING;

        Data { a, b, c }
    }

    public fun use_address_module_key(): u64 {
        0xCAFE::PrimaryExprTest::VAL_U64
    }

    public fun invalid_token_in_list() {
        let v = vector[1u8, 2u8 /* error token */, 3u8];
        // This is a dummy function illustrating unexpected token scenario.
    }

    public fun test_assertions(x: u8) {
        assert!(x < 100, 101);
        assert!(x > 0, 102);
        assert!(VAL_BOOL_TRUE, 103);
    }

    public fun assign_through_references(s: signer) {
        let data = Data { a: 0u8, b: false, c: b"" };
        let mut_ref: &mut Data = &mut move_from<Data>(signer::address_of(&s));
        mut_ref.a = 10u8;
        mut_ref.b = true;

        // Nested fields and complex expressions
        let lambda: |&mut Data| {
            |d| {
                d.a = d.a + 1;
                d.b = !d.b;
            }
        };

        lambda(mut_ref);

        move_to<Data>(&s, *mut_ref);
    }

    public fun create_and_move_back(s: signer) {
        let data = create_data();
        move_to<Data>(&s, data);
    }

    public fun read_data(s: signer): u8 {
        let data_ref = borrow_global<Data>(signer::address_of(&s));
        data_ref.a
    }
}


//# run 0xCAFE::PrimaryExprTest::create_data


//# run 0xCAFE::PrimaryExprTest::use_address_module_key


//# run 0xCAFE::PrimaryExprTest::test_assertions --args 50u8


//# run 0xCAFE::PrimaryExprTest::create_and_move_back --signers 0xBEEF


//# run 0xCAFE::PrimaryExprTest::assign_through_references --signers 0xBEEF


//# run 0xCAFE::PrimaryExprTest::read_data --signers 0xBEEF


//# publish
module 0xCAFE::UseModule {
    use 0xCAFE::PrimaryExprTest;
    use std::vector;

    public fun call_create_data(): PrimaryExprTest::Data {
        PrimaryExprTest::create_data()
    }

    public fun call_with_assert(x: u8) {
        PrimaryExprTest::test_assertions(x);
    }

    public fun test_vector_literals() {
        let v1 = vector[1u8, 2u8, 3u8];
        let v2 = b"abc";
        let v3 = x"deadbeef";

        assert!(vector::length(&v1) == 3, 299);
        assert!(vector::length(&v2) == 3, 300);
        assert!(vector::length(&v3) == 4, 301);
    }
}


//# run 0xCAFE::UseModule::call_create_data


//# run 0xCAFE::UseModule::call_with_assert --args 42u8


//# run 0xCAFE::UseModule::test_vector_literals


//# run
script {
    use std::signer;
    use 0xCAFE::PrimaryExprTest;

    fun run() {
        let signer_address = @0xDEAD;
        // Forging a signer for test purposes is okay here because it is a script environment.

        // Create and store data
        PrimaryExprTest::create_and_move_back(
            signer::spec_only_signer(signer_address)
        );

        // Read the stored data field a
        let val = PrimaryExprTest::read_data(
            signer::spec_only_signer(signer_address)
        );

        // Perform assertions on val
        assert!(val == 42u8, 500);

        // Assign through references test
        PrimaryExprTest::assign_through_references(
            signer::spec_only_signer(signer_address)
        );
    }
}


// Featurres:
// 8e6fca7ad7a41c88c6b4a550ff9e7b3e: Create primary expressions such as name references and value literals (like numbers, booleans, byte strings).
// 1d9fa496d61af9b5404ccf32b1548863: Use module keys that include an optional address and a module name.
// 3e0f2ec389d2f5a25651202c272a349e: Handle unexpected tokens within list elements by providing descriptive error messages.
// 30cf24c5e166194fa65e2c2380510d3b: Import other modules using 'use' dependencies.
// 5e0902799ab755c35a5cabcf13775d0a: Write 'assert' specifications in Move code to add conditions that must hold at a point.
// affb833837439dde63faf7f0eb8dcc8a: Define script blocks using the 'script' keyword.
// b6e96a49b120efc88bc72a8870c6502e: Test that assignment through &mut references (including to fields, nested fields, complex expressions, inline functions, temporaries, and closures) is correctly type-checked, handled, and never mutates non-mutable values or temporaries in the Aptos Move language.
