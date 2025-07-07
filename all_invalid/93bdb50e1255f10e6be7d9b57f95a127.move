module 0x1::Test {

    use std::signer;
    use std::vector;

    // 2: Deprecate a function
    #[deprecated(note = "Use `foo_v2` instead")]
    public fun foo(x: u64, y: u64): u64 {
        x + y
    }

    public fun foo_v2(x: u64, y: u64): u64 {
        x + y
    }

    // 1: The test function running an anonymous function calling foo
    #[test]
    public fun test(): u64 {
        let a = 7;
        let b = 8;

        // anonymous function captures a,b and returns foo(a,b)
        let anon = |x: u64, y: u64| foo(x, y);

        let result = anon(a, b);

        // 3: destructure a tuple into variables using bind lists
        let (res, rest) = (result, 999);

        assert!(res == (a + b), 101);
        assert!(rest == 999, 102);

        res
    }
}

// Featurres:
// aa50acf4cce1255072a3c900d0e74c00: Run the `test` function to verify that the anonymous function correctly calls the `foo` function with the specified arguments and returns the expected sum.
// 2727731fcfe3c6a7fa9707320adbd25a: Mark member items (such as functions, structs, or constants) as deprecated using Move's #[deprecated] annotation to signal their deprecation to users.
// c54d09338ad91d95c10d2e50808e675b: Destructure values using bind lists in variable assignment patterns
