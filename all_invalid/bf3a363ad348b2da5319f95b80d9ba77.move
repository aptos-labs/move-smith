//# publish
// Source location annotation example:
// @source_location(file = "unused_private.move", module_name = "UnusedPrivateModule")
module 0x1::UnusedPrivateModule {
    // private unused function, should be detected as unused
    fun unused_private_func(): u64 {
        42
    }

    // public function not called anywhere - also unused from outside
    public fun unused_public_func(): u64 {
        7
    }

    // used public function
    public fun used_public_func(): u64 {
        100
    }

    // runner calls only used_public_func, so unused functions remain unused
    public fun runner() {
        let _ = Self::used_public_func();
    }
}
//# run 0x1::UnusedPrivateModule::runner

//# publish
// @source_location(file = "inline_caller.move", module_name = "InlineCaller")
module 0x1::InlineCallee {
    // Inline function returning some value
    public inline fun add_one(x: u64): u64 {
        x + 1
    }

    public inline fun mul_two(x: u64): u64 {
        x * 2
    }
}

//# publish
// @source_location(file = "inline_caller.move", module_name = "InlineCaller")
module 0x1::InlineCaller {
    use 0x1::InlineCallee;

    public fun caller_add(x: u64): u64 {
        InlineCallee::add_one(x)
    }

    public fun caller_mul_then_add(x: u64): u64 {
        // call nested inline functions: (x * 2) + 1
        InlineCallee::add_one(InlineCallee::mul_two(x))
    }

    // runner calls functions to exercise calls to inline functions in other module
    public fun runner() {
        let r1 = Self::caller_add(5);
        let r2 = Self::caller_mul_then_add(5);

        // We don't assert but ensure the compiler and VM execute
        // r1 == 6, r2 == 11
        let _ = r1;
        let _ = r2;
    }
}
//# run 0x1::InlineCaller::runner

//# publish
// @source_location(file = "union_type.move", module_name = "UnionTypeModule")
module 0x1::UnionTypeModule {
    // Recognize a type beginning with | indicating a variant (union)
    // Move doesn't support union types natively,
    // simulate with enum and tag

    // Define a variant type named |Variant (name starting with pipe)
    struct |Variant has copy, drop, store {
        tag: u8,
        value: u64
    }

    // constructors for variant
    public fun new_variant1(v: u64): |Variant {
        |Variant { tag: 1, value: v }
    }

    public fun new_variant2(v: u64): |Variant {
        |Variant { tag: 2, value: v }
    }

    // runner to create and use |Variant
    public fun runner() {
        let v1 = Self::new_variant1(10);
        let v2 = Self::new_variant2(20);
        let _ = v1;
        let _ = v2;
    }
}
//# run 0x1::UnionTypeModule::runner

//# publish
// @source_location(file = "friends_access.move", module_name = "FriendsModule")
module 0x1::FriendsModule {

    // Declare a friend using a name access chain
    friend 0x1::FriendsModule::TrustedFriend;

    // Define the friend module (must be in the same address)
    module TrustedFriend {
        // Trusted friend can access private function of FriendsModule
        public fun access_private(): u64 {
            Self::secret()
        }
    }

    // private function only accessible to friends
    fun secret(): u64 {
        999
    }

    // public runner calls friend
    public fun runner(): u64 {
        // calling the friend module function that accesses private secret
        TrustedFriend::access_private()
    }
}
//# run 0x1::FriendsModule::runner

//# run
script {
    use 0x1::UnusedPrivateModule;
    use 0x1::InlineCaller;
    use 0x1::UnionTypeModule;
    use 0x1::FriendsModule;

    fun main() {
        // Run UnusedPrivateModule runner
        UnusedPrivateModule::runner();

        // Run InlineCaller runner (calls inline from another module)
        InlineCaller::runner();

        // Run UnionTypeModule runner
        UnionTypeModule::runner();

        // Run FriendsModule runner (tests friend access)
        let _ = FriendsModule::runner();
    }
}