//# publish
module 0xCAFE::TestModule {
    struct MyStruct has store { 
        value: u64; 
    }

    public fun new_struct(): MyStruct {
        MyStruct { value: 42 }
    }

    fun runner() {
        let s = Self::new_struct();
        let _v = s.value;
    }
}
//# run 0xCAFE::TestModule::runner

//# run
script {
    use 0xCAFE::TestModule;

    fun main() {
        let s = TestModule::new_struct();
        let _val = s.value;
    }
}

// Featurres:
// 978304a80de9c5218197ed83e328b094: Automatically add the 'fun' keyword to function definitions that do not already include it.
// 96561ae7a826cd1c56ac3e0b6b5b7993: Write code that is parsed token by token, where each expected syntactic element (token) must appear at the correct location to be accepted by the compiler.
// 3ead418b1ce59f603f43e76987f39c53: Declare structs within modules.
