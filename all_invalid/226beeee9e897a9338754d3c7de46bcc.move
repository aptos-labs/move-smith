//# publish
address 0x1 {
    module AddrMapping {
        // This module simulates defining Move programs by having associated address mappings.
        use std::string;

        struct Program has copy, drop, store {
            name: string::String,
            address: address,
            dependencies: vector<address>,
        }

        public fun new_program(name: string::String, address: address, dependencies: vector<address>): Program {
            Program {
                name,
                address,
                dependencies,
            }
        }

        public fun get_address(prog: &Program): address {
            prog.address
        }

        public fun dependency_count(prog: &Program): u64 {
            vector::length(&prog.dependencies)
        }

        // runner function with no args
        public fun run_example() {
            let deps = vector::empty<address>();
            let pd = new_program(string::utf8(b"TestProgram"), @0x1, deps);
            let _ = get_address(&pd);
            let _ = dependency_count(&pd);
        }
    }
}
//# run 0x1::AddrMapping::run_example

//# publish
address 0x2 {
    module ResourceTest {
        use std::signer;

        #[skip(lint1, lint2)]
        struct R has key {
            v: u64,
        }

        // initialize R resource at signer's account with a value
        public fun init(account: &signer, val: u64) {
            move_to(account, R { v: val });
        }

        // do() function modifies or interacts with R
        #[skip(lint_bad_call)]
        public fun do(account: &signer) {
            let r = borrow_global_mut<R>(signer::address_of(account));
            if (r.v > 100) {
                r.v = r.v - 1;
            } else {
                r.v = r.v + 1;
            };
        }

        // get current value of R.v
        public fun get_v(addr: address): u64 acquires R {
            borrow_global<R>(addr).v
        }

        // runner function with signature requires signer <address>
        public fun runner(account: &signer) {
            init(account, 105);
            // after init, v = 105
            do(account); // should decrement v to 104
            do(account); // should decrement v to 103
            do(account); // 103 > 100, decrement to 102
            let _ = get_v(signer::address_of(account));
        }
    }
}
//# run 0x2::ResourceTest::runner --signers 0x2

//# run
script {
    use std::signer;
    use std::string;
    use 0x2::ResourceTest;

    fun main(account: signer) {
        // Initialize resource R with value 99 (less than 100, so do will increment)
        ResourceTest::init(&account, 99);
        ResourceTest::do(&account); // v should become 100
        ResourceTest::do(&account); // v should become 101 (because now 100<=100 condition is false)
        // access final value (just to exercise VM, no assertion)
        let _ = ResourceTest::get_v(signer::address_of(&account));
    }
}