//# publish
module 0xCAFE::CastingAndDiagnostics {
    use std::vector;

    // Test cast expressions: e as Type
    public fun runner(): u64 {
        let a: u8 = 5;
        let b = a as u64;                       // Cast u8 to u64
        let c = (10u64) as u8;                  // Cast u64 to u8
        let d = 255u8 as u64;                   // Cast max u8 to u64

        // Just return one cast value; this function is called only to test compilation
        b + (c as u64) + d
    }

    // Environment-variable driven diagnostics test (pseudo, as no I/O here)
    public fun diagnostics_test() {
        // Suppose an environment variable "ANSI" exists that enables color output
        let ansi = true; // In Move we can't read env vars; we simulate this with a boolean
        if (ansi) {
            // Show some colored output simulation (no real output in Move)
        } else {
            // Normal diagnostics display
        }
    }


    // A standalone function used for function-pointer test
    public fun standalone(x: u64): u64 {
        x * 2
    }
}

//# publish
module 0xCAFE::FunctionPointerEnums {
    use std::vector;

    // We define an enum to store different kinds of function pointers
  
    // A function pointer enum that can either store:
    // - Standalone function pointer
    // - A lambda struct that captures and implements a method call()
    // - A vector of such function pointers (nested composition)
    public enum FunEnum {
        StandaloneFun(fn(u64): u64),
        LambdaFun(Lambda),
        VecFun(vector<FunEnum>),
    }

    // A struct that is a lambda capturing a u64, callable as fn(u64): u64
    // Implemented as a struct with a call method
    public struct Lambda has copy, drop, store {
        capture: u64,
    }

    impl Lambda {
        public fun new(capture: u64): Self {
            Self { capture }
        }

        // call method to simulate lambda function: f(y) = capture + y
        public fun call(&self, y: u64): u64 {
            self.capture + y
        }
    }

    // A resource storing one of these function pointer enum values
    resource struct FunResource has key {
        fun_enum: FunEnum,
    }

    // Compose some nested function pointer enums and store in resource
    public fun create_resource(account: &signer) {
        let standalone_fn = FunEnum::StandaloneFun(&0xCAFE::CastingAndDiagnostics::standalone);

        let lambda = Lambda::new(10);
        let lambda_fn = FunEnum::LambdaFun(lambda);

        let mut vec_funs = vector::empty<FunEnum>();
        vector::push_back(&mut vec_funs, standalone_fn);
        vector::push_back(&mut vec_funs, lambda_fn);

        let vec_fun_enum = FunEnum::VecFun(vec_funs);

        move_to(account, FunResource { fun_enum: vec_fun_enum });
    }

    // Call the function pointers recursively with an input and accumulate results
    public fun call_fun_enum(fe: &FunEnum, x: u64): u64 acquires FunResource {
        match fe {
            FunEnum::StandaloneFun(f) => f(x),                           // Call standalone function pointer
            FunEnum::LambdaFun(lambda) => lambda.call(x),               // Call lambda method
            FunEnum::VecFun(vfuns) => {
                let mut sum = 0;
                let len = vector::length(vfuns);
                let mut i = 0;
                while (i < len) {
                    sum = sum + call_fun_enum(&vector::borrow(vfuns, i), x);
                    i = i + 1;
                }
                sum
            }
        }
    }

    // A runner function that reads resource, calls the nested enum, then destroys it
    public fun runner(account: &signer): u64 acquires FunResource {
        let res = borrow_global<FunResource>(signer::address_of(account));
        let val = call_fun_enum(&res.fun_enum, 5);
        // Destroy resource, just to exercise moves
        move_from<FunResource>(signer::address_of(account));
        val
    }
}

//# run 0xCAFE::CastingAndDiagnostics::runner

//# run 0xCAFE::FunctionPointerEnums::create_resource --signers 0xCAFE

//# run 0xCAFE::FunctionPointerEnums::runner --signers 0xCAFE

// Featurres:
// 2461d5aa9c9cdc3bef5fae8844912c5a: Cast expressions to a specified type using the 'as' keyword (e as Type).
// 8a8ce183c37cd9e15739542446920f83: Display diagnostics with ANSI color if environment variable is set to 'ANSI'.
// 2e519c18a9e5a3cb570c8d8c2e7c7d3a: Test that Move function-pointer enums can store, move, and invoke both standalone functions and lambda captures (including persistent functions and vector-of-funs), and can be composed within other enums and used as resource fields.
