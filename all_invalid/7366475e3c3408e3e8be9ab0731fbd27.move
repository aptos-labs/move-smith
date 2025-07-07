//# publish
address 0x1 {
    module Abilities {
        use std::string;
        use std::vector;

        struct Ability has copy, drop, store { }

        // Define the four abilities as constants
        const COPY: u8 = 0;
        const DROP: u8 = 1;
        const STORE: u8 = 2;
        const KEY: u8 = 3;

        /// Map ability number to string representation
        public fun ability_to_string(ability: u8): string::String {
            if (ability == COPY) {
                string::utf8(b"copy")
            } else if (ability == DROP) {
                string::utf8(b"drop")
            } else if (ability == STORE) {
                string::utf8(b"store")
            } else if (ability == KEY) {
                string::utf8(b"key")
            } else {
                string::utf8(b"unknown")
            }
        }

        /// Given a vector of u8 abilities, return a comma concatenated string describing abilities
        public fun abilities_to_string(abilities: vector<u8>): string::String {
            let n = vector::length(&abilities);
            if (n == 0) {
                return string::utf8(b"");
            }
            let mut result = ability_to_string(*vector::borrow(&abilities, 0));
            let mut i = 1;
            while (i < n) {
                result = string::concat(&result, string::utf8(b","));
                result = string::concat(&result, ability_to_string(*vector::borrow(&abilities, i)));
                i = i + 1;
            }
            result
        }
    }
}

//# publish
address 0x2 {
    module RModule {
        use std::signer;

        // R resource with some value v
        struct R has key {
            v: u64,
        }

        // Initialize R resource under signer
        public fun init(account: &signer) {
            move_to(account, R { v: 0 });
        }

        // do() increments v by 1 if v < 10, else decrements by 1
        public fun do_(account: &signer) {
            let r = borrow_global_mut<R>(signer::address_of(account));
            if (r.v < 10) {
                r.v = r.v + 1;
            } else {
                r.v = r.v - 1;
            }
        }

        // Getter for v
        public fun get_v(addr: address): u64 {
            borrow_global<R>(addr).v
        }

        // Runner function that calls do() multiple times to test incrementation and decrementation
        public fun runner(account: &signer) {
            let i = 0;
            while (i < 15) {
                do_(account);
                i = i + 1;
            }
        }
    }
}
//# run 0x2::RModule::runner --signers 0x2


//# publish
address 0x3 {
    module Additions {
        // add2: adds 2 to input
        public fun add2(x: u64): u64 {
            x + 2
        }

        // add3: adds 3 to input
        public fun add3(x: u64): u64 {
            x + 3
        }

        // test function uses local variable and calls add2 then add3
        public fun test(): u64 {
            let mut n = 1;
            // update n by add2
            n = add2(n);
            // call add3 with n and return
            add3(n)
        }

        // Runner function calls test and ignores return (called to trigger execution)
        public fun runner() {
            let _ = test();
        }
    }
}
//# run 0x3::Additions::runner


//# publish
address 0x4 {
    // A module to simulate program parsing with target/dependency address namespace management
    module Parser {
        use std::string;
        use std::vector;

        // Simulate address mapping for targets and dependencies
        struct Program has copy, drop, store {
            target_address: address,
            dep_address: address,
            modules_parsed: u8, // dummy count
        }

        // Parse target file and dep file with addresses, return dummy Program struct
        public fun parse_program(target_addr: address, dep_addr: address): Program {
            Program {
                target_address: target_addr,
                dep_address: dep_addr,
                modules_parsed: 2,
            }
        }

        // Runner function returns dummy string describing parsed addresses
        public fun runner(): string::String {
            let p = parse_program(0x10, 0x20);
            let s1 = string::concat(&string::utf8(b"Target: "), addr_to_string(p.target_address));
            let s2 = string::concat(&string::utf8(b", Dep: "), addr_to_string(p.dep_address));
            string::concat(&s1, &s2)
        }

        fun addr_to_string(addr: address): string::String {
            // convert address to hex-string representation (simulate)
            // Just dummy string of "0x" + u8 bytes separated by ""
            let bytes = address_to_u8_vector(addr);
            let mut res = string::utf8(b"0x");
            let len = vector::length(&bytes);
            let mut i = 0;
            while (i < len) {
                let hex_digit = hex_u8(vector::borrow(&bytes, i));
                res = string::concat(&res, &hex_digit);
                i = i + 1;
            }
            res
        }

        fun address_to_u8_vector(addr: address): vector<u8> {
            let mut res = vector::empty<u8>();
            let i = 0;
            while (i < 16) {
                vector::push_back(&mut res, (addr >> (8 * (15 - i))) as u8);
                i = i + 1;
            }
            res
        }

        fun hex_u8(b: &u8): string::String {
            // convert byte to hex string (2 hex chars)
            let hex_chars = b"0123456789ABCDEF";
            let hi = (*b >> 4) & 0xF;
            let lo = *b & 0xF;
            let mut s = vector::empty<u8>();
            vector::push_back(&mut s, *vector::borrow(&hex_chars, hi));
            vector::push_back(&mut s, *vector::borrow(&hex_chars, lo));
            string::utf8(&s)
        }
    }
}
//# run 0x4::Parser::runner


//# publish
address 0x5 {
    // Module to test module alias uniqueness within namespace.
    module AliasTest {
        use std::signer;

        // Map of aliases used: simulate registration with a vector of strings
        struct AliasRegistry has store {
            aliases: vector<string::String>,
        }

        // Initialize empty registry for caller
        public fun init_registry(account: &signer) {
            move_to(account, AliasRegistry { aliases: vector::empty<string::String>() });
        }

        // Add alias, error if duplicated
        public fun add_alias(account: &signer, alias: string::String) {
            let reg = borrow_global_mut<AliasRegistry>(signer::address_of(account));
            let aliases = &mut reg.aliases;
            // Check duplicate
            let len = vector::length(aliases);
            let mut i = 0;
            while i < len {
                if (string::equals(&*vector::borrow(aliases, i), &alias)) {
                    // abort with error on duplicate alias
                    abort 1001;
                }
                i = i + 1;
            }
            vector::push_back(aliases, alias);
        }

        // Runner adds unique aliases and then tries to add duplicate alias (catch abort)
        public fun runner(account: &signer) {
            init_registry(account);
            add_alias(account, string::utf8(b"foo"));
            add_alias(account, string::utf8(b"bar"));
            // Attempt duplicate, should abort - this is just to exercise the runtime error
            // NOTE: The test framework ignores assertions/errors
            // So here we call it anyway to test error handling, no try/catch in Move
            add_alias(account, string::utf8(b"foo"));
        }
    }
}
//# run 0x5::AliasTest::runner --signers 0x5


//# run
script {
    use std::signer;
    use 0x2::RModule;
    use 0x3::Additions;
    use 0x5::AliasTest;

    fun main(account: &signer) {
        // Initialize R resource and run runner to modify v
        RModule::init(account);
        RModule::runner(account);

        // Call Additions test function
        let _result: u64 = Additions::test();

        // Run alias test with account, will abort on duplicate alias add
        // We call runner() which internally triggers abort (ignored in test)
        AliasTest::runner(account);
    }
}