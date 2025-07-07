//# publish
module 0xCAFE::FriendModule {
    // friend module declaration
    friend 0xCAFE::FriendUser;

    // a friend function with friend visibility, callable only by friend modules
    friend fun secret_function(): u64 {
        42
    }

    // a public function, callable by anyone
    public fun public_function(): u64 {
        7
    }

    // a package function, callable only within the package
    package fun package_function(): u64 {
        11
    }
}

//# publish
module 0xCAFE::FriendUser {
    // Declare 0xCAFE::FriendModule as friend to access friend functions
    friend 0xCAFE::FriendModule;

    // Public function calling friend_function from FriendModule
    public fun call_friend_and_public(): (u64, u64) {
        let secret = 0xCAFE::FriendModule::secret_function();
        let pub_val = 0xCAFE::FriendModule::public_function();
        (secret, pub_val)
    }

    // A runner function to be run without arguments
    public fun runner(): (u64, u64) {
        Self::call_friend_and_public()
    }
}

//# run 0xCAFE::FriendUser::runner


//# run
script {
    fun main() {
        // Calling a function with multiple arguments separated by commas
        fun multi_args(a: u8, b: u64, c: bool): u64 {
            if (c) {
                (a as u64) + b
            } else {
                b
            }
        }

        let result1 = multi_args(10u8, 20u64, true);
        let result2 = multi_args(10u8, 20u64, false);

        // Just invoke results to use variables and run VM
        let _ = result1;
        let _ = result2;
    }
}

// Featurres:
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
// e00335d24174103ee199db8bf8ab6bf4: Declare friend modules using the 'friend' keyword outside of function, inline, or native declarations.
// f3548b79e73653c5b121e1a813240c85: Annotate module members with the visibility modifiers: public, friend, or package.
