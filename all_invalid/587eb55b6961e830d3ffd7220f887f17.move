
//# publish
module 0xCAFE::LambdaTests {
    use std::debug;

    public fun runner() {
        // This is a runner function to invoke various test cases
        // 1. Create lambda with pipe syntax
        let lambda_pipe = |x: u64| { x + 1 };
        debug::print(&lambda_pipe(10));

        // 2. Create lambda with double-pipe syntax
        let lambda_double_pipe = || { 42 };
        debug::print(&lambda_double_pipe());

        // 3. Use address literal in expression
        let addr: address = 0xDEAD_BEEF;
        debug::print(&addr);

        // 4. Use unit type in function signature
        let unit_result: () = self.unit_function();

        // 5. Use lambda with address literal
        let lambda_addr = |a: address| { a };
        debug::print(&lambda_addr(0xBADD_C0DE));

        // 6. Lambda returning unit type
        let lambda_unit = || { debug::print(&b"Hello Lambda\n".to_bytes()) };
        lambda_unit();
    }

    public fun unit_function(): () {
        // Function returning unit type
    }
}



//# run 0xCAFE::LambdaTests::runner