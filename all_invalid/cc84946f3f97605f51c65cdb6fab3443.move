
//# run 0xCAFE::visibility_test::publish_private_resource --signers 0xB001 --args 42u64

//# run 0xCAFE::visibility_test::read_private_resource --signers 0xB001

//# run 0xCAFE::visibility_test::caller_reads_private --signers 0xB001

//# run 0xCAFE::visibility_test::publish_beef_resource --signers 0xBEEF

//# run 0xCAFE::visibility_test::check_beef_resource

//# run 0xCAFE::visibility_test::alias_check_beef

//# run 0xCAFE::visibility_test::publish_wildcard_resource --signers 0xC0DE

//# run 0xCAFE::visibility_test::read_wildcard_resource --args 0x000000000000C0DE
