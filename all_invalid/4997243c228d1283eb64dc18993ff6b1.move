//# publish
module 0xCAFE::RestrictOps {
    public fun verified_function() {
        // some verified logic here
    }

    public fun run_verified_function() {
        // simply call the verified function
        verified_function();
    }
}

//# run 0xCAFE::RestrictOps::run_verified_function --signers 0xCAFE