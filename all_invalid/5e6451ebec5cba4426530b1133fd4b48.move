//# publish
module 0x1::AddressValidator {
    /// Validates that address names are either anonymous (empty string) or match a regex of allowed chars (alphanumeric and underscores)
    /// For simplicity, we'll just check ascii range and underscores.
    public fun is_valid_address_name(name: &vector<u8>): bool {
        let len = Vector::length(name);
        if (len == 0) {
            return true; // anonymous name allowed
        };
        let mut i = 0;
        while (i < len) {
            let c = *Vector::borrow(name, i);
            // Allow ascii letters, digits and underscore
            let is_alpha = (c >= 65u8 && c <= 90u8) || (c >= 97u8 && c <= 122u8);
            let is_digit = c >= 48u8 && c <= 57u8;
            let is_underscore = c == 95u8;
            if (!(is_alpha || is_digit || is_underscore)) {
                return false;
            };
            i = i + 1;
        };
        true
    }

    /// Runner function to test multiple names
    public fun runner() {
        let anon = b"";
        assert!(Self::is_valid_address_name(&anon), 1);
        let valid_name = b"Valid_Name123";
        assert!(Self::is_valid_address_name(&valid_name), 2);
        let invalid_name = b"Invalid-Name!";
        assert!(!Self::is_valid_address_name(&invalid_name), 3);
    }
}
//# run 0x1::AddressValidator::runner

//# publish
module 0x1::LintSkipper {
    /// Example function demonstrating the #[skip(...)] attribute usage to skip lints.
    /// We simulate skipping two dummy lint checks: UnusedVar and DeadCode.
    #[skip(UnusedVar, DeadCode)]
    public fun skipped_lints_example() {
        let _unused_var: u64 = 7;
        if (false) {
            // dead code
            let _dead = 0;
        };
    }

    public fun runner() {
        Self::skipped_lints_example();
    }
}
//# run 0x1::LintSkipper::runner

//# publish
module 0x1::ProgramParser {
    use std::vector;
    use std::string;

    /// Struct representing a parsed Move program with address mappings
    struct ParsedProgram has copy, drop, store {
        targets: vector<vector<u8>>,
        dependencies: vector<vector<u8>>,
        address_map: vector<(vector<u8>, vector<u8>)>, // (name, address)
    }

    /// Creates a new ParsedProgram
    public fun new(targets: vector<vector<u8>>, dependencies: vector<vector<u8>>, address_map: vector<(vector<u8>, vector<u8>)>): ParsedProgram {
        ParsedProgram { targets, dependencies, address_map }
    }

    /// A dummy parse function that exercises vector and tuple handling.
    public fun parse_target(pp: &ParsedProgram, idx: u64): vector<u8> acquires ParsedProgram {
        let t = Vector::borrow(&pp.targets, idx);
        t.clone()
    }

    /// Runner function demonstrating construction and parsing.
    public fun runner() {
        let targets = vector::empty<vector<u8>>();
        vector::push_back(&mut targets, b"module1.move");
        vector::push_back(&mut targets, b"script1.move");

        let dependencies = vector::empty<vector<u8>>();
        vector::push_back(&mut dependencies, b"std.move");

        let mut address_map = vector::empty<(vector<u8>, vector<u8>)>();
        vector::push_back(&mut address_map, (b"devnet", b"0x1"));
        vector::push_back(&mut address_map, (b"", b"0x2")); // anonymous address name

        let program = Self::new(targets, dependencies, address_map);
        let _first_target = Self::parse_target(&program, 0);

        let (name, addr) = *Vector::borrow(&program.address_map, 0);
        assert!(Vector::length(&name) > 0, 100);
        assert!(Vector::length(&addr) > 0, 101);
    }
}
//# run 0x1::ProgramParser::runner

//# run
script {
    use 0x1::AddressValidator;
    use 0x1::LintSkipper;
    use 0x1::ProgramParser;

    fun main() {
        // Test AddressValidator directly
        let anon = b"";
        assert!(AddressValidator::is_valid_address_name(&anon), 1);
        let valid = b"Tester_123";
        assert!(AddressValidator::is_valid_address_name(&valid), 2);
        let invalid = b"name-with-dash";
        assert!(!AddressValidator::is_valid_address_name(&invalid), 3);

        // Run LintSkipper example
        LintSkipper::skipped_lints_example();

        // Run ProgramParser example
        ProgramParser::runner();
    }
}