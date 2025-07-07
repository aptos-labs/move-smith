//# publish
address 0x1 {
    module ProgramParser {
        use std::string;
        use std::vector;

        /// Represents a parsed Move program
        struct Program has copy, drop, store {
            target: string::String,
            dependencies: vector<string::String>,
            address_map: vector<(string::String, address)>,
        }

        /// Parses a target file, dependencies and an address map to create a Program struct
        public fun parse_program(
            target: string::String,
            deps: vector<string::String>,
            addr_map: vector<(string::String, address)>
        ): Program {
            Program {
                target,
                dependencies: deps,
                address_map: addr_map
            }
        }

        /// Runner that creates a dummy program to exercise parsing
        public fun do() {
            let target = string::utf8(b"target.move");
            let deps = vector::empty<string::String>();
            vector::push_back(&mut deps, string::utf8(b"dep1.move"));
            vector::push_back(&mut deps, string::utf8(b"dep2.move"));
            let addr_map = vector::empty<(string::String, address)>();
            vector::push_back(&mut addr_map, (string::utf8(b"0x1"), @0x1));
            let _program = Self::parse_program(target, deps, addr_map);
        }
    }
}
//# run 0x1::ProgramParser::do

//# publish
address 0x2 {
    module ResourceModifier {
        use std::option::Option;

        #[skip(lint_unnecessary_cast, lint_unused_variable)]
        struct R has key {
            v: u64,
        }

        public fun create_r(v: u64): R {
            R { v }
        }

        /// The do function modifies the resource R based on the value v:
        /// If v is even, doubles it; if odd, triples it.
        public fun do(r: &mut R) {
            if (r.v % 2 == 0) {
                r.v = r.v * 2;
            } else {
                r.v = r.v * 3;
            };
        }

        public fun runner() {
            let mut r = Self::create_r(3);
            Self::do(&mut r);
            let mut r_ev = Self::create_r(4);
            Self::do(&mut r_ev);
            // r.v should now be 9, r_ev.v should be 8
        }
    }
}
//# run 0x2::ResourceModifier::runner

//# publish
address 0x3 {
    module OptionMapTest {
        use std::option::{Option, some, none};

        /// Maps an Option<u8> by applying `add_one` function if Some
        public fun map(opt: Option<u8>): Option<u8> {
            option::map(opt, add_one)
        }

        /// Adds one to the input u8
        public fun add_one(x: u8): u8 {
            x + 1
        }

        public fun test_some() {
            let o = some(41);
            let mapped = Self::map(o);
            // mapped should be some(42)
        }

        public fun test_none() {
            let o: Option<u8> = none();
            let mapped = Self::map(o);
            // mapped should be none
        }

        public fun run_all() {
            Self::test_some();
            Self::test_none();
        }
    }
}
//# run 0x3::OptionMapTest::run_all

//# publish
address 0x4 {
    module TypeAssertions {
        /// Demonstrate type assertions and variable reassignment
        public fun main() {
            let mut x: u32 = 10;
            let mut y: u64 = 100;
            x = x + 1;
            y = y + 5;
            let check_x: u32 = x;
            let check_y: u64 = y;
            // check values: check_x = 11, check_y = 105
        }
    }
}
//# run 0x4::TypeAssertions::main

//# run
script {
    use 0x2::ResourceModifier;
    use 0x3::OptionMapTest;
    use 0x4::TypeAssertions;

    fun main(signer: signer) {
        // Test ResourceModifier do with mut resource
        let mut r = ResourceModifier::create_r(5);
        ResourceModifier::do(&mut r);

        // Test OptionMapTest map function with some and none
        let some_val = OptionMapTest::map(std::option::some<u8>(10));
        let none_val = OptionMapTest::map(std::option::none<u8>());

        // Test TypeAssertions main fn
        TypeAssertions::main();
    }
}