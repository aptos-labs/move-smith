
//# publish
deprecated module 0xCAFE::DepModule {
    use std::vector;

    // Pure deprecation marker, no runtime impact
    public fun deprecated_function(x: u8): u8 {
        x
    }
}


//# publish
deprecated module 0xCAFE::RefTestModule {
    use std::vector;

    // Function to test dereferencing
    public fun deref_test() {
        let x: u8 = 42;
        let r: &u8 = &x;
        // dereference via unary *
        let y = *r;
        // Use dereferenced value
        let _z = y + 1;
        // Use 'as' keyword as identifier
        let break = 10;
        let as_value = break;
        // Use 'if' as identifier
        let if = as_value;
        // Use 'else' as identifier
        let else = 20;
        // Use 'true' as identifier
        let true = 1;
        // Use 'false' as identifier
        let false = 0;

        // Use 'let' keyword as identifier
        let let = 99;

        // Use 'return' as identifier
        let return = *r;

        // Use 'module' keyword as identifier
        let module = 7;

        // Use 'fun' as identifier
        let fun = 8;
    }
}


//# run 0xCAFE::DepModule::deprecated_function --args 5u8

//# run 0xCAFE::RefTestModule::deref_test


// Featurres:
// 390b5dabfa1eded9d6a07449255a295e: Mark entire modules as deprecated with an annotation.
// ecccc2e2a01c37f38c182d3f93af3d85: Dereference references via the unary `*` operator.
// 7dcd99288efac8956318da471526087a: Use reserved keywords such as 'abort', 'acquires', 'as', 'break', 'const', 'continue', 'copy', 'else', 'false', 'fun', 'friend', 'if', 'invariant', 'let', 'loop', 'inline', 'module', 'move', 'native', 'public', 'return', 'script', 'spec', 'struct', 'true', 'use', 'while' as identifiers in Move code.
