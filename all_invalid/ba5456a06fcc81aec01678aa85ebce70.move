
//# publish
module 0xCAFE::GenericStore {
    use std::signer;
    use std::vector;

    struct Container<T> has store, key {
        id: u64,
        data: T,
    }

    public fun create_container<T: copy + store>(owner: &signer, id: u64, data: T) {
        let container = Container<T> { id, data };
        move_to<Container<T>>(owner, container);
    }

    public fun exists_container<T: copy + store>(addr: address): bool {
        exists<Container<T>>(addr)
    }

    public fun get_container_data<T: copy + store>(addr: address): T acquires Container {
        let container_ref: &Container<T> = borrow_global<Container<T>>(addr);
        container_ref.data
    }

    public fun delete_container<T: copy + store>(addr: address) acquires Container {
        move_from<Container<T>>(addr);
    }

    public fun call_pattern_match<T: copy + store>(x: Container<T>): u64 {
        // pattern match Container, return id if id > 0, else return 0
        match x {
            Container { id, data: _ } if (id > 0) => {
                return id;
            },
            Container { id: _, data: _ } => {
                return 0;
            }
        }
    }
}


//# publish
module 0xCAFE::MatchAndReturn {
    struct E has copy, drop {
        val: u8,
    }

    enum ExampleEnum has copy, drop {
        Alpha,
        Beta(u8),
        Gamma { flag: bool },
    }

    public fun match_enum(e: ExampleEnum): u8 {
        let res = match e {
            ExampleEnum::Alpha => 1,
            ExampleEnum::Beta(x) => {
                return x + 10;
            },
            ExampleEnum::Gamma { flag } => {
                if (flag) {
                    return 99;
                } else {
                    0
                }
            }
        };
        res
    }
}


//# publish
module 0xCAFE::CrossModuleGeneric {
    use 0xCAFE::GenericStore;
    use 0xCAFE::MatchAndReturn;

    public fun create_and_invoke(owner: &signer) {
        // create Container<MatchAndReturn::E> with specific data
        let e = MatchAndReturn::E { val: 42u8 };
        GenericStore::create_container<MatchAndReturn::E>(owner, 123u64, e);

        // check existence
        let exists = GenericStore::exists_container<MatchAndReturn::E>(signer::address_of(owner));
        assert!(exists, 1000);

        // get data
        let data = GenericStore::get_container_data<MatchAndReturn::E>(signer::address_of(owner));

        // create ExampleEnum::Beta variant using the val in data
        let ex_enum = MatchAndReturn::ExampleEnum::Beta(data.val);

        // run pattern match and return test
        let ret_val = MatchAndReturn::match_enum(ex_enum);

        // delete the container now
        GenericStore::delete_container<MatchAndReturn::E>(signer::address_of(owner));

        // ret_val used to confirm execution path - no assertion or store
        let _dummy = ret_val;
    }
}


//# run 0xCAFE::GenericStore::create_container --signers 0xBEEFBEEF --args 42u64 7u8

//# run 0xCAFE::GenericStore::exists_container --args 0xBEEFBEEF

//# run 0xCAFE::GenericStore::get_container_data --args 0xBEEFBEEF

//# run 0xCAFE::GenericStore::call_pattern_match --args vector[0u8]: vector<u8>  // using vector<u8> as a complex type parameter


//# run 0xCAFE::MatchAndReturn::match_enum --args 0xCAFE::MatchAndReturn::ExampleEnum::Alpha

//# run 0xCAFE::MatchAndReturn::match_enum --args 0xCAFE::MatchAndReturn::ExampleEnum::Beta(88u8)

//# run 0xCAFE::MatchAndReturn::match_enum --args 0xCAFE::MatchAndReturn::ExampleEnum::Gamma { flag: true }


//# run 0xCAFE::CrossModuleGeneric::create_and_invoke --signers 0xF00DBABE


// Featurres:
// 0189d3c651e54103130a64707b72129f: Test that creating and checking existence of generic structs in multiple modules, and passing them through functions, works correctly with storage, key management, and type parameters.
// 9ac67b0ca4a3134aeec58f90c6917a70: Use pattern matching with `Match` expressions and their arms.
// f764811ed35e98cd9106dc1292628e34: Return values from functions or blocks with the `return` expression.
