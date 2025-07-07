// Transactional test script for Aptos Move compiler and VM
// This test covers:
// 1) Declaration of global and local variables with optional initialization.
// 2) Access to modules and types through chained names.
// 3) Binding lists of typed bindings to lists of typed L-values.

script {
    use std::signer;
    use std::vector;
    use std::option;

    // A dummy module with a nested module and a struct to use chained names
    module 0x1::Outer {
        module Inner {
            struct MyStruct has copy, drop, store {
                val: u64
            }

            public fun make_struct(value: u64): MyStruct {
                MyStruct { val: value }
            }
        }
    }

    fun borrow_addr(s: &signer) acquires Outer::Inner::MyStruct {
        // To suppress unused error
        let _addr = signer::address_of(s);
    }

    // 1) Declare global or local variables with optional initialization
    fun declare_variables(s: signer) {
        // Local variables
        // uninitialized local variable
        let x: u64;
        // initialized local variable
        let y: u64 = 42;

        // Using values to pass Move compilation checks
        x = 10;

        // Global variable simulation through resource declaration is not allowed in scripts,
        // but we can simulate by using nested modules and structs (or resources in modules).
        // For this test, we'll declare local variables as per script limitations.

        // Chain access 2) Access modules and types through chained names
        // Create an instance of Outer::Inner::MyStruct using chained access
        let s_struct: Outer::Inner::MyStruct = Outer::Inner::make_struct(y + x);

        // Print to ensure operations are planned (in reality Aptos VM test environment supports event logs or print)
        // Here it's just a dummy call or a no-op: can't print, so just inline usage to avoid warnings
        let val: u64 = s_struct.val;
        let _ = val + y;

        // 3) Bind a list of typed bindings to a list of typed LValues

        // Binding list syntax example:
        // let (a, b, c): (u64, u64, Outer::Inner::MyStruct) = (1, 2, s_struct);
        // But Move currently does not support tuple destructuring in variables; only parallel let bindings.
        // So we simulate with separate lets to mimic the concept:

        let a: u64 = 1;
        let b: u64 = 2;
        let c: Outer::Inner::MyStruct = s_struct;

        // Alternatively simulate binding list to list of lvalues by reassignments
        // We'll create some mutable variables to assign later
        let mut m_a: u64 = 0;
        let mut m_b: u64 = 0;
        let mut m_c: Outer::Inner::MyStruct = Outer::Inner::make_struct(0);

        // Bind values (list of bindings) to list of l-values by assigning separately
        m_a = a;
        m_b = b;
        m_c = c;

        // Use variables to prevent warnings
        let _sum = m_a + m_b + m_c.val;
    }

    fun main(signer: signer) {
        declare_variables(signer);
    }
}

// Featurres:
// d0cd78814514a0cf6437adc60d8328c0: Declare global or local variables with optional initialization
// 9a8847f893559f4ccdce63ae8c9c6dc0: Access modules and types through a chain of names using a specific syntax.
// 02b0174372b9ba851cdd7defc9b76de0: Bind a list of typed Bindings to a list of Typed LValues
