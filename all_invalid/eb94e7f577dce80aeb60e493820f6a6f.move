//# publish
module 0x1::RModule {
    use std::signer;
    use std::debug;

    #[skip(dead_code, unused_variables)]
    struct R has key {
        v: u64,
    }

    public fun new_r(value: u64): R {
        R { v: value }
    }

    public fun do(r: &mut R) {
        if (r.v == 0) {
            r.v = 42;
        } else {
            r.v = r.v * 2;
        }
    }

    public fun runner() {
        let mut r = new_r(1);
        do(&mut r);
        debug::print(&r.v);
    }
}

//# run 0x1::RModule::runner

//# publish
module 0x1::ParserTest {
    #[skip(unused_attributes)]
    struct StructVariant {
        name: vector<u8>, // Named attribute: name
        id: u64,          // Named attribute: id
    }

    public fun get_variant_name(sv: &StructVariant): vector<u8> {
        sv.name
    }

    public fun new_variant(): StructVariant {
        StructVariant { name: b"TestVariant", id: 101 }
    }

    public fun runner() {
        let sv = new_variant();
        // Just calling get_variant_name
        let _name = get_variant_name(&sv);
    }
}

//# run 0x1::ParserTest::runner

//# publish
module 0x1::ValueExprTest {
    // Define enum representing different value expression types
    enum ValueExpr {
        Unit,
        Error,
        Break,
        Continue,
        Specification,
        Value(u64),
    }

    public fun get_unit(): ValueExpr {
        ValueExpr::Unit
    }

    public fun get_error(): ValueExpr {
        ValueExpr::Error
    }

    public fun get_break(): ValueExpr {
        ValueExpr::Break
    }

    public fun get_continue(): ValueExpr {
        ValueExpr::Continue
    }

    public fun get_specification(): ValueExpr {
        ValueExpr::Specification
    }

    public fun get_value(val: u64): ValueExpr {
        ValueExpr::Value(val)
    }

    public fun runner() {
        let _ = get_unit();
        let _ = get_error();
        let _ = get_break();
        let _ = get_continue();
        let _ = get_specification();
        let _ = get_value(123);
    }
}

//# run 0x1::ValueExprTest::runner

//# run
script {
    use 0x1::RModule;

    fun main(account: signer) {
        let mut r = RModule::new_r(0);
        RModule::do(&mut r);
        // No assertions needed; running to exercise VM.
    }
}