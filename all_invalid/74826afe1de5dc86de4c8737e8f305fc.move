//# publish
address 0xDEAD {
    module FriendModule {
        // This module grants spec friend access to an unpublished module TestModule
        pragma friend 0xDEAD::TestModule;

        public fun friend_function(x: &u8): u8 {
            let copied = copy(*x);
            copied + 10u8
        }
    }
}

//# publish
address 0xDEAD {
    module TestModule {
        use std::signer;

        // Spec friend declaration to grant friend access to FriendModule
        pragma friend 0xDEAD::FriendModule;

        public fun ref_and_copy_param(x: u8): u8 {
            let y = &x;
            // copy the referenced value
            let z = copy(*y);
            // call friend module function to check friend access and copying refs
            let result = 0xDEAD::FriendModule::friend_function(y);
            z + result
        }

        public fun runner(): u8 {
            ref_and_copy_param(7u8)
        }
    }
}

//# run 0xDEAD::TestModule::runner

// Featurres:
// 73bbd39cc8ad9a38d26719906adce49e: Test that referencing a function parameter by reference and then copying its value produces the correct output.
// ab553b4b3f5bbbda29b5fe4c07380450: Use named addresses in Move modules, which are resolved to concrete numerical addresses for test identification and execution.
// d291b5fda90149d34a3c68ffd5f83a49: Declare pragma friend relationships to grant spec-level friend access to other modules, including unpublished ones
