// # publish
address 0xCAFE {
    module ComplexTest {
        use std::vector;
        use std::signer;

        const CONST_VAL: u64 = 42;

        struct InnerStruct has copy, drop, store {
            val: u64,
        }

        struct NestedStruct has copy, drop, store {
            inner: InnerStruct,
            arr: vector<u8>,
        }

        struct GenericResource<T> has key {
            data: T,
        }

        // A resource to test borrowing and mutation
        resource struct TestResource has key {
            nested: NestedStruct,
            g_res: GenericResource<u64>,
            numbers: vector<u64>,
        }

        public fun new_inner_struct(): InnerStruct {
            InnerStruct { val: CONST_VAL }
        }

        public fun new_nested_struct(): NestedStruct {
            let inner = new_inner_struct();
            let arr = vector::empty<u8>();
            let arr = vector::push_back(arr, 1u8);
            let arr = vector::push_back(arr, 2u8);
            let arr = vector::push_back(arr, 3u8);
            NestedStruct { inner, arr }
        }

        public fun new_generic_resource(val: u64): GenericResource<u64> {
            GenericResource { data: val }
        }

        public fun create_resource(account: &signer) {
            let nest = new_nested_struct();
            let g = new_generic_resource(999);
            let nums = vector::empty<u64>();
            let nums = vector::push_back(nums, 10);
            let nums = vector::push_back(nums, 20);
            let res = TestResource {
                nested: nest,
                g_res: g,
                numbers: nums,
            };
            move_to(account, res);
        }

        // A method on InnerStruct with &mut self to mutate val
        public fun inner_mutate(inner: &mut InnerStruct) {
            inner.val = inner.val + 1;
        }

        // Method on NestedStruct to mutate arr vector
        public fun nested_append(nest: &mut NestedStruct, v: u8) {
            vector::push_back(&mut nest.arr, v);
        }

        // Method on TestResource to mutate fields, use nested method calls, and vector indexing
        public fun runner(account: &signer) {
            // Borrow resource mutably
            let res_ref = borrow_global_mut<TestResource>(signer::address_of(account));

            // Mutate inner struct field through nested access
            inner_mutate(&mut res_ref.nested.inner);

            // Append to inner arr vector via nested method
            nested_append(&mut res_ref.nested, 255u8);

            // Mutate generic resource
            res_ref.g_res.data = res_ref.g_res.data + 100;

            // Modify vector numbers: changing element at index 1
            *vector::borrow_mut(&mut res_ref.numbers, 1) = CONST_VAL;

            // Use an expression involving multiple operations
            let _exp = res_ref.nested.inner.val * 2 + vector::length(&res_ref.nested.arr) as u64;

            // No return, just exercising mutation and access semantics
        }
    }
}

// # run 0xCAFE::ComplexTest::create_resource --signers 0xCAFE

// # run 0xCAFE::ComplexTest::runner --signers 0xCAFE

// # publish
address 0xCAFE {
    module OutOfGasTest {
        use std::signer;

        resource struct BigCounter has key {
            count: u64,
        }

        public fun create(account: &signer) {
            move_to(account, BigCounter { count: 0 });
        }

        // Increment count in a loop to consume gas
        public fun increment_loop(account: &signer) {
            let counter = borrow_global_mut<BigCounter>(signer::address_of(account));

            let mut i = 0;
            while (i < 10_000) {
                counter.count = counter.count + 1;
                i = i + 1;
            }
        }
    }
}

// # run 0xCAFE::OutOfGasTest::create --signers 0xCAFE

#[expected_failure(out_of_gas)]
// # run 0xCAFE::OutOfGasTest::increment_loop --signers 0xCAFE


// # publish
address 0xCAFE {
    module VectorTest {
        use std::vector;
        use std::signer;

        struct Data has copy, drop, store {
            x: u8,
            y: u64,
        }

        resource struct Container has key {
            data_vec: vector<Data>,
        }

        public fun create(account: &signer) {
            let v = vector::empty<Data>();
            let v = vector::push_back(v, Data { x: 50, y: 1000 });
            let v = vector::push_back(v, Data { x: 51, y: 2000 });
            let c = Container { data_vec: v };
            move_to(account, c);
        }

        public fun modify(account: &signer) {
            let c = borrow_global_mut<Container>(signer::address_of(account));
            // modify element 0
            let elem_ref = vector::borrow_mut(&mut c.data_vec, 0);
            elem_ref.x = elem_ref.x + 1;
            elem_ref.y = elem_ref.y + 500;

            // push new element
            vector::push_back(&mut c.data_vec, Data { x: 100, y: 9999 });
        }
    }
}

// # run 0xCAFE::VectorTest::create --signers 0xCAFE

// # run 0xCAFE::VectorTest::modify --signers 0xCAFE

// Featurres:
// 1150e97b1d14b0647b6fb152fce63fd7: Write expressions in Move programs
// 447a0a2e92baf94205eeedbcef8abb18: Indicate an out-of-gas error expected in your test with `#[expected_failure(out_of_gas)]` attribute.
// e91f0718673c74856535adeb78655c60: Test correct field, vector, and resource access, mutation, and method call semantics in Move, including nested and generic structs, complex vector indexing, resource borrowing and assignment, use of constants, struct methods with &mut receivers, and resource acquisition via generics.
