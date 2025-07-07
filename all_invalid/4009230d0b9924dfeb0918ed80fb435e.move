//# publish
address 0xCAFE {
    module ModuleKeys {
        // 1: Create module keys with a specific address and module name
        public fun get_module_key(): address {
            0xCAFE
        }
    }
}

//# publish
address 0xBEEF {
    module Structs {
        // 2: Declare structures within modules for data organization.
        struct Data has copy, drop, store {
            value: u64,
        }

        public fun new_data(v: u64): Data {
            Data { value: v }
        }
    }
}

//# publish
address 0xDEAD {
    module StoredFunc {
        // 3: Test that a stored function can be initialized and later invoked returning 23

        // stored function type alias
        public type StoredFunctor = fun() -> u8;

        resource struct Container has key {
            f: StoredFunctor,
        }

        // friend function to create container with stored function
        friend fun init_container(): Container {
            Container { f: stored_function }
        }

        fun stored_function(): u8 {
            23
        }

        public fun call_stored(container: &Container): u8 {
            (container.f)()
        }

        // runner with no args returns 23 from the stored function call
        public fun runner(): u8 {
            let c = init_container();
            call_stored(&c)
        }
    }
}
//# run 0xDEAD::StoredFunc::runner

//# publish
address 0xFEED {
    module FriendVis {
        struct Secret has key {
            value: u8,
        }

        // 4: Use 'friend' visibility for functions accessible only within the same crate or friends
        friend fun friend_function(s: &Secret): u8 {
            s.value
        }

        // package visibility function (no keyword)
        fun package_function(s: &Secret): u8 {
            s.value + 1
        }

        // public constructor
        public fun make_secret(v: u8): Secret {
            Secret { value: v }
        }

        // runner to show friend and package usage inside module
        public fun runner(): (u8, u8) {
            let s = make_secret(10);
            let f = friend_function(&s);
            let p = package_function(&s);
            (f, p)
        }
    }
}
//# run 0xFEED::FriendVis::runner

// Testing feature #5 and #6 with attribute syntax and errors:

//#publish
address 0xBABE {
    #[apply(fail)] // 6: Use attributes with apply syntax to specify expected failures
    module #[id(123)] // 5: Trigger an error with invalid attribute value that is not a valid module identifier
    BadModule {
        public fun test(): u8 {
            1
        }
    }
}

// Note: The line #[id(123)] is invalid since a module id attribute expects an address or proper identifier, 
// causing a compilation failure as expected.