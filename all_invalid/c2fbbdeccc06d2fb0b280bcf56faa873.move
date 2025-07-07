
//# publish
module 0xBEEB::TestNestedFields {
    use std::assert;

    struct InnerStruct has copy, drop {
        inner_field: u64,
    }

    struct OuterStruct has copy, drop {
        a: u64,
        b: InnerStruct,
    }

    public fun create_outer(signer: &signer) acquires OuterStruct {
        let inner = InnerStruct { inner_field: 42 };
        let outer = OuterStruct { a: 100, b: inner };
        move_to<OuterStruct>(signer, outer);
    }

    public fun get_inner_field(addr: address): u64 acquires OuterStruct {
        let outer_ref: &OuterStruct = borrow_global<OuterStruct>(addr);
        outer_ref.b.inner_field
    }
}



//# run --signers 0xCAFE --args



//# publish
module 0xCAFE::ControlFlowTest {
    // Testing variable shadowing and block expression modifications
    struct TestStruct has copy, drop {
        count: u64,
        value: u64,
    }

    public fun init_test_struct(): TestStruct {
        TestStruct { count: 0, value: 10 }
    }

    public fun shadow_and_modify(s: &mut TestStruct): u64 {
        let count = s.count;
        {
            let count_shadow = 99; // shadow outer variable
            count = count_shadow; // modify local variable within block
        }
        s.count = count; // update the struct field
        s.count + s.value
    }
}



//# run --signers 0xCAFE --args



//# publish
module 0xCAFE::VisibilityRestrictions {
    // Defining internal functions within this module
    fun internal_secret(): u64 {
        999
    }

    public fun try_access_secret(): u64 {
        // Access to internal function within same module
        internal_secret()
    }
}



//# run --signers 0xCAFE --args


// SourceLocation: 0xCAFE::SourceMetadata

//# publish
module 0xCAFE::SourceMetadata {
    // Metadata attached to module for source location
    // This is to verify metadata correctness
    // Source: /path/to/source/file.move

    public fun get_metadata(): vector<u8> {
        b"source_location: /path/to/source/file.move"
    }
}



//# run --signers 0xCAFE --args



//# publish
module 0xCAFE::BlockExpressionTest {
    // Testing variable modification inside a block as expression
    public fun block_as_expression(x: u64): u64 {
        let result = {
            let temp = x + 10;
            // modify temp inside block
            temp + 5
        };
        result
    }
}



//# run --signers 0xCAFE --args




//# Testing interactions: call nested access, scope, visibility, and metadata


//# The following transactional commands incorporate all aforementioned features into a comprehensive test scenario.

// Initialize the nested struct in 0xBEEB :: TestNestedFields


//# run 0xBEEB::TestNestedFields::create_outer --signers 0xCAFE

// Verify correct nested field access


//# run 0xBEEB::TestNestedFields::get_inner_field --signers 0xCAFE --args 0xCAFE

// Variable shadowing and block expression test


//# run 0xCAFE::ControlFlowTest::init_test_struct --signers 0xCAFE


//# run 0xCAFE::ControlFlowTest::shadow_and_modify --signers 0xCAFE --args


// Attempt to access internal function from outside module (should fail if not accessible; this line is for conceptual testing)
// This line is illustrative; in practice, trying to access internal_secret from outside would be compile error
// Uncommenting this should cause compile error if not accessible
// let _ = 0xCAFE::VisibilityRestrictions::internal_secret();

// Access the metadata to verify correct source location annotation


//# run 0xCAFE::SourceMetadata::get_metadata --signers 0xCAFE

// Use block as expression modifying local variable


//# run 0xCAFE::BlockExpressionTest::block_as_expression --signers 0xCAFE --args 7u64
