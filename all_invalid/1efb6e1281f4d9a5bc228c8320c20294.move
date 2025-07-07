// tests/transactional/multi_script_closure_acquire.move

// This file tests multiple transactional scripts with the same `main` function name,
// closures capturing and mutating variables from outer scopes,
// and proper resource acquisition declarations.

address 0x1 {
    module DemoResource {
        struct R has key { val: u64 }

        public fun create_r(val: u64): R {
            R { val }
        }
    }
}

address 0x2 {
    module ResourceHolder {
        use 0x1::DemoResource;

        struct Holder has key {
            resource: DemoResource::R,
        }

        // Demonstrate resource acquisition via explicit 'acquires' declaration.
        public fun init_holder(account: &signer, val: u64): Holder acquires Holder {
            let r = DemoResource::create_r(val);
            Holder { resource: r }
        }

        // Closure passed as inline argument mutates a variable from outer scope.
        public fun mutate_with_closure(mut x: u64, f: &mut (u64) -> u64): u64 {
            // apply closure that captures & mutates x passed
            let new_val = f(x);
            new_val
        }
    }
}


// Script 1: test closure and resource acquire clause.
// Main function name: main
script 0x2 {
    use 0x1::DemoResource;
    use 0x2::ResourceHolder;

    fun main(acct: &signer) {
        // 1. Closure capturing and mutating outer variable via inline param
        let mut captured = 10u64;
        // Define inline closure that mutates captured by adding input to captured
        let mut closure = move |param: u64| {
            captured = captured + param;
            captured
        };

        // Call function passing closure
        let result = ResourceHolder::mutate_with_closure(captured, &mut closure);
        // Assert result and mutated captured variable
        assert!(result == 20, 1001);
        assert!(captured == 20, 1002);

        // 2. Acquire resource by explicitly creating it
        let holder = ResourceHolder::init_holder(acct, 42);
        // We can read the resource.value
        let val = holder.resource.val;
        assert!(val == 42, 1003);
    }
}

// Script 2: another script with THE SAME main function name `main`
// Testing compiler disambiguation of scripts with identical `main` names
script 0x2 {
    fun main(acct: &signer) {
        // This main only asserts a constant condition
        assert!(true, 2001);
    }
}

// Script 3: Simple script to test implicit acquisition inference by compiler
// No explicit 'acquires' clause, but mutates a resource in storage.
// This should pass only if the compiler infers acquisition properly.
address 0x3 {
    module ImplicitAcquireModule {
        struct Counter has key {
            count: u64
        }

        public fun get_count(counter: &Counter): u64 {
            counter.count
        }

        public fun increment(counter: &mut Counter) {
            counter.count = counter.count + 1;
        }
    }
}

script 0x3 {
    use 0x3::ImplicitAcquireModule;

    fun main(acct: &signer) {
        // Publish a resource under acct to test implicit acquire
        move_to(acct, ImplicitAcquireModule::Counter { count: 0 });

        // Borrow mutable reference to resource and increment
        let counter = borrow_global_mut<ImplicitAcquireModule::Counter>(Signer::address_of(acct));
        ImplicitAcquireModule::increment(counter);

        // Check the value incremented
        let c = ImplicitAcquireModule::get_count(counter);
        assert!(c == 1, 3001);
    }
}

// Featurres:
// b7338995bef53aa6347c3d6dbb5eb91c: Test that closures can capture and mutate variables from their enclosing scope when passed as inline function parameters.
// bec8f12b899563b482c5a8f54ee72fde: Write scripts with potentially the same main function name, which are automatically disambiguated by the compiler.
// 73d4b20956f885ed998d023491815143: Ensure that all target modules and functions correctly declare the resources they acquire, or have those acquisitions inferred by the compiler.
