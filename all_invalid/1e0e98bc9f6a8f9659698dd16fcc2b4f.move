//# run
script {
    use 0x1::Bitwise; // Adjust the module/path if different

    fun bitwise_and_u8(a: u8, b: u8): u8 {
        a & b
    }

    fun bitwise_or_u16(a: u16, b: u16): u16 {
        a | b
    }

    fun main() {
        let _ = bitwise_and_u8(0x0Au8, 0x0Cu8);
        let _ = bitwise_or_u16(0x00A0u16, 0x007Fu16);
    }
}
