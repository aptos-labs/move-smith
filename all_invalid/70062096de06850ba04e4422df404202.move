//# publish
module 0x1::BytecodeGen {
    use std::vector;

    // A struct representing a simple AST node type: a numeric literal
    struct ASTNode has copy, drop, store {
        value: u64,
    }

    // A struct for Bytecode representing a function (dummy example)
    struct BytecodeFunction has copy, drop, store {
        function_name: vector<u8>,
        instructions: vector<u8>,
    }

    // Public function with explicit visibility: generates bytecode from AST
    public fun generate_bytecode(ast: &ASTNode): BytecodeFunction {
        // For the test, simply encode the u64 value in little-endian bytes as a placeholder
        let mut bytes = vector::empty<u8>();
        let val = ast.value;
        vector::push_back(&mut bytes, ((val >> 0) & 0xFF) as u8);
        vector::push_back(&mut bytes, ((val >> 8) & 0xFF) as u8);
        vector::push_back(&mut bytes, ((val >> 16) & 0xFF) as u8);
        vector::push_back(&mut bytes, ((val >> 24) & 0xFF) as u8);
        vector::push_back(&mut bytes, ((val >> 32) & 0xFF) as u8);
        vector::push_back(&mut bytes, ((val >> 40) & 0xFF) as u8);
        vector::push_back(&mut bytes, ((val >> 48) & 0xFF) as u8);
        vector::push_back(&mut bytes, ((val >> 56) & 0xFF) as u8);

        BytecodeFunction {
            function_name: b"generated_func".to_vec(),
            instructions: bytes,
        }
    }

    // Private function (default is private) to ensure visibility tests
    fun helper_function(): u8 {
        10
    }

    // Public fun that calls our generator to be used in runner call without args
    public fun run_generate() {
        let ast = ASTNode { value: 0x12345678abcdef01 };
        let _bc = generate_bytecode(&ast);
        // No assertions needed
    }
}

//# run 0x1::BytecodeGen::run_generate

//# publish
module 0x1::SchemaMembers {
    use std::string;
    use std::vector;

    /// A struct representing a schema member definition
    struct SchemaMember has copy, drop, store {
        name: vector<u8>,
        ty: vector<u8>, // Type encoded as bytes (simply bytes of type name string)
    }

    /// A container for schema members
    struct Schema has copy, drop, store {
        members: vector<SchemaMember>,
    }

    // Public function to add a schema member to a schema given target name and type
    public fun add_member(schema: &mut Schema, name: &vector<u8>, type_name: &vector<u8>) {
        let member = SchemaMember {
            name: vector::clone(name),
            ty: vector::clone(type_name),
        };
        vector::push_back(&mut schema.members, member);
    }

    // Public runner function to create a schema and add some members based on target specs
    public fun create_schema_and_members() {
        let mut schema = Schema { members: vector::empty<SchemaMember>() };

        let name1 = b"field1".to_vec();
        let type1 = b"u64".to_vec();
        add_member(&mut schema, &name1, &type1);

        let name2 = b"field2".to_vec();
        let type2 = b"bool".to_vec();
        add_member(&mut schema, &name2, &type2);

        // We do not assert, just ensuring the code runs and compiles
    }
}

//# run 0x1::SchemaMembers::create_schema_and_members


//# publish
module 0x1::VisibilityTest {
    // Explicitly public function
    public fun public_function(): u8 {
        42
    }

    // Explicitly friend function - friend visibility only permits
    // friend modules, but here let's just add it for visibility testing
    friend fun friend_function(): u8 {
        43
    }

    // Implicit private function (default)
    fun private_function(): u8 {
        44
    }

    // Public runner that calls all three to exercise their bytecode generation and execution
    public fun run_all() {
        let _a = public_function();
        let _b = friend_function();
        let _c = private_function();
    }
}

//# run 0x1::VisibilityTest::run_all