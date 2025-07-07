// Entry point scripts to run the tests as per the test cases comments

// Run variable_in_while_loop function
// script {
//     fun main(account: &signer) {
//         let result = 0xCAFE::TestModule::variable_in_while_loop();
//         // Possibly assert result == 42
//     }
// }

// Create internal resource for access test
// script {
//     fun main(account: &signer) {
//         0xBADD::TestModule::create_internal_resource(account);
//     }
// }

// Read internal resource value
// script {
//     fun main(account: &signer) {
//         let val = 0xBADD::TestModule::read_internal_resource(account);
//         // Assert or verify val == 999
//     }
// }

// Call friend-only function
// script {
//     fun main(account: &signer) {
//         let val = 0xC0FF::TestModule::friend_only_function();
//         // Assert val == 42
//     }
// }

// Attempt to call internal_function directly (should fail at compile time)
// The following code should produce a compile error if uncommented
// script {
//     fun main() {
//         // This call should fail
//         let invalid = 0xC0FF::TestModule::internal_function();
//     }
// }

// Call get_friend_value (accessible to friends)
// script {
//     fun main(account: &signer) {
//         let val = 0xC0FF::TestModule::get_friend_value();
//         // Assert val == 1000
//     }
// }
