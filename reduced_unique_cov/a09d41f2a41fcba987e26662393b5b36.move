
//# publish
module 0xCAFE::MathUtil {
    // Simple add function that returns the result of adding two u8 values plus one
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // A lambda returning u8 that adds two numbers and increments result by 2
    public fun lambda_add(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b + 2
        };
        f(x, y)
    }

    // An inline function returning a tuple of (u16, u16), used to test item (3)
    public inline fun inline_tuple(a: u16): (u16, u16) {
        (a + 10, a + 20)
    }

    // Lambda that takes a lambda and a u8, returning the result of the lambda called 
    public fun call_lambda(f: |u8| u8, x: u8): u8 {
        f(x)
    }
}


//# publish
module 0xCAFE::AliasTest {
    // use aliasing imports from MathUtil
    use 0xCAFE::MathUtil as MU;

    // A friend function to call friend function in MathUtil and return the result
    public(friend) fun friend_add(a: u8, b: u8): u8 {
        MU::add_and_increment(a, b)
    }

    public fun use_inline(a: u16): (u16, u16) {
        MU::inline_tuple(a)
    }

    // Lambda function inside aliasing module
    public fun play_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(a, b)
    }
}


//# publish
module 0xCAFE::ResourceController {
    use 0xCAFE::AliasTest as AT;
    use std::signer;

    struct Resource has store, key {
        value: u8
    }

    // Restrict this function only to friend modules (including AliasTest and MathUtil)
    public(friend) fun init_resource(s: signer, val: u8) {
        let r = Resource { value: val };
        move_to<Resource>(&s, r);
    }

    // Public function to read resource's value
    public fun read_resource(s: signer): u8 {
        let r_ref = borrow_global<Resource>(signer::address_of(&s));
        r_ref.value
    }

    // Public friend function to safely update resource value after checking permission
    public(friend) fun safe_update_resource(s: signer, val: u8) {
        let r_ref_mut = borrow_global_mut<Resource>(signer::address_of(&s));
        r_ref_mut.value = val;
    }

    // function to test nested calls usage and resource permission control
    public fun nested_operations(s: signer, x: u8, y: u8): u8 {
        // Use friend function within AliasTest to get sum + 1
        let sum_inc = AT::friend_add(x, y);

        // Initialize resource with this sum_inc using friend function from this module
        Self::init_resource(s, sum_inc);

        // Call a public function in AliasTest to compute the product of x and y
        let product = AT::play_lambda(x, y);

        // Update resource with product safely using friend function
        Self::safe_update_resource(s, product);

        // Read back the resource value
        let result = Self::read_resource(s);

        result
    }
}


//# run 0xCAFE::MathUtil::add_and_increment --args 5u8 10u8


//# run 0xCAFE::MathUtil::lambda_add --args 3u8 4u8


//# run 0xCAFE::AliasTest::use_inline --args 50u16


//# run 0xCAFE::AliasTest::play_lambda --args 6u8 7u8


//# run 0xCAFE::ResourceController::init_resource --signers 0xABCD --args 42u8


//# run 0xCAFE::ResourceController::read_resource --signers 0xABCD


//# run 0xCAFE::ResourceController::safe_update_resource --signers 0xABCD --args 99u8


//# run 0xCAFE::ResourceController::read_resource --signers 0xABCD


//# run 0xCAFE::ResourceController::nested_operations --signers 0xABCD --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 55c797bfffbc304fd73fe6bbfbc37f89: Use 'use' declarations within a module to alias imported items.
// 77b76987aa9c6f635d7fcbed173fe43a: Test that nested work operations with different modules correctly manage resource permissions and do not cause unauthorized access or conflicting updates.
// cb43a6730038524c90a860212e3eb3fb: Restrict visibility of functions and modules to friends using the 'public(friend)' visibility modifier.
