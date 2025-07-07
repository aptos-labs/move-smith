
//# publish
module 0xCAFE::PrimaryExpressions {
    const MAGIC_NUMBER: u64 = 0xCAFECAFE;

    public fun literals_and_names(): (u64, bool, vector<u8>) {
        let num = 123456789u64;
        let flag = true;
        let text = b"test bytestring";
        (num, flag, text)
    }

    public fun assert_example(x: u64) {
        assert!(x > 0, 999);
    }
}




//# run 0xCAFE::PrimaryExpressions::literals_and_names




//# run 0xCAFE::PrimaryExpressions::assert_example --args 1u64




//# publish
module 0xDEADBEEF::ModuleWithUse {
    use 0xCAFE::PrimaryExpressions;

    public fun call_primary_literals(): (u64, bool, vector<u8>) {
        PrimaryExpressions::literals_and_names()
    }

    public fun assert_primary(x: u64) {
        PrimaryExpressions::assert_example(x)
    }
}




//# run 0xDEADBEEF::ModuleWithUse::call_primary_literals




//# run 0xDEADBEEF::ModuleWithUse::assert_primary --args 10u64




//# publish
module 0xBADDCAFE::ErrorTokenTest {
    public fun check_list_syntax() {
        // Intentionally malformed vector to demonstrate parse error detection:
        // vector with unexpected token inside list -> use comment to explain
        // The following line is commented out because if active, it causes compile error due to unexpected token (testing parser)
        /*
        let v = vector[1u8, true, 3u8]; // mixed types, boolean in u8 vector
        */
    }
}




//# run 0xBADDCAFE::ErrorTokenTest::check_list_syntax
