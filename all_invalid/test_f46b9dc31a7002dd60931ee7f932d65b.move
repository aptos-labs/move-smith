//# publish
module 0xabc::constants {
    const MY_CONST: u64 = 42;
}

//# publish
module 0xabc::caller {
    // This function calls the exposed function from the constants module
    public fun get_constant(): u64 {
        0xabc::constants::MY_CONST
    }
    
    // Runner function to call get_constant
    public fun run_get_constant(): u64 {
        get_constant()
    }
}

//# run 0xabc::caller::run_get_constant