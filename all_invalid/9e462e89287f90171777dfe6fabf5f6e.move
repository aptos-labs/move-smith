address 0x1 {
    module LoopAndFriendTest {
        use std::debug;
        use std::signer;

        /// A dummy struct to test friend access.
        struct FriendStruct has key {
            value: u64,
        }

        /// This struct defines a friend module to demonstrate friend relationships.
        /// Only the FriendModule can access `FriendStruct`'s constructor.
        friend module 0x2::FriendModule;

        /// Constructor is private to this module.
        fun create_friend_struct(value: u64): FriendStruct {
            FriendStruct { value }
        }

        /// Public fun for friend module to call, to verify friend access.
        public(friend) fun get_value(fs: &FriendStruct): u64 {
            fs.value
        }

        /// Test function to verify the for-loop does not run when start > end,
        /// and unreachable code after return does not cause failures.
        #[test_only]
        public fun test_loop_and_return_unreachable(_signer: &signer) {
            let mut sum = 0;

            // 1. Verify for loop with start > end does not execute body
            for i in 10..4 {
                // If this runs, we fail loudly.
                debug::assert(false, 1);
                sum = sum + i;
            }
            // sum should be zero because loop body never executed
            debug::assert(sum == 0, 2);

            // 2. Test unreachable code after return does not cause assertion failures.
            if true {
                return;
                // Unreachable code after return, ensure no compiler/debug assertion error
                debug::assert(false, 3);
            }

            // If execution reaches here, fail because return above should have exited.
            debug::assert(false, 4);
        }
    }

    // Friend module declared outside the LoopAndFriendTest module,
    // with declared friend access to test friend relationships.
    module 0x2::FriendModule {
        use 0x1::LoopAndFriendTest;

        #[test_only]
        public fun test_friend_access(_: &signer) {
            let fs = LoopAndFriendTest::create_friend_struct(42);
            let value = LoopAndFriendTest::get_value(&fs);
            // Check that friend access is allowed and value is correct.
            debug::assert(value == 42, 5);
        }
    }
}

// Featurres:
// aebedc6b7752fe634f3b20175f8bd8b9: Verify that a for loop with a range where the start is greater than the end (e.g., 10..4) does not execute its body.
// b5c3260276f2028e7b0be092265f351d: Test that code after a return statement is unreachable and does not cause assertion failures.
// 2e44c943908f03ef3c8d0b8d6d02a784: Declare module-level friend relationships using the 'friend' feature.
