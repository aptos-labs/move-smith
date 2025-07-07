//# publish
module 0xCAFE::ResourceTester {
    use std::signer;

    #[test_only]
    struct MyResource has key, store {
        val: u64,
    }

    #[test_only]
    struct AnotherResource has key, store {
        data: bool,
    }

    #[test_only]
    struct NonKeyResource has store {
        data: u8,
    }

    // This function publishes the resources to the signer address 0xCAFE
    public fun publish_resources(account: &signer) {
        move_to(account, MyResource { val: 42 });
        move_to(account, AnotherResource { data: true });
        // NonKeyResource is not key and cannot be stored globally
    }

    public fun runner(account: &signer) {
        publish_resources(account);
    }
}
//# run 0xCAFE::ResourceTester::runner --signers 0xCAFE

//# publish
module 0xCAFE::AccessWildcard {
    use std::signer;
    use std::vector;

    #[test_only]
    struct SampleResource has key, store {
        val: u64,
    }

    // Store sample resource for testing
    public fun store_resource(account: &signer, v: u64) {
        move_to(account, SampleResource { val: v });
    }

    // A function using resource access specifier with wildcard for 0xCAFE:
    // It reads any resource at 0xCAFE with key ability.
    // Here we try to borrow SampleResource and read val.
    // The wildcard syntax is `resource 0xCAFE::*`.
    public fun read_any_resource(account: &signer): u64 {
        let r = borrow_global::<resource 0xCAFE::SampleResource>(signer::address_of(account));
        r.val
    }

    public fun runner(account: &signer) {
        store_resource(account, 100);
        let value = read_any_resource(account);
        // Normally we would assert value == 100 but assertions are ignored here.
    }
}
//# run 0xCAFE::AccessWildcard::runner --signers 0xCAFE

//# publish
module 0xCAFE::AttributesTest {
    // Use of #[test_only] attribute allowed on struct and function
    #[test_only]
    struct Sample has key, store {
        x: u8,
    }

    #[test_only]
    public fun foo(): u8 {
        42
    }

    // Attribute on variable is invalid and should produce compiler error.
    // However since it will block compilation, it is commented out.
    /*
    public fun invalid_attribute() {
        #[test_only] // <--- INVALID USAGE WILL CAUSE COMPILE ERROR
        let a = 10;
        let _ = a;
    }
    */

    public fun runner() {
        let v = foo();
        let s = Sample { x: v };
        let _ = s;
    }
}
//# run 0xCAFE::AttributesTest::runner

//# run 0xCAFE::ResourceTester::publish_resources --signers 0xCAFE --args 0xCAFE
//# run 0xCAFE::AccessWildcard::store_resource --signers 0xCAFE --args 255u64

//# run
script {
    use std::signer;

    fun main(account: signer) {
        0xCAFE::ResourceTester::publish_resources(&account);
        0xCAFE::AccessWildcard::store_resource(&account, 7);
        let val = 0xCAFE::AccessWildcard::read_any_resource(&account);
        0xCAFE::AttributesTest::runner();
    }
}

// Featurres:
// fb32f3b3b1dcf46b73265725e707d593: Specify the address for a Move module, which can be checked for redundancy and correctness.
// 359d9bc6b6fafec3cc414216de87497c: Use attributes in allowed positions only (e.g., module-level, function-level), with compiler errors for misplacement.
// ea874dba7c85a3b76c3080088ee75368: Use resource access specifiers with a single wildcard '*' to refer to any resource at a specified address.
