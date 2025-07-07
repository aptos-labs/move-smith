module 0x1::TestTransaction {
    use std::signer;
    use std::vector;

    // A simple struct with nested structs for nested field access
    struct Inner has copy, drop, store {
        value: u64,
    }

    struct Middle has copy, drop, store {
        inner: Inner,
    }

    struct Outer has copy, drop, store {
        middle: Middle,
    }

    struct Holder has key {
        outer: Outer,
    }

    /// Initialize a Holder resource under the signer with a nested structure.
    public fun init_holder(account: &signer) acquires Holder {
        let outer = Outer {
            middle: Middle {
                inner: Inner { value: 42 }
            }
        };
        move_to(account, Holder { outer });
    }

    /// This function uses nested field accesses using multiple dot operators 
    /// to retrieve and update deeply nested values.
    public fun nested_field_access(holder: &mut Holder, new_value: u64) {
        // Access value nested inside Outer.Middle.Inner (3 dot operators)
        let old_value = holder.outer.middle.inner.value;
        // Update nested value
        holder.outer.middle.inner.value = new_value;
    }

    /// A function that shadows an imported function name `foo`.
    /// We import 0x1::signer::address_to_bytes as foo for example,
    /// but here we shadow it with a parameter with the same name,
    /// and also accept a lambda parameter named `foo` to test shadowing.
    use std::hash::sha2_256;

    /// A dummy function named `foo` in the module to demonstrate shadowing.
    public fun foo(x: u64): u64 {
        x + 1
    }

    /// This function demonstrates that the parameter `foo` shadows the module function `foo`.
    public fun test_shadowing(foo: u64, bar: &signer, foo_lambda: &mut (fun(u64): u64)): u64 acquires Holder {
        // Call the parameter foo (u64) directly, not the module function foo
        let val = foo;

        // Call the lambda parameter named foo_lambda, which takes a u64 and returns u64
        let lambda_result = (*foo_lambda)(val);

        // Call the module function explicitly using self
        let module_foo_result = Self::foo(val);

        // For demonstration, sum all three results
        lambda_result + val + module_foo_result
    }

    /// A spec module to declare invariants with 'update' on Holder resource.
    spec 0x1::TestTransaction {
        resource struct Holder {
            outer: Outer,
        }

        /// Invariant on Holder.outer.middle.inner.value after updates:
        /// value must always be less than or equal to 100.
        update invariant holder_valid_value!(h: &Holder) {
            h.outer.middle.inner.value <= 100
        }
    }

    #[test_only]
    public fun test_transaction(account: &signer) acquires Holder {
        // Initialize the Holder resource under the test account
        Self::init_holder(account);

        // Borrow the resource mutably
        let holder_ref = borrow_global_mut<Holder>(signer::address_of(account));

        // Check current nested value: should be 42
        let old_value = holder_ref.outer.middle.inner.value;
        assert!(old_value == 42, 1);

        // Update nested value to a valid number under 100
        Self::nested_field_access(holder_ref, 99);
        assert!(holder_ref.outer.middle.inner.value == 99, 2);

        // Try to violate the invariant by setting value > 100 (this won't cause abort here 
        // because spec and invariants are verified statically, but show the intention)
        holder_ref.outer.middle.inner.value = 101;

        // Prepare a lambda that will shadow module foo function: just adds 10
        let mut lambda = |x: u64| -> u64 { x + 10 };

        // Call test_shadowing with foo = 5, bar = account signer ref, and the lambda
        let result = Self::test_shadowing(5, account, &mut lambda);
        // Calc: lambda(5)=15, val=5, module foo(5)=6, sum=26
        assert!(result == 26, 3);
    }
}

// Featurres:
// 144d392878d634a9938c334f29348413: Nest field access expressions using multiple dot operators
// d2481eaa11a9e5dd99ed461357bcfa99: Declare 'update' invariants in spec blocks to specify conditions that must hold after updates.
// 0c6264ced8632d23808d99abd623d46c: Test that function parameters can correctly shadow imported module functions with the same name, including in the context of function parameters passed as lambdas.
