//# publish
address 0x1 {
    module ProgramParser {
        /// Dummy struct to represent a parsed program
        struct Program has store {}

        /// Parses a target file given dependency files and address mappings.
        public fun parse_program(
            target: vector<u8>,
            dependencies: vector<vector<u8>>,
            address_mappings: vector<(address, vector<u8>)>
        ): Program {
            // In a real setting, this would parse source codes, but here we just dummy.
            Program {}
        }

        /// A runner function to test parsing logic.
        public fun runner() {
            let target = b"target move code";
            let dep1 = b"dependency1 move code";
            let dep2 = b"dependency2 move code";

            let deps = vector::empty<vector<u8>>();
            vector::push_back(&mut deps, dep1);
            vector::push_back(&mut deps, dep2);

            let mapping1 = (0x1, b"0x1_addr".to_vec());
            let mapping2 = (0x2, b"0x2_addr".to_vec());

            let addr_map = vector::empty<(address, vector<u8>)>();
            vector::push_back(&mut addr_map, mapping1);
            vector::push_back(&mut addr_map, mapping2);

            let _program = parse_program(target, deps, addr_map);
        }
    }
}

//# run 0x1::ProgramParser::runner


//# publish
address 0x2 {
    module LintedModule {

        #[skip(["dead_code", "unused_variables"])]
        fun function_with_skips() {
            let _unused_var = 42;
            // This function would normally trigger lints for dead_code and unused_variables,
            // but they are skipped by the #[skip(...)] attribute.
        }

        /// Runner to call the lint skipped function (no args).
        public fun runner() {
            function_with_skips();
        }
    }
}

//# run 0x2::LintedModule::runner


//# publish
address 0x3 {
    module TypeIsChecker {

        struct S1 has copy, drop, store {}
        struct S2 has copy, drop, store {}
        struct S3 has copy, drop, store {}

        public fun check_is_type(u: u8): bool {
            // Checks if u is any of u8 or u64 or bool using is expression.
            u is |u8|u64|bool|
        }

        public fun check_is_struct(s: &S1): bool {
            // Checks if reference to struct s is one of &S1 or &S2 or &S3
            s is |&S1|&S2|&S3|
        }

        /// Runner function to exercise is expressions.
        public fun runner() {
            let b = check_is_type(10u8);
            let s = S1 {};
            let bs = check_is_struct(&s);
            // no assertions needed
        }
    }
}

//# run 0x3::TypeIsChecker::runner


//# run
script {
    use 0x1::ProgramParser;
    use 0x2::LintedModule;
    use 0x3::TypeIsChecker;

    fun main() {
        // Test parsing a program inside the script.
        let target = b"main_script_target";
        let deps = vector::empty<vector<u8>>();
        let addr_map = vector::empty<(address, vector<u8>)>();

        let _prog = ProgramParser::parse_program(target, deps, addr_map);

        // Call the lint skipped function from LintedModule
        LintedModule::function_with_skips();

        // Test is expressions via TypeIsChecker
        let test_val = 5u8;
        let _ = TypeIsChecker::check_is_type(test_val);

        let s = TypeIsChecker::S1 {};
        let _ = TypeIsChecker::check_is_struct(&s);
    }
}