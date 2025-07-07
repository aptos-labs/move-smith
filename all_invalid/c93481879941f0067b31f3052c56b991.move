
//# publish
module 0xBEEFBEEF::NestedFieldsTest {
    // Module to test nested field access with dot notation
    struct InnerMost has copy, drop, store {
        value: u64,
    }

    struct Inner has copy, drop, store {
        inner_most: InnerMost,
        flag: bool,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        count: u8,
    }

    public fun create_outer(): Outer {
        Outer {
            inner: Inner {
                inner_most: InnerMost { value: 42 },
                flag: true,
            },
            count: 255,
        }
    }

    public fun access_nested_field(o: &Outer): u64 {
        let inner_ref: &Inner = &o.inner;
        let inner_most_ref: &InnerMost = &inner_ref.inner_most;
        inner_most_ref.value
    }

    public fun get_outer_count(o: &Outer): u8 {
        o.count
    }

    public fun mutate_nested_pointer(o: &mut Outer, new_value: u64) {
        let inner_ref: &mut Inner = &mut o.inner;
        let inner_most_ref: &mut InnerMost = &mut inner_ref.inner_most;
        inner_most_ref.value = new_value;
    }
}



//# run 0xBEEFBEEF::NestedFieldsTest::create_outer --signers 0x0 --args


//# run 0xBEEFBEEF::NestedFieldsTest::access_nested_field --signers 0x0 --args (borrow_global<Outer>(0xBEEFBEEF))
 

//# run 0xBEEFBEEF::NestedFieldsTest::get_outer_count --signers 0x0 --args (borrow_global<Outer>(0xBEEFBEEF))

// For the mutate_nested_pointer test, you need to first have the Outer resource stored globally or as a resource.
// Here's an example of how to do it properly:

// Step 1: Create and publish the Outer resource
// (Assuming a test setup transaction seems missing, but typically you'd do)
    // move_resource<Outer>(signer): publish the resource under a resource handle

// Step 2: Borrow mutably and mutate
// obtain the resource with `borrow_global_mut<Outer>(0xBEEFBEEF)` 
// then call mutate_nested_pointer with the mutable reference

// Example (not directly in the test code, but as steps):
/*
    let outer = borrow_global_mut<Outer>(0xBEEFBEEF);
    mutate_nested_pointer(outer, new_value);
*/


// Note: The current test comments need adjustments because `--args` expects concrete values, not code snippets.  
// So, the following is an example of how the actual run commands would look when properly instantiated:

// e.g., to read the value:
 
//# run 0xBEEFBEEF::NestedFieldsTest::access_nested_field --signers 0x0 --args (borrow_global<Outer>(0xBEEFBEEF))
 
// e.g., to get count:
 
//# run 0xBEEFBEEF::NestedFieldsTest::get_outer_count --signers 0x0 --args (borrow_global<Outer>(0xBEEFBEEF))

// e.g., to mutate:
 // First, get the resource mutably:
 // move it into a variable with borrow_global_mut<Outer>(0xBEEFBEEF)
 // then call mutate_nested_pointer(&mut outer, 100)
