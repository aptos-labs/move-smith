//# publish
module 0xCAFE::SpecDemo {
    use std::option::{Self, Option};
    use std::vector;

    // A simple struct with multiple fields
    struct Foo has copy, drop, store, key {
        x: u64,
        y: u8,
    }

    // Resource struct for testing move_to/borrow_global/move_from
    struct Bar has key, store {
        z: u64,
    }

    // Function with inline spec (outside a spec context)
    spec fun adder_spec(x: u64, y: u64): u64 { x + y }

    public fun adder(x: u64, y: u64): u64 {
        x + y
    }

    // Function to test named schemas and succeeds_if
    public fun make_foo(x: u64): Foo {
        Foo { x, y: 100 }
    }

    // Function to test move_to and resource
    public fun store_bar(account: &signer, z: u64) {
        move_to(account, Bar { z })
    }

    public fun update_bar(account: &signer, dz: u64) {
        let obj = borrow_global_mut<Bar>(signer::address_of(account));
        obj.z = obj.z + dz;
    }

    public fun delete_bar(account: &signer): u64 {
        let b = move_from<Bar>(signer::address_of(account));
        b.z
    }

    // A test runner to execute some example code path
    public fun runner(account: &signer) {
        let foo = make_foo(5);
        let _sum = adder(2, 8);
        store_bar(account, 77);
        update_bar(account, 23);
    }

    //
    // SPECIFICATIONS
    //
    spec module {
        //
        // Named schemas!
        //
        schema InvariantFoo {
            // In all schemas, you can use 'self'
            self.x > 0;
            self.y == 100;
        }
    }

    // Specifies detailed conditions using succeeds_if.
    spec make_foo {
        // Attach schema
        ensures result satisfies InvariantFoo;

        // Explicit succeeds_if, e.g. test property holds at last
        succeeds_if(result.x == x);
        succeeds_if(result.y == 100);
    }

    // Show use of succeeds_if with a resource
    spec store_bar {
        // On successful call, Bar must be stored at caller's address with given z
        succeeds_if([Bar] == true);
        succeeds_if(global<Bar>(Signer::address_of(account)).z == z);
    }

    // Inline specification expression, not in context
    spec fun sum_spec(a: u8, b: u8): u8 { a + b }

    // Show usage for function that returns u64, ties to named schemas as well
    spec adder {
        succeeds_if(result == adder_spec(x, y));
    }

    // Inline spec expression, at top-level
    spec fun ten(): u8 { 10 }
}

//# run 0xCAFE::SpecDemo::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::SpecDemo;

    fun main(account: signer) {
        let foo = SpecDemo::make_foo(11);
        let sum = SpecDemo::adder(7, 8);
        SpecDemo::store_bar(&account, sum);
        SpecDemo::update_bar(&account, 3);
        let z = SpecDemo::delete_bar(&account);
        // consume values
        let Foo { x, y } = foo;
        let _ = (x, y, z);
    }
}

// Featurres:
// 3ed814913fe5b769f9a0f8451b248abd: Declare named schemas inside spec blocks.
// d2c40146156c397fcaabfbbfe969e2af: Use 'succeeds_if' specifications to define detailed success conditions.
// cd052ff7525df75a003fb0f4dba9a498: Write in-line specification expressions via the `spec` keyword, but not inside specification contexts (outer `spec` blocks only).
