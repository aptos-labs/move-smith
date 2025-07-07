// This transactional test covers:
// 1. Reassigning references between variables and scopes updates references correctly.
// 2. Scripts are annotated with source locations and function info with default specs.
// 3. Passing mutable references to functions to modify variables, with assertions.

//# publish
module 0xCAFE::RefReassign {
    use std::debug;

    /// Reassign references to different variables and scopes.
    /// Dereference and assert expected values.
    public fun test_reassign() {
        let mut x = 10u64;
        let mut y = 20u64;

        // Create mutable refs
        let r1 = &mut x;
        let r2 = &mut y;

        // Initially dereference
        debug::print(&(*r1)); // expect 10
        debug::print(&(*r2)); // expect 20

        // Reassign r1 to refer to y instead of x 
        // Scope inner to test rebindings
        {
            let r1 = &mut y;
            debug::print(&(*r1)); // expect 20
            // Modify y through r1
            *r1 = 25;
            debug::print(&(*r1)); // expect 25
        }
        // Outside inner scope, original r1 refers to x
        debug::print(&(*r1)); // expect 10 unchanged
        debug::print(&(*r2)); // expect 25 as y was modified through inner r1

        // Modify x through r1
        *r1 = 15;
        debug::print(&x); // expect 15
    }

    /// Function called from script, takes mutable reference and mutates value.
    public fun modify_value(val: &mut u64) {
        *val = *val + 100;
    }

    /// Runner to test modification via passing mutable references
    public fun test_modify() {
        let mut v = 5u64;
        modify_value(&mut v);
        debug::print(&v); // expect 105
    }
}
//# run 0xCAFE::RefReassign::test_reassign
//# run 0xCAFE::RefReassign::test_modify --signers 0xCAFE

//# run
script {
    use std::debug;
    use 0xCAFE::RefReassign;

    fun main() {
        debug::print(&0u64); // source loc annotation test
        let mut a = 30u64;

        // Pass mutable ref to module function
        RefReassign::modify_value(&mut a);
        debug::print(&a); // expect 130 (30 + 100)

        // Inner scope to reassign references
        {
            let r = &mut a;
            *r = 50;
            debug::print(r); // expect 50
        }
        debug::print(&a); // expect 50

        // Test local mutable reference reassignments in script
        let mut b = 5u64;
        let mut c = 6u64;
        let mut r1 = &mut b;
        let mut r2 = &mut c;

        debug::print(r1); // expect 5
        debug::print(r2); // expect 6

        // Reassign r1 inside inner scope to r2
        {
            r1 = r2;
            debug::print(r1); // expect 6
            // Modify via r1 (which aliases r2)
            *r1 = 10;
            debug::print(r2); // expect 10
        }
        // Outside inner scope, r1 still points to c now
        debug::print(r1); // expect 10
        debug::print(&b); // expect 5 unchanged
        debug::print(&c); // expect 10
    }
}

// Featurres:
// d98bf52da3f1eaa504c1d722aeac511f: Test that reassigning references to different variables and scopes correctly updates and maintains reference validity, and that dereferencing yields expected values after such reassignments.
// a77c8f3e6cf2b64e2b4a2eb5303e8e69: Annotate scripts with their source locations and include function information with default specifications.
// 00da5ab232a23d40c449291ca6d305fc: Test that mutable references can be passed to functions and correctly modify variables, with assertions verifying the expected final values.
