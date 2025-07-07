
//# publish
module 0xCAFE::ResourceAcquirer {
    use std::signer;

    struct R has key, store {
        val: u64,
    }

    public fun create_resource(account: signer, val: u64) {
        let r = R { val };
        move_to<R>(&account, r);
    }

    public fun read_resource(addr: address): u64 acquires R {
        let r_ref = borrow_global<R>(addr);
        r_ref.val
    }

    public fun update_resource(addr: address, new_val: u64) acquires R {
        let r_mut_ref = borrow_global_mut<R>(addr);
        r_mut_ref.val = new_val;
    }

    public fun remove_resource(addr: address) acquires R {
        let r = move_from<R>(addr);
        let R { val: _v } = r;
    }

    // Runner function to create, read, update and remove in sequence
    public fun runner(account: signer) {
        create_resource(account, 100);
        let addr = signer::address_of(&account);
        let v = read_resource(addr);
        update_resource(addr, v + 50);
        remove_resource(addr);
    }
}


//# publish
module 0xCAFE::GenericFunctions {
    // Generic struct with type parameter
    struct Container<T> has store, copy, drop {
        item: T,
    }

    // Generic inline function returning a tuple of Container<T> and Container<U>
    public inline fun combine<T, U>(x: T, y: U): (Container<T>, Container<U>) {
        (Container<T> { item: x }, Container<U> { item: y })
    }

    // Public function that calls inline generic function through multiple module boundaries
    // by calling methods in 0xCAFE::HelperModule
    public fun compose_across_modules<T, U>(x: T, y: U): (T, U) {
        let (cx, cy) = 0xCAFE::HelperModule::helper_function<T, U>(x, y);
        (cx.item, cy.item)
    }
}


//# publish
module 0xCAFE::HelperModule {
    use 0xCAFE::GenericFunctions;

    // Simple wrapper function calling GenericFunctions::combine inline generic function
    public fun helper_function<T, U>(x: T, y: U): (GenericFunctions::Container<T>, GenericFunctions::Container<U>) {
        GenericFunctions::combine<T, U>(x, y)
    }
}


//# run 0xCAFE::ResourceAcquirer::runner --signers 0xDEAD


//# run 0xCAFE::ResourceAcquirer::create_resource --signers 0xBEEF --args 999u64


//# run 0xCAFE::ResourceAcquirer::read_resource --args 0xBEEF


//# run 0xCAFE::ResourceAcquirer::update_resource --args 0xBEEF 1234u64


//# run 0xCAFE::ResourceAcquirer::read_resource --args 0xBEEF


//# run 0xCAFE::ResourceAcquirer::remove_resource --args 0xBEEF


//# run 0xCAFE::GenericFunctions::compose_across_modules --args 123u64 456u64


//# run 0xCAFE::GenericFunctions::compose_across_modules --args 777u8 88u8


// Featurres:
// 9cdb99c69ff3a8dbf5be66a05b1bb278: Declare resources acquired by a function using the 'acquires' annotation.
// 3f5c63826c1b1169c8804295ff1fe53f: Test that inlined public functions can be called through multiple module boundaries and properly compose their inlining and execution results.
// b89769747726b0ff0a79b7b55c58d5d4: Use type parameters in generic functions and structs.
