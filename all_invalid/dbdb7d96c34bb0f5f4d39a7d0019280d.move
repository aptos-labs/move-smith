
//# publish
module 0xCAFE::DeprecatedModule {
    #![deprecated = true]
    #![pragma1 = true, pragma2 = 42u8, pragma3 = b"deprecated"]

    public fun greet(name: vector<u8>): vector<u8> {
        name
    }

    public fun sum(a: u64, b: u64): u64 {
        a + b
    }
}


//# run 0xCAFE::DeprecatedModule::greet --args b"MoveUser"


//# run 0xCAFE::DeprecatedModule::sum --args 100u64 200u64


//# publish
module 0xCAFE::ParamSeparatorModule {
    #![pragma_bool = true, pragma_num = 0u64, pragma_bytes = x"AA55"]

    public fun function_with_params(x: u8, flag: bool, data: vector<u8>): u8 {
        let result = if (flag) {
            x + 1
        } else {
            x - 1
        };
        result
    }

    public fun runner() {
        let _ = Self::function_with_params(5u8, true, b"test_bytes");
        let _ = Self::function_with_params(10u8, false, b"hello");
    }
}


//# run 0xCAFE::ParamSeparatorModule::runner


//# run 0xCAFE::ParamSeparatorModule::function_with_params --args 7u8 true b"paramtest"


// Featurres:
// cd6efccaaa22ee0f4bc4a974802d383c: Specify function parameters separated by commas within parentheses.
// dffa67cb5913057d2fb5542cb75c7d68: Annotate modules with deprecation status to indicate they are deprecated.
// 5280e781f924b743805c827f2d2f3c75: Assign boolean (true/false), numeric, byte string, or identifier values to pragma properties.
