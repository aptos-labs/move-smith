//# publish
address 0xCAFE {
    module LocalVarStatus {
        use std::vector;
        use std::string;

        /// A struct to track initialization status of local variables
        struct VarStatus has copy, drop, store {
            name: vector<u8>,
            initialized: bool,
        }

        /// Returns a human-readable string indicating which local variables are initialized or not.
        public fun local_vars_status(vars: vector<VarStatus>): vector<u8> {
            let mut result = b"Local variable initialization status:\n".to_vec();
            let len = vector::length(&vars);
            let mut i = 0;
            while (i < len) {
                let var = &vars[i];
                let status_str = if (var.initialized) { b"initialized" } else { b"not initialized" };
                result = vector::concat(&result, &var.name);
                result = vector::concat(&result, b": ");
                result = vector::concat(&result, status_str);
                result = vector::concat(&result, b"\n");
                i = i + 1;
            }
            result
        }

        /// Parses an address assignment string and validates it contains exactly one '=' character.
        /// Returns true if valid, false otherwise.
        public fun validate_address_assignment(s: vector<u8>): bool {
            let len = vector::length(&s);
            let mut count_eq = 0u64;
            let mut i = 0u64;
            while (i < len) {
                let c = *vector::borrow(&s, i);
                if (c == (b'=' as u8)) {
                    count_eq = count_eq + 1;
                }
                i = i + 1;
            }
            count_eq == 1
        }

        /// Dummy enum to represent a very simplified AST node for a function.
        /// In real compiler this would be complex, here we just test ability to handle enum and pattern match.
        enum AstNode has copy, drop, store {
            Function { name: vector<u8>, body: vector<u8> }, // body as bytes to simplify
            Empty,
        }

        /// Dummy representation of environment holding AST nodes.
        struct Env has copy, drop, store {
            functions: vector<AstNode>,
        }

        /// A dummy bytecode representation for compiled functions.
        struct Bytecode has copy, drop, store {
            code: vector<u8>,
        }

        /// Generates dummy bytecode from AST in the environment.
        /// For each Function node, produces a bytecode that is just the body uppercased.
        /// (Just to simulate some compile step)
        public fun generate_bytecode(env: &Env): vector<Bytecode> {
            let mut result = vector::empty<Bytecode>();
            let len = vector::length(&env.functions);
            let mut i = 0;
            while (i < len) {
                let fn_node = &env.functions[i];
                let bytecode = match fn_node {
                    AstNode::Function { name: _name, body } => {
                        // uppercase body bytes (dummy "compilation")
                        let mut bc = vector::empty<u8>();
                        let body_len = vector::length(body);
                        let mut j = 0;
                        while (j < body_len) {
                            let c = *vector::borrow(body, j);
                            if (c >= (b'a' as u8) && c <= (b'z' as u8)) {
                                bc = vector::push_back(&mut bc, c - 32);
                            } else {
                                bc = vector::push_back(&mut bc, c);
                            }
                            j = j + 1;
                        }
                        Bytecode { code: bc }
                    }
                    _ => Bytecode { code: b"".to_vec() },
                };
                result = vector::push_back(&mut result, bytecode);
                i = i + 1;
            }
            result
        }

        public fun runner(): vector<u8> {
            // Test local_vars_status
            let vars = vector::empty<VarStatus>();
            let vars = vector::push_back(&mut vars, VarStatus { name: b"x".to_vec(), initialized: true });
            let vars = vector::push_back(&mut vars, VarStatus { name: b"y".to_vec(), initialized: false });
            let status = local_vars_status(vars);

            // Test validate_address_assignment
            let valid_str = b"address=0xCAFE".to_vec();
            let invalid_str1 = b"address0xCAFE".to_vec();
            let invalid_str2 = b"address==0xCAFE".to_vec();

            let valid = validate_address_assignment(valid_str);
            let invalid1 = validate_address_assignment(invalid_str1);
            let invalid2 = validate_address_assignment(invalid_str2);

            // Compose a result string showing these validation results
            let mut res = status;
            res = vector::concat(&res, b"Valid assign string test: ");
            res = vector::concat(&res, if(valid) { b"true\n" } else { b"false\n" });
            res = vector::concat(&res, b"Invalid assign string test #1: ");
            res = vector::concat(&res, if(invalid1) { b"true\n" } else { b"false\n" });
            res = vector::concat(&res, b"Invalid assign string test #2: ");
            res = vector::concat(&res, if(invalid2) { b"true\n" } else { b"false\n" });

            // Test generate_bytecode
            let fn1 = AstNode::Function { name: b"f".to_vec(), body: b"let x = 1;".to_vec() };
            let fn2 = AstNode::Empty;
            let env = Env { functions: vector::push_back(&mut vector::empty<AstNode>(), fn1) };
            let bytecodes = generate_bytecode(&env);
            let bc = &bytecodes[0];
            res = vector::concat(&res, b"Generated bytecode for function f: ");
            res = vector::concat(&res, &bc.code);
            res = vector::concat(&res, b"\n");
            res
        }
    }
}
//# run 0xCAFE::LocalVarStatus::runner


//# run
script {
    use 0xCAFE::LocalVarStatus;

    fun main() {
        let output = LocalVarStatus::runner();
        let _ = output;
    }
}