# Instead of this (invalid)
run 0xCAFE::GenericStorage::create_container<u64> --signers 0xDEAD

# Use this (valid)
run 0xCAFE::GenericStorage::create_container --signers 0xDEAD --type-args u64
