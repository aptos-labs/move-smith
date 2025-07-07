
//# run 0xCAFE::VisibilityTest::publish_private_resource --signers 0xB001 --args 42u64

//# run 0xCAFE::VisibilityTest::read_private_resource --signers 0xB001

//# run 0xCAFE::VisibilityTest::caller_reads_private --signers 0xB001

//# run 0xCAFE::VisibilityTest::publish_beef_resource --signers 0xBEEF

//# run 0xCAFE::VisibilityTest::check_beef_resource

//# run 0xCAFE::VisibilityTest::alias_check_beef

//# run 0xCAFE::VisibilityTest::publish_wildcard_resource --signers 0xC0DE

//# run 0xCAFE::VisibilityTest::read_wildcard_resource --args 0x000000000000C0DE
