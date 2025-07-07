
//# run 0xDEAD::StructAndFunctionTest::create_person --args b"John Doe" 30 true
// Corrected args: quote the string properly, no need for b"..." in args list as CLI expects string literals

//# run 0xDEAD::StructAndFunctionTest::create_person --args "John Doe" 30 true

// # run 0xDEAD::StructAndFunctionTest::create_dataholder_u32 --args 42u32 1627848382

//# run 0xDEAD::StructAndFunctionTest::create_dataholder_u32 --args 42u64 1627848382

// # run 0xDEAD::StructAndFunctionTest::create_status_init

//# run 0xDEAD::StructAndFunctionTest::create_status_init

// # run 0xDEAD::StructAndFunctionTest::create_status_ready --args 404u32

//# run 0xDEAD::StructAndFunctionTest::create_status_ready --args 404u64

// # run 0xDEAD::StructAndFunctionTest::create_status_error --args 65535u16

//# run 0xDEAD::StructAndFunctionTest::create_status_error --args 65535u64

// # run 0xDEAD::StructAndFunctionTest::process_person --args "John Doe" 30 true

//# run 0xDEAD::StructAndFunctionTest::process_person --args "John Doe" 30 true

// # run 0xDEAD::StructAndFunctionTest::get_data_and_age --args 100u64 99999u64

//# run 0xDEAD::StructAndFunctionTest::get_data_and_age --args 100u64 99999u64

// Additionally, testing package registration:
 
//# run 0xDEAD::StructAndFunctionTest::register_package --args "TestPackage" 1u64