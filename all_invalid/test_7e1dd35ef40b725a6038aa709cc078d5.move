//# publish
module 0xA55A::access_test {
    enum Bar has drop {
        X(u8, u64),
        Y(bool),
    }

    fun extract_first_field(b: Bar): u8 {
        match b {
            Bar::X(val, _val2) => val,
            Bar::Y(_) => 0,
        }
    }

    fun run_access_test(): u8 {
        let b1 = Bar::X(7, 100);
        let b2 = Bar::Y(true);
        extract_first_field(b1) + extract_first_field(b2)
    }
}

//# run 0xA55A::access_test::run_access_test

//# run
script {
    const INT8_CONST: i8 = -5;
    const UINT16_CONST: u16 = 500;
    const BOOL_TRUE: bool = true;
    const ADDR_CONST: address = @0xDEADBEEF;
    const HEX_DATA: vector<u8> = x"deadbeef";
    const BYTE_DATA: vector<u8> = b"move";

    fun main() {
        assert!(INT8_CONST == -5, 42);
        assert!(UINT16_CONST == 500, 42);
        assert!(BOOL_TRUE == true, 42);
        assert!(ADDR_CONST == @0xDEADBEEF, 42);
        assert!(HEX_DATA == x"deadbeef", 42);
        assert!(BYTE_DATA == b"move", 42);
    }
}

//# run -- verbose -- 0xA55A::access_test::extract_first_field

//# publish
module 0x1234::inline_test {
    inline fun modify_local(x: &mut u64) {
        *x = *x + 10;
    }

    public fun run_inline_test(): u64 {
        let mut result = 5;
        modify_local(&mut result);
        let x = 20;
        // Modify x via inline function
        modify_local(&mut x);
        result + x
    }
}

//# run 0x1234::inline_test::run_inline_test