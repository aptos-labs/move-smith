// # publish
module 0xCAFE::DepTest {
    #[deprecated]
    public fun deprecated_fn(): u64 {
        42
    }

    #[deprecated]
    public fun foo(x: u64): u64 {
        // foo returns 1 + 1 regardless of input, testing deprecation and return
        1 + 1
    }

    public fun bar(): bool {
        // Test that foo(3) == 2, should be always true
        let result = foo(3);
        assert!(result == 2, 1001);
        true
    }

    public inline fun run(): bool {
        // Call the deprecated function (allowed but marked deprecated)
        let _ = deprecated_fn();

        // Call foo once
        let val = foo(0);

        // Call bar to enforce foo(3) == 2 assertion did not fail
        let _ = bar();

        // Testing lambda expression features
        // A lambda that adds 10 + 20 with captures [] and no spec
        let lam0 = lambda([], 10 + 20, move, none);
        let _ : u64 = lam0();

        // A lambda taking one parameter and returns it + 5
        let lam1 = lambda([x: u64], x + 5, move, none);
        let res1 = lam1(7);

        // A lambda capturing a local variable y by move and returning y * 2
        let y = 8;
        let lam2 = lambda([], y * 2, move, none);
        let res2 = lam2();

        // Ensure returned values have expected type
        let _ : u64 = res1;
        let _ : u64 = res2;

        true
    }
}
// # run 0xCAFE::DepTest::run --signers 0xCAFE


// # run
script {
    use 0xCAFE::DepTest;

    fun main(_signer: signer) {
        // Directly call deprecated function from script to test deprecated annotation effect
        let _ = DepTest::deprecated_fn();

        // Call foo and check sum return
        let val = DepTest::foo(7);
        // Call bar that asserts foo(3) == 2 internally
        let bar_result = DepTest::bar();

        // Run the internal run to test lambdas and deprecated call in module
        let run_result = DepTest::run();

        // No assertions needed per instruction
    }
}

// Featurres:
// 61f09ed7a7df1ead29aa123b533315c4: Annotate functions or modules with `#[deprecated]` to mark them as deprecated.
// 0ab78326b7412b7dcbf217da882c3957: Test that the function `foo` correctly returns the sum of 1 and 1, and verify that the `bar` function asserts `foo(3) == 2` successfully.
// c0c8a4b2360d571e1626e0a75d202223: Define anonymous functions (lambdas) with the `lambda` expression, including parameter bind lists, the body expression, capture kind, and optional specification.
