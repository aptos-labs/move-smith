
//# run 0xB001::visibility_test::publish_private_resource --signers 0xB001 --args 42u64


//# run 0xB001::visibility_test::read_private_resource --signers 0xB001


//# run 0xB001::visibility_test::caller_reads_private --signers 0xB001


//# run 0xBEEF::visibility_test::publish_beef_resource --signers 0xBEEF


//# run 0xBEEF::visibility_test::check_beef_resource


//# run 0xBEEF::visibility_test::alias_check_beef


//# run 0xC0DE::visibility_test::publish_wildcard_resource --signers 0xC0DE


//# run 0xC0DE::visibility_test::read_wildcard_resource --args 0x000000000000C0DE
