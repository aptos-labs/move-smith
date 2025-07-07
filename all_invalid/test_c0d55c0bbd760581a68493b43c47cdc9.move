//# publish
module 0xA::TestModule {
    struct DataStruct { value: u64 }

    //# run 0xA::TestModule::return_complex_expression
    fun return_complex_expression(flag: bool): u64 {
        if (flag) {
            return (2 + 3) * 4; // tests parsing of arithmetic expressions with return
        }
        return 10;
    }

    //# run 0xA::TestModule::return_reference
    fun return_reference(s: &DataStruct): &u64 {
        if (s.value > 0) {
            return &s.value; // test returning reference
        } else {
            return &s.value; // different formatting
        }
    }

    public fun test_return_expression() {
        assert!(return_complex_expression(true) == 20, 100);
        assert!(return_complex_expression(false) == 10, 101);
    }

    public fun test_return_reference() {
        let s = DataStruct { value: 42 };
        let r = return_reference(&s);
        assert!(*r == 42, 102);
    }
}

//# run 0xA::TestModule::test_return_expression
//# run 0xA::TestModule::test_return_reference

//# run 0xA::TestModule::return_complex_expression --args true
//# run 0xA::TestModule::return_complex_expression --args false
//# run 0xA::TestModule::return_reference --args // no args needed
