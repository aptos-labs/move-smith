//# publish
module 0xCAFE::GenericDropCapture {
    use std::signer;
    use std::vector;
    use std::string;

    // A generic struct with drop ability.
    struct WrapDrop<T: drop> has store, drop {
        value: T,
    }

    // A resource with key and store abilities containing WrapDrop<u64>
    struct MyResource has key, store {
        wrapped: WrapDrop<u64>,
    }

    // Create and publish MyResource under signer.
    public fun create_resource(account: &signer) {
        let wrapped = WrapDrop { value: 42u64 };
        let r = MyResource { wrapped };
        move_to(account, r);
    }

    // Runner function to test '..' pattern in let binding and tuple unpacking.
    public fun test_patterns(): bool {
        let (a, ..) = (true, 5u8, 10u64);
        let (x, y, ..) = (1u8, 2u8, 3u8, 4u8);
        // Use variables to avoid warnings
        if a && (x < y) {
            true
        } else {
            false
        }
    }

    // Runner function to test a lambda capturing a generic drop type and use equality inside the lambda.
    // Note: lambdas must be inside functions in scripts or modules in Move.
    // Move's "lambda" syntax is just inline unnamed functions or closures, which we approximate via inline function.
    public fun test_lambda_equals<T: drop>(input: T, other: T): bool {
        // Define a lambda that captures input by copy and compares with other using `==`
        // input: T has to implement 'drop', so we can capture it.
        // For equality, T must support ==. For demo, we call std::vector::equal for vector<u8> etc,
        // but since T is generic, we just compare false as fallback.
        // To really test == for generic T, test with u64 (primitive) or vector<u8> (builtin eq).
        // We'll assume T supports == for this test.
        let equals = fun (x: &T): bool {
            *x == other
        };
        equals(&input)
    }

    // A specific wrapper function to call the generic test_lambda_equals with u64, to be run.
    public fun run_lambda_u64(): bool {
        test_lambda_equals(10u64, 10u64)
    }

    // A specific wrapper function to call the generic test_lambda_equals with vector<u8> (copyable and droppable by std).
    public fun run_lambda_vector_u8(): bool {
        let v1 = b"Hello";
        let v2 = b"Hello";
        test_lambda_equals<vector<u8>>(vector::copy(&v1), vector::copy(&v2))
    }
}
//# run 0xCAFE::GenericDropCapture::create_resource --signers 0xCAFE
//# run 0xCAFE::GenericDropCapture::test_patterns
//# run 0xCAFE::GenericDropCapture::run_lambda_u64
//# run 0xCAFE::GenericDropCapture::run_lambda_vector_u8

//# run
script {
    use 0xCAFE::GenericDropCapture;

    fun main() {
        // Call create_resource to test resource move_to
        GenericDropCapture::create_resource(&(signer::spec_signer_of_address(0xCAFE)));

        // Call pattern test
        let _ = GenericDropCapture::test_patterns();

        // Call lambda tests
        let res1 = GenericDropCapture::run_lambda_u64();
        let res2 = GenericDropCapture::run_lambda_vector_u8();

        // Silence warnings by using the results
        if (!res1 || !res2) {
            abort 1;
        }
    }
}

// Featurres:
// 9def49343c650663209a2268dd6c0e84: Define Move modules to encapsulate related code and resources.
// 028ba79c0d2d6550c16b84253f99819a: Use '..' patterns in Move code to match an unspecified or rest pattern in bindings.
// c0456763eb6fc192c4bd2b7f62e34240: Test that lambdas can capture variables of generic types with the drop ability and use equality (==) inside the lambda body.
