
//# run 0xBADD::InteractionTest::test_nested_field_access

//# run 0xBADD::InteractionTest::test_deprecation_propagation

//# run 0xBADD::InteractionTest::test_function_assignments

//# run 0xBADD::InteractionTest::test_function_invocation

//# run 0xBADD::InteractionTest::test_spec_checks

//# run 0xBADD::InteractionTest::test_parse_access_specifier

//# run 0xBADD::InteractionTest::test_read_source_files

//# run 0xBADD::InteractionTest::test_enum_pattern_matching


//# publish
module 0xBADD::InteractionTest {
    use std::vector;
    use std::string;
    use std::signer;

    // --- Modules with nested fields and generics ---

    // Module with nested enum and structs
//# publish
    module 0xBADD::NestedModules {
        struct Outer has store, key {
            inner: Inner,
        }

        struct Inner has store, key {
            value: u64,
        }

        enum OuterEnum has copy, drop {
            Variant1,
            Variant2 { inner_value: u64 },
        }

        public fun access_nested_field(outer: &Outer): u64 {
            let inner_ref: &Inner = &outer.inner;
            inner_ref.value
        }

        public fun create_outer(val: u64): Outer {
            Outer { inner: Inner { value: val } }
        }

        public fun create_outer_enum(v: u64): OuterEnum {
            OuterEnum::Variant2 { inner_value: v }
        }
    }

    // --- Deprecation attribute test ---
    // Mark entire address as deprecated by simulating (no real annotation needed in Move)
    // and assume all modules under this address are deprecated (for test, just document)
    // In Move, no built-in deprecation attribute, so we use comments or conventions

    // --- Function pointer and closure tests ---
//# publish
    module 0xBADD::FuncTests {
        // Functions to assign to variables
        public fun add_u8(a: u8, b: u8): u8 {
            a + b
        }

        public fun mul_u16(a: u16, b: u16): u16 {
            a * b
        }

        // Function passing
        public fun apply_func(f: |u8, u8|u8, x: u8, y: u8): u8 {
            f(x, y)
        }

        public fun apply_generic_func<T: copy + drop>(f: |T, T|T, a: T, b: T): T {
            f(a, b)
        }

        // Closure as variable
        public fun closure_example(): u8 {
            let lambda: |u8, u8|u8 = |a: u8, b: u8| a + b;
            lambda(10, 20)
        }
    }

    // --- Specification and purity checks ---
//# publish
    module 0xBADD::SpecChecks {
        // Simulated standard checks: in real Move, purity is enforced statically
        public fun pure_fun(x: u64): u64 {
            x + 10
        }

        public fun impure_fun(): u64 {
            // Impure due to side effect (simulate)
            let global_val: &mut u64 = 0xBADD::Globals::get_global_u64();
            *global_val = *global_val + 1;
            *global_val
        }

        // Nesting enum with match and ensuring correctness
        enum NestedEnum has copy, drop {
            A,
            B(u64),
            C { label: bool },
        }

        public fun match_nested_enum(e: NestedEnum): u64 {
            match (e) {
                NestedEnum::A => 1,
                NestedEnum::B(v) => v,
                NestedEnum::C { label } => if (label) { 2 } else { 3 },
            }
        }
    }

    // --- Parsing access specifier string ---
    // Since Move does not have runtime parse, simulate parsing function
    // The function will take a string and extract address, module, and optional type args
    public fun parse_access_specifier(spec: vector<u8>): (address, vector<u8>, option<vector<u8>>) {
        // Pseudocode: in test, just simulate parsing
        // For simplicity, assume spec format: b"<address>::<module>::<name>[<type_args>]"
        // e.g., b"0xCAFE::MyModule::func<2>"
        // For test: return dummy values
        (0xCAFE, b"MyModule", some(b""))
    }

    // --- File reading ---
    // As Move does not support file I/O in runtime, simulate
    public fun read_source_file(path: vector<u8>): vector<u8> {
        // Simulate by returning dummy content based on path
        b"dummy source file content"
    }

    // --- Pattern matching on nested enums with resource semantics ---
    enum ResourceEnum has key, drop {
        ResourceA,
        ResourceB { id: u64 },
        ResourceC,
    }

    public fun match_resource_enum(e: &ResourceEnum): u64 {
        match (e) {
            ResourceEnum::ResourceA => 0,
            ResourceEnum::ResourceB { id } => id,
            ResourceEnum::ResourceC => 42,
        }
    }
}


//# run 0xBADD::InteractionTest::test_nested_field_access

//# run 0xBADD::InteractionTest::test_deprecation_propagation

//# run 0xBADD::InteractionTest::test_function_assignments

//# run 0xBADD::InteractionTest::test_function_invocation

//# run 0xBADD::InteractionTest::test_spec_checks

//# run 0xBADD::InteractionTest::test_parse_access_specifier

//# run 0xBADD::InteractionTest::test_read_source_files

//# run 0xBADD::InteractionTest::test_enum_pattern_matching
