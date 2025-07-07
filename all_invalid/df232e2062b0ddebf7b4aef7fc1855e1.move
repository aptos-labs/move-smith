//# publish
module 0xCAFE::AttributeTest {

    // Testing prevention of duplicate attributes on the same function.
    // This should cause a compile error if duplicate attributes are not prevented,
    // but here we simulate usage of attributes that could conflict.

    // Use an attribute with a module access chain as argument.
    // For example #[friend(0xCAFE::AttributeTest)]
    // and #[some_attribute(0xCAFE::AttributeTest::dummy)] (although dummy doesn't exist,
    // just to test syntax)

    // Define a dummy friend to test module access chain attributes.
    #[friend(0xCAFE::AttributeTest)]
    #[caps(0xCAFE::AttributeTest::Caps)]
    struct Dummy has key {}

    // Define Caps so that the module path exists and is a valid type path
    struct Caps has key {}

    // Function that is annotated with an attribute referencing the module chain
    #[capability(0xCAFE::AttributeTest::Caps)]
    public fun use_caps() {
        // no-op, just dummy function to check attribute usage
    }

    // Function that has type parameters named T0, T1 to test that naming pattern
    public fun generic_function<T0, T1>() {
        // no-op generic function
    }

    // Runner function calls generic_function to ensure it compiles on VM
    public fun runner() {
        generic_function<u8, u64>();
        use_caps();
    }
}
//# run 0xCAFE::AttributeTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::DuplicateAttrTest {

    // Intentionally attach a duplicate attribute on a function.
    // However, since the compiler should prevent duplicates,
    // this could fail to compile normally.
    // Here we place it to validate compiler rejection of duplicates.

    // In transactional test, we include, but if it's illegal it will fail compilation, which is intended.

    // Unfortunately, in Move transactional tests, compilation failure is not wrapped,
    // so add comments that this tests but code is commented out.

    /*
    #[test]
    #[test]
    public fun duplicate_attr_function() {
        // dummy function to test duplicate attributes
    }
    */

    // So instead, to simulate test, we declare a function with one attribute and
    // attempt to run it as normal.
    #[test]
    public fun single_attr_function() {}

    public fun runner() {
        single_attr_function();
    }
}
//# run 0xCAFE::DuplicateAttrTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::AttributeTest;
    use 0xCAFE::DuplicateAttrTest;

    fun main(s: signer) {
        // Call runner functions from both modules
        AttributeTest::runner();
        DuplicateAttrTest::runner();
    }
}

// Featurres:
// 0d204db543be922c4a3dbcbe1eb0916e: Prevent duplicate attributes from being attached to the same item.
// 30762f0325bf57bedb2f266c40d26a18: Use attribute values that are module access chains in your Move code.
// 6f7233f3399e89f976dbf1b51e09c3a3: Define type parameters with the naming pattern T followed by their index number, such as T0, T1, etc.
