//# publish
module 0xCAFE::CustomTypes {
    use std::signer;

    /// A generic struct with a type parameter and ability modifiers.
    struct Wrapper<T: copy + drop> has copy, drop {
        value: T,
    }

    /// A struct with friend ability allowing other modules to access.
    struct FriendStruct has friend {
        data: u64,
    }

    /// A struct without the copy ability.
    struct NoCopy has drop {
        data: vector<u8>,
    }

    /// A "runner" function inside the module to test instantiation and access.
    public entry fun run(): () {
        let w = Wrapper { value: 42u64 };
        let f = FriendStruct { data: 123 };
        let n = NoCopy { data: vector::empty<u8>() };
        let _ = w;
        let _ = f;
        let _ = n;
    }

    /// A public function that will be inlined by the VM or compiler (hypothetical).
    public fun inline_public_function(x: u64): u64 {
        x + 1
    }

    /// A friend function only callable by friend modules.
    friend fun inline_friend_function(x: u64): u64 {
        x + 2
    }
}


//# publish
module 0xCAFE::Processor {
    use 0xCAFE::CustomTypes;
    use std::signer;

    /// A struct that contains a member from CustomTypes.
    struct Container has copy, drop {
        wrapped: CustomTypes::Wrapper<u8>,
        friend_struct: CustomTypes::FriendStruct,
    }

    /// A public runner function to test member specification and calls across modules.
    public entry fun run(): () {
        let w = CustomTypes::Wrapper { value: 7u8 };
        let f = CustomTypes::FriendStruct { data: 999 };
        let c = Container { wrapped: w, friend_struct: f };

        // Call inline public function in CustomTypes module.
        let v = CustomTypes::inline_public_function(100);

        // We cannot call friend function here because Processor is not a friend.
        let _ = c;
        let _ = v;
    }

    /// A friend runner function to test friend call.
    friend entry fun run_friend_call(): u64 {
        CustomTypes::inline_friend_function(200)
    }
}


//# run 0xCAFE::CustomTypes::run --signers 0xCAFE

//# run 0xCAFE::Processor::run --signers 0xCAFE

//# run 0xCAFE::Processor::run_friend_call --signers 0xCAFE


//# run
script {
    use 0xCAFE::CustomTypes;
    use 0xCAFE::Processor;

    fun main(s: signer) {
        // Instantiate and call inline_public_function directly.
        let result1 = CustomTypes::inline_public_function(10);
        let _ = result1;

        // Create some Wrapper struct with u64.
        let wrapper = CustomTypes::Wrapper { value: 256u64 };
        let _ = wrapper;

        // Call Processor runner functions
        Processor::run();
        // Cannot call friend function from script (not friend).
        // We call friend runner via module function for demonstration.

        let friend_result = Processor::run_friend_call();
        let _ = friend_result;
    }
}

// Featurres:
// e48e7678a9e000f681c6801151e90943: Define custom struct types with user-specified type parameters and ability modifiers.
// cda46b10d41782eb13de043d803a0d78: Specify members to be included in the module by processing existing module information or adding new members.
// 6313f2fc4f513c9bfe7ae3313b8c4a5e: Inline public or friend functions across module boundaries when permitted by visibility rules.
