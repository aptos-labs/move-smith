//# publish
address 0xCAFE {
    module TypeParamStruct<T1, T2> {
        struct Container has copy, drop, store {
            field1: T1,
            field2: T2,
            nested: vector<T1>,
        }

        public fun new_container(t1: T1, t2: T2): Container {
            let nest = vector::empty<T1>();
            vector::push_back(&mut nest, t1);
            Container { field1: t1, field2: t2, nested: nest }
        }

        fun runner() {
            let c = Self::new_container(10u64, true);
            let _ = c;
        }
    }
}
//# run 0xCAFE::TypeParamStruct::runner

//# publish
address 0xCAFE {
    module MutabilityLambda {

        fun mutate_vector(v: &mut vector<u64>) {
            let mut i = 0;
            while (i < vector::length(v)) {
                let elem_ref = vector::borrow_mut(v, i);
                *elem_ref = *elem_ref + 1;
                i = i + 1;
            }
        }

        fun non_mut_closure(v: vector<u64>) {
            let add_one = fun(x: u64): u64 { x + 1 };
            let _ = add_one(5);
        }

        fun runner() {
            let mut vec = vector::empty<u64>();
            vector::push_back(&mut vec, 1);
            vector::push_back(&mut vec, 2);
            Self::mutate_vector(&mut vec);
            Self::non_mut_closure(vec);
        }
    }
}
//# run 0xCAFE::MutabilityLambda::runner

//# publish
address 0xCAFE {
    module AbortStateAnnot {

        use aptos_framework::error;

        const E_FAIL: u64 = 0x1;

        /// Custom abort function with custom abort state annotation
        #[abort_state(code = 0xDEAD, name = "MyAbortState")]
        fun fail_if_zero(x: u64) {
            if (x == 0) {
                abort E_FAIL;
            }
        }

        fun runner() {
            // This will not abort.
            Self::fail_if_zero(1);

            // The following call would abort with code E_FAIL
            // Uncomment to test actual abort:
            // Self::fail_if_zero(0);
        }
    }
}
//# run 0xCAFE::AbortStateAnnot::runner


// Featurres:
// 0e1bfda593452dc7ece2e48a51b11e61: Identify type parameters used in struct fields.
// 8171a7fbf944cb0c44bd028f983d3a3b: Handle variable bindings in lambda expressions and blocks to determine their mutability status.
// 6f89c2ca9e1261b1efb2c7251ef3af4f: Use custom abort state annotations to format and display the abort state of functions at desired points in Move code
