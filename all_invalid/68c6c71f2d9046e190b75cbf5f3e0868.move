//# publish
module 0x1::DepModule {
    #[skip(empty_struct_without_fields, unused_variable)]
    struct Empty;

    #[skip(missing_docs)]
    struct Holder {
        value: u64,
    }

    public fun create_holder(): Holder {
        Holder { value: 42 }
    }

    public fun run() {
        // Use wildcard pattern to ignore parts
        let (val, _) = (5u64, 10u64);
        let _ = val;
    }
}

//# publish
module 0x1::MainModule {
    use 0x1::DepModule;

    #[skip(unused_variable)]
    struct Dummy;

    /// Runner function exercising:
    /// - wildcard pattern in let binding
    /// - calling functions from dependency module
    public fun runner() {
        let dep = DepModule::create_holder();

        // wildcard pattern ignoring second element in tuple
        let (x, _) = (dep.value, 0);
        let _ = x;

        // Use a wildcard and skip lint on unused vars
        let _ = Dummy;
    }
}
//# run 0x1::MainModule::runner

//# run
script {
    use 0x1::MainModule;

    fun main() {
        // run the runner function that internally uses wildcard pattern
        MainModule::runner();
    }
}