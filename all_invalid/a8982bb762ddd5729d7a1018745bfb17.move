// Feature 1: Custom formatting for AST nodes via ast_debug.
// Feature 2: Define Move programs by parsing target and dependency files with address mapping.
// Feature 3: Handle variable bindings in lambda and blocks to determine mutability.

//# publish
module 0xC0DE::AstDebugTest {
    use std::string;
    use std::vector;
    use std::debug::{print, ast_debug};

    /// A fake AST Node for illustrative purposes
    struct AstNode has copy, drop, store {
        value: u8,
        mutable: bool,
    }

    public fun ast_node_new(val: u8, is_mut: bool): AstNode {
        AstNode { value: val, mutable: is_mut }
    }

    /// Custom formatting for AST Node using ast_debug
    public fun debug_ast_node(node: &AstNode) {
        ast_debug::<AstNode>(node);
    }

    public fun runner() {
        let node = ast_node_new(42, true);
        debug_ast_node(&node);
    }
}

//# run 0xC0DE::AstDebugTest::runner --signers 0xC0DE

//# publish
module 0xDEAD::MoveProgramParsing {
    use std::address;
    use std::vector;
    use std::string;
    use std::debug::ast_debug;

    /// Data to represent a Move program with files and address mapping
    struct MoveProgram has copy, drop, store {
        target_files: vector<string::String>,
        dep_files: vector<string::String>,
        address_names: vector<string::String>,
        addresses: vector<address::Address>
    }

    public fun create_sample() : MoveProgram {
        let target_files = vector::empty<string::String>();
        vector::push_back(&mut target_files, string::utf8(b"main.move"));
        let dep_files = vector::empty<string::String>();
        vector::push_back(&mut dep_files, string::utf8(b"stdlib.move"));
        let address_names = vector::empty<string::String>();
        vector::push_back(&mut address_names, string::utf8(b"MainAddr"));
        let addresses = vector::empty<address::Address>();
        vector::push_back(&mut addresses, @0x1337);
        MoveProgram {
            target_files,
            dep_files,
            address_names,
            addresses
        }
    }

    public fun debug_program(prog: &MoveProgram) {
        ast_debug::<MoveProgram>(prog);
    }

    public fun runner() {
        let prog = create_sample();
        debug_program(&prog);
    }
}

//# run 0xDEAD::MoveProgramParsing::runner --signers 0xDEAD

//# publish
module 0xBEEF::VariableBindingMutability {
    use std::string;
    use std::debug::{print, ast_debug};

    /// Pretend Lambda AST node (Move does not support lambdas natively; this is an emulation)
    struct Lambda has copy, drop, store {
        /// All captured bindings, encoded as bool for mutability
        bindings: vector<bool>,
    }

    public fun lambda_new(bindings: vector<bool>): Lambda {
        Lambda { bindings }
    }

    public fun debug_lambda(lambda: &Lambda) {
        ast_debug::<Lambda>(lambda);
        // Print mutability for illustration
        let len = vector::length(&lambda.bindings);
        let i = 0;
        while (i < len) {
            let is_mut = *vector::borrow(&lambda.bindings, i);
            if (is_mut) {
                print(string::utf8(b"Mut binding")); 
            } else {
                print(string::utf8(b"Imm binding"));
            };
            i = i + 1;
        }
    }

    public fun runner() {
        // [true, false, true] means: first is mut, second is imm, third is mut
        let mut bindings = vector::empty<bool>();
        vector::push_back(&mut bindings, true);
        vector::push_back(&mut bindings, false);
        vector::push_back(&mut bindings, true);

        let lambda = lambda_new(bindings);
        debug_lambda(&lambda);
    }
}

//# run 0xBEEF::VariableBindingMutability::runner --signers 0xBEEF