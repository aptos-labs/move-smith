//# publish
module 0x1::FunctionPointerModule {
    use std::vector;

    /// 1: Define trait for function pointers (callables), store closures, invoke them
    public trait CallableTrait<T, R> {
        public fun call(&self, x: T): R;
    }

    /// A generic struct holding any callable object
    struct FnHolder<T, R> has store {
        f: vector<u8>, // simulate raw function pointer; for demo purposes, we wrap closure in lambda
        value: u64,
    }

    /// Make an example closure as struct
    struct Plus42 has store, copy {
        pub val: u8,
    }
    public fun call(self: &Plus42, v: u64): u64 {
        self.val as u64 + v + 42
    }

    /// Runner function that stores a closure and calls it
    public fun runner(): u64 {
        let closure = Plus42 { val: 8u8 };
        // Simulating storage of closure and dynamic call
        Self::call(&closure, 2u64)
    }
}
//# run 0x1::FunctionPointerModule::runner

//# publish
module 0x1::UninitCheckerModule {
    /// 2: UninitializedUseChecker - try to use variable before initializing (should fail)
    public fun runner() {
        let x: u64;
        //let y = x + 5; // UNCOMMENT to trigger UninitializedUseChecker
        let x = 10u64; // properly initialize before use
        let y = x + 5;
        let _z = y;
    }
}
//# run 0x1::UninitCheckerModule::runner

//# publish
module 0x1::RestrictedNameRulesModule {
    /// 3: Enforce and check restricted naming rules (simulated)
    fun is_allowed_name(name: &vector<u8>): bool {
        // No uppercase at start and no "_"
        let zero = *vector::borrow(name, 0);
        (zero >= b'a' && zero <= b'z')
    }

    /// Try different names
    public fun runner() {
        let n1 = b"bad_name";
        let n2 = b"ValidName";
        let n3 = b"goodname";
        let _ok1 = Self::is_allowed_name(&vector::from_bytes(&n1));
        let _ok2 = Self::is_allowed_name(&vector::from_bytes(&n2));
        let _ok3 = Self::is_allowed_name(&vector::from_bytes(&n3));
    }
}
//# run 0x1::RestrictedNameRulesModule::runner

//# publish
module 0x1::LambdaLiftingModule {
    use std::vector;
    /// 4: Lambda lifting and higher order/lambda scoping
    fun lifted_add(x: u64): u64 {
        let lambda = |y: u64| x + y; // lambda captures x
        lambda(100)
    }

    /// Higher order with inline
    fun inline_lifted_multiply(x: u64): u64 {
        let lambda = fun (y: u64): u64 { x * y }; // optional inline function
        lambda(3)
    }

    public fun runner(): (u64, u64) {
        (Self::lifted_add(77), Self::inline_lifted_multiply(9))
    }
}
//# run 0x1::LambdaLiftingModule::runner

//# publish
module 0x1::NamedModuleAccessModule {
    use std::signer;
    /// 5: Named module access and type parameter usage
    struct Foo<T> has store, copy { x: T }
    public fun make_foo(): Foo<u64> {
        Foo { x: 77 }
    }
    public fun bar<T>(val: T): Foo<T> {
        Foo { x: val }
    }
    public fun runner(): u64 {
        let ret = 0x1::NamedModuleAccessModule::make_foo(); // named module access, no type param
        let ret2 = 0x1::NamedModuleAccessModule::bar<u8>(7u8); // named, with type param
        ret.x
    }
}
//# run 0x1::NamedModuleAccessModule::runner

//# publish
module 0x1::TokenConsumeModule {
    /// 6: Consume a specific token during parsing
    /// We'll define a fake macro/field/attribute using #[my_token] and use it
    #[my_token]
    public fun runner(): u64 {
        42
    }
}
//# run 0x1::TokenConsumeModule::runner