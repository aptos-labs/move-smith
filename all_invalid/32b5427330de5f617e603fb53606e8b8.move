
//# publish
address 0xCAFE {
    module RefAddressSyntax {
        // Declare a named address for testing reference syntax
        // Note: In Move, this is just a module declaration for testing purposes.
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
        public fun multiple_expressions() {
            let a = 10;
            let b = 20;
            let c = 30;
            // Return the sum of all three as a tuple
            (a + b, b + c, a + c);
        }
    }
}


//# run 0xCAFE::RefAddressSyntax::main
public fun main() {
    // Reference the module in the named address syntax
    // This line is just to ensure that the reference syntax works
    // No explicit call needed here, just testing referencing
}


//# run 0xBABE::TestAbortAndExpressionList::abort_with_value --signers 0xBABE

//# run 0xBABE::TestAbortAndExpressionList::multiple_expressions

// Featurres:
// ed76520c813b9347b95ad8df42fbf757: Reference named address syntax (`address_name::module_name`) to access a module in your Move code if the named address is declared.
// 1613ea156953d25a38e2f11b46643db2: Use 'abort' statements with expressions to terminate execution with a value.
// 2235658ff2cf510854ab0cd8af9f181c: List multiple expressions in a single expression list context.
