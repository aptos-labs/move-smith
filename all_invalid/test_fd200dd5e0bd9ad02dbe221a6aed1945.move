//# publish
module 0x1::PrintBytecodeTest {
    public fun run_script_bytecode_printing() {
        // This function is just a placeholder for running the script bytecode print test.
        // No logic needed here.
    }
    
    public fun run_module_bytecode_printing() {
        // Placeholder for running the module bytecode print test.
        // No logic needed here.
    }
}

//# print-bytecode

script {
    fun main() {}
}

//# print-bytecode --input=module
module 0x1::BytecodePrinter {
    public fun print_script() {
        // Function to trigger script bytecode printing.
    }

    public fun print_module() {
        // Function to trigger module bytecode printing.
    }
}

//# run 0x1::BytecodePrinter::print_script
//# run 0x1::BytecodePrinter::print_module --signers 0x1
