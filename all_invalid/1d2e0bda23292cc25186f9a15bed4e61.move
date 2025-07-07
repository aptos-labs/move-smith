//# publish
module 0xCAFE::StoreAndRetrieve {
    use std::signer;
    use std::vector;

    struct MyResource<T> has key {
        value: T,
    }

    public fun store_resource<T>(account: &signer, val: T) {
        move_to(account, MyResource<T> { value: val });
    }

    public fun borrow_resource<T>(account: &signer): &MyResource<T> acquires MyResource {
        borrow_global<MyResource<T>>(signer::address_of(account))
    }

    public fun runner(account: &signer) {
        store_resource<u64>(account, 42u64);
        let res = borrow_resource<u64>(account);
        let _val = res.value; // read to exercise VM
    }
}

//# run 0xCAFE::StoreAndRetrieve::runner --signers 0xCAFE

//# publish
module 0xCAFE::GenericUtils {
    public fun identity<T>(val: T): T {
        val
    }

    public fun runner() {
        let a = identity<u64>(123u64);
        let b = identity<bool>(true);
        let _ = a;
        let _ = b;
    }
}

//# run 0xCAFE::GenericUtils::runner

//# run 0xCAFE::StoreAndRetrieve::store_resource --signers 0xCAFE --args 100u64

//# run 0xCAFE::StoreAndRetrieve::borrow_resource --signers 0xCAFE

//# run
script {
    use std::signer;
    use std::vector;
    use 0xCAFE::StoreAndRetrieve;
    use 0xCAFE::GenericUtils;

    fun main(account: signer) {
        StoreAndRetrieve::store_resource<u64>(&account, 256u64);
        let res = StoreAndRetrieve::borrow_resource<u64>(&account);
        let val = res.value;

        let id_val = GenericUtils::identity<u64>(val);
        let _ = id_val;
    }
}

// Featurres:
// 9a600fd3c1f5c5ff9446caf33e8dcd47: Save compiled Move scripts to disk as binary files.
// bc2a8ea14950cfdfe2f7b048802f62e7: Test storing and retrieving a persistent custom resource for a specific signer account.
// d6bfc12445a3e71a2f3add7f4a83133f: Use type parameters to define generic types and functions that can operate on various data types.
