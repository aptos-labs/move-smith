//# publish
address 0xCAFE {
    // Test 1: Public module and public functions
    public module VisibilityTest {
        // Resource with key and store ability
        struct MyResource has store, key {
            val: u64,
        }

        // Public function to publish resource to signer
        public fun publish_resource(account: &signer) {
            let resource = MyResource { val: 42 };
            move_to(account, resource);
        }

        // Public function to borrow resource by fully qualified path
        public fun borrow_resource(account: &signer): &MyResource {
            // Reference safety: returns resource reference
            &borrow_global<MyResource>(signer_address(account))
        }

        // Helper function to get signer address
        public inline fun signer_address(account: &signer): address {
            signer::address_of(account)
        }

        // Public runner function that exercises the above
        public fun runner(account: &signer) {
            Self::publish_resource(account);
            let res_ref = Self::borrow_resource(account);
            // just read val to exercise reference usage
            let _ = res_ref.val;
        }
    }
}
//# run 0xCAFE::VisibilityTest::runner --signers 0xCAFE


//# publish
address 0xCAFE {
    public module RefSafetyTest {
        struct Data has copy, drop, store, key {
            x: u8,
            y: u8,
        }

        // Public function creating multiple references and enforcing safe usage
        public fun multiple_borrows(account: &signer) {
            let data = Data { x: 10, y: 20 };
            move_to(account, data);

            // Multiple immutable borrows allowed
            let r1 = &borrow_global<Data>(signer::address_of(account));
            let r2 = &borrow_global<Data>(signer::address_of(account));
            let _sum = (r1.x + r2.y) as u8;

            // Not creating mutable borrow here because legacy ref safety forbids mutable and immutable coexisting
        }

        // Public function demonstrating legacy ref safety error scenario (commented out, but valid Move code):
        // Uncommenting the following code would cause a compile or runtime ref safety error.
        /*
        public fun invalid_borrow(account: &signer) {
            let r_mut = &mut borrow_global_mut<Data>(signer::address_of(account));
            let r_imm = &borrow_global<Data>(signer::address_of(account)); // invalid with mut borrow
            let _ = r_mut.x + r_imm.y;
        }
        */

        // Runner to execute valid case
        public fun runner(account: &signer) {
            Self::multiple_borrows(account);
        }
    }
}
//# run 0xCAFE::RefSafetyTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::VisibilityTest;
    use 0xCAFE::RefSafetyTest;

    fun main(account: signer) {
        VisibilityTest::runner(&account);
        RefSafetyTest::runner(&account);
    }
}


// Featurres:
// 3de85dae439018dd0f5193f82ca4cadc: Specify 'public' visibility for functions or modules.
// 942405c0bdb1f64f626159be43d3b1ce: Refer to resources using a fully qualified path in the form address::module::resource.
// d909a2208f147d4c283476498aa0ead5: Perform reference safety checks based on features or legacy rules.
