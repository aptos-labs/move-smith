# Initialize resource
task run 0xDABBAD00::TestModule::init_resource --signers 0xBADD

# Modify resource
task run 0xDABBAD00::TestModule::lambda_modify_resource --signers 0xBADD --args 5u64

# Verify resource
task run 0xDABBAD00::TestModule::verify_resource --args 0xBADD 5u64
