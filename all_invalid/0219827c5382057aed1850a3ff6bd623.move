//# publish
address 0x1 {
    module TestModule {
        use std::signer;

        #[skip(lint1, lint2)]
        struct R has key {
            val: u64,
        }

        // A function that modifies R based on input v
        public fun do(rc: &mut R, v: u64) {
            // Use match as a function call
            match(v,
                0, 
                |_: u64| { rc.val = 10; },
                1, 
                |_: u64| { rc.val = 20; },
                |_: u64| { rc.val = 0; }
            );
        }

        public fun new_r(): R {
            R { val: 0 }
        }

        // A runner function that creates R, does some operations and returns the val
        public fun runner(): u64 {
            let mut r = new_r();
            do(&mut r, 0);
            do(&mut r, 1);
            do(&mut r, 2);
            r.val
        }
    }
}
//# run 0x1::TestModule::runner

//# publish
address 0x2 {
    module SeqScope {
        #[skip(lint_unused, lint_shadowing)]
        struct R has key {
            inner: u8,
        }

        // Sequence function that demonstrates scope handling using a sequence of statements
        public fun seq_do(r: &mut R) {
            {
                r.inner = 5;
            };
            {
                let x = 3;
                r.inner = r.inner + x;
            };
            {
                // last statement must be wrapped as sequence item
                r.inner = r.inner * 2;
            };
        }

        public fun new_r(): R {
            R { inner: 0 }
        }

        public fun runner(): u8 {
            let mut r = new_r();
            seq_do(&mut r);
            r.inner
        }
    }
}
//# run 0x2::SeqScope::runner

//# publish
address 0x3 {
    module AstSimplify {
        use std::vector;

        #[skip(lint_unused)]
        struct R has key {
            v: u64,
        }

        // Original complex function which can be simplified by AST simplification passes
        public fun complicated_do(rc: &mut R, n: u64) {
            let mut i = 0;
            while (i < n) {
                rc.v = rc.v + 1;
                i = i + 1;
            }
        }

        // Another function that calls complicated_do multiple times
        public fun caller(rc: &mut R) {
            complicated_do(rc, 5);
            complicated_do(rc, 2);
        }

        public fun new_r(): R {
            R { v: 0 }
        }

        // Runner to test simplification by calling caller function
        public fun runner(): u64 {
            let mut r = new_r();
            caller(&mut r);
            r.v
        }
    }
}
//# run 0x3::AstSimplify::runner

//# run
script {
    use 0x1::TestModule;
    use 0x2::SeqScope;
    use 0x3::AstSimplify;

    fun main(account: signer) {
        let val1 = TestModule::runner();
        let val2 = SeqScope::runner();
        let val3 = AstSimplify::runner();

        // No asserts, just run for compilation and execution verification
    }
}