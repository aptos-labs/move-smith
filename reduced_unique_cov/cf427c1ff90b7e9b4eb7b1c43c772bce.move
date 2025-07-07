// Assuming this is inside a transaction script or a test function
//# run
script {
    fun main(data: &SomeStruct) {
        let val: u8 = data.field1 + data.field2;
        // further test logic here
    }
}
