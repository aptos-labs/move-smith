
//# publish
address 0xCAFE {
    module RefAddressSyntax {
        // Just referencing the module; no need for a main function for now.
        // This module is just for testing reference syntax.
        public fun dummy() {}
    }
}


//# publish
address 0xBABE {
    module TestAbortAndExpressionList {
        // Function to test abort with an expression
        public fun abort_with_value() {
            abort 42;
        }

        // Function to test multiple expressions in a single context
        public fun multiple_expressions(): (u64, u64, u64) {
            let a = 10;
            let b = 20;
            let c = 30;
            // Return the sum of all three as a tuple
            (a + b, b + c, a + c)
        }
    }
}


//# run 0xCAFE::RefAddressSyntax::dummy


//# run 0xBABE::TestAbortAndExpressionList::abort_with_value --signers 0xBABE


//# run 0xBABE::TestAbortAndExpressionList::multiple_expressions --signers 0xBABE