// SPDX-License-Identifier: Apache-2.0
// This transactional test exercises friend pragma, uses declarations with aliases, and test functions in a module.

//# publish
address 0xCAFE {
    pragma friend = 0xBABE;

    module FriendModule {
        // Define a struct to demonstrate friend pragma usage
        struct Foo has store, key {}

        // A function accessible by friend address 0xBABE only
        public(friend 0xBABE) fun secret_value(): u64 {
            42
        }

        // A public function to demonstrate normal public access
        public fun normal_value(): u64 {
            7
        }

        // A test function, identified by #[test] attribute
        #[test]
        public fun test_secret_value(): bool {
            // The function itself won't do assertions, just a smoke test
            let val = Self::secret_value();
            val == 42
        }

        #[test]
        public fun test_normal_value(): bool {
            let val = Self::normal_value();
            val == 7
        }
    }
}

//# publish
address 0xBABE {
    module ConsumerModule {
        // This module calls FriendModule::secret_value()
        // We require friend access, so pragma friend = 0xBABE must be defined on FriendModule as done above.

        use 0xCAFE::FriendModule;
        use 0xCAFE::FriendModule as FM; // alias

        // Runner function with no arguments, calls secret_value via alias and normal call.
        public fun runner(): u64 {
            let a = FriendModule::normal_value();
            let b = FM::secret_value();
            a + b
        }

        #[test]
        public fun test_runner(): bool {
            let s = Self::runner();
            s == 49
        }
    }
}

//# run 0xCAFE::FriendModule::test_secret_value
//# run 0xCAFE::FriendModule::test_normal_value
//# run 0xBABE::ConsumerModule::test_runner


//# run
script {
    use 0xCAFE::FriendModule as FM;
    use 0xBABE::ConsumerModule as CM;

    fun main() {
        // Call FriendModule::normal_value()
        let n = FM::normal_value();

        // Cannot call FM::secret_value() here, as signer is 0xCAFE, and friend only allowed 0xBABE

        // Call ConsumerModule::runner() which uses friend access properly
        let r = CM::runner();

        // Just a no-op script to exercise compiler and VM
        let _ = (n, r);
    }
}

// Featurres:
// 3d4de455fbf6f87677a9c22a23f67039: Use the special 'friend' property in pragmas even though 'friend' is a keyword.
// c60e0dacdbbbb99a118f95e2c9f730c0: Use 'uses' declarations to bring modules or functions into script scope (using aliases).
// 26c23dba8891f14a4761eb46367ab648: Define test functions within a module that are identified as test cases.
