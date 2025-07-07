
//# publish
module 0xDEAD::CheckerModule {
    use std::vector;

    // Simulate external checkers with functions returning names
    public fun get_expression_checker_names(): vector<vector<u8>> {
        let names = vector::empty<vector<u8>>();
        vector::push_back(&mut names, b"ExprCheckerA");
        vector::push_back(&mut names, b"ExprCheckerB");
        names
    }

    public fun get_stackless_bytecode_checker_names(): vector<vector<u8>> {
        let names = vector::empty<vector<u8>>();
        vector::push_back(&mut names, b"BytecodeCheckerX");
        vector::push_back(&mut names, b"BytecodeCheckerY");
        names
    }
}


//# run 0xDEAD::CheckerModule::get_checker_names --args

//# run 0xDEAD::CheckerModule::get_expression_checker_names


//# run 0xDEAD::CheckerModule::get_stackless_bytecode_checker_names


// Featurres:
// ce29afbf945994b277803b5cc868e705: Collect and return the names of both expression checkers and stackless bytecode checkers from external checkers.
// db182f61cddf013e209db17e91839462: Organize modules with named address mapping (for display).
// afb0a1624dc5f2c0b230db31bd6c92a1: Return values from functions using the 'return' keyword, optionally with an expression to return a value.
