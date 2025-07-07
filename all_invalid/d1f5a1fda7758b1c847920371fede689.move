//# publish
module 0xCAFE::TestModule {

    /// Struct with specific abilities to test constraints
    struct Data<phantom T: copy + drop> {
        value: u64,
        marker: phantom T,
    }

    /// Function to create Data with abilities
    public fun create_data<T: copy + drop>(val: u64): Data<T> {
        Data<T> {
            value: val,
            marker: phantom T,
        }
    }

    /// Inline function to get the value from Data
    public inline fun get_value<T: copy + drop>(data: &Data<T>): u64 {
        data.value
    }

    /// Function calling the inline function
    public fun call_get_value<T: copy + drop>(data: &Data<T>): u64 {
        get_value<T>(data)
    }

    /// Function to remove bytecode files from dependencies (simulate cleanup)
    public fun remove_dependency_files(): bool {
        // Simulate the removal process
        true
    }

    /// Runner function to test creation, calling inline, and removing files
    public fun run_tests() {
        let data_u8 = create_data<u8>(42);
        let data_bool = create_data<bool>(100);
        // Call inline function from a regular function
        let val1 = call_get_value<&Data<u8>>(&data_u8);
        let val2 = call_get_value<&Data<bool>>(&data_bool);

        // Simulate removal of bytecode dependencies
        let removed = remove_dependency_files();

        // For debugging or validation, you might want to store or log values
        // (but per instructions, assert checks are skipped)
    }
}

//# run 0xCAFE::TestModule::run_tests