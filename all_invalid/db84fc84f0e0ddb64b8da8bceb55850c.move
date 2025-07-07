
//# publish
module 0xBADA::FlowAnalysisTest {
    use std::vector;

    struct DataHolder has store, key {
        value: u64,
    }

    // A public function with control flow
    public fun compute_sum_and_branch(x: u64, y: u64): u64 {
        let sum = x + y;
        if (sum > 100) {
            let _ = 42; // Dead branch: branch where sum > 100
        } else {
            let _ = 7; // Dead branch: branch where sum <= 100
        };
        sum
    }

    // A function to test nested while loops with control flow
    public fun nested_while_loop(start: u64): u64 {
        let acc = 0;
        let i = start;
        while (i < 10) {
            let j = i;
            while (j > 0) {
                acc = acc + j;
                j = j - 1;
            };
            i = i + 1;
        };
        acc
    }

    // Lifted lambda with inline annotation
    public inline fun lambda_double(x: u8): u8 {
        x * 2
    }

    // Control flow with lambda call
    public fun control_flow_with_lambda(n: u8): u8 {
        let result = lambda_double(n);
        if (result > 10) {
            let _ = result + 1;
        } else {
            let _ = result - 1;
        };
        result
    }

    // An enum with control flow branches
    enum Status has copy, drop {
        Success,
        Failure(u8),
        Pending { reason: bool }
    }

    // Function testing match in control flow graph
    public fun match_enum(s: Status): u64 {
        let value = match (s) {
            Status::Success => 1,
            Status::Failure(code) => code as u64,
            Status::Pending { reason } => if (reason) { 0 } else { 2 },
        };
        value
    }

    // A function with public(friend) item
    public(friend) struct FriendStruct has store, key {
        data: vector<u8>,
    }

    // Function to access the public(friend) item
    public fun create_friend_struct(data: vector<u8>): FriendStruct {
        let fs = FriendStruct { data };
        fs
    }

    // Function to modify the public(friend) item within this module
    public fun modify_friend_struct(fs: &mut FriendStruct, new_data: vector<u8>) {
        fs.data = new_data;
    }
}


//# run 0xBADA::FlowAnalysisTest::compute_sum_and_branch --args 50u64 60u64


//# run 0xBADA::FlowAnalysisTest::nested_while_loop --args 2u64


//# run 0xBADA::FlowAnalysisTest::control_flow_with_lambda --args 15u8


//# run 0xBADA::FlowAnalysisTest::match_enum --args 0u8


//# run 0xBADA::FlowAnalysisTest::match_enum --args 1u8


//# run 0xBADA::FlowAnalysisTest::match_enum --args 2u8


//# run 0xBADA::FlowAnalysisTest::create_friend_struct --args 0xABCD


//# run 0xBADA::FlowAnalysisTest::modify_friend_struct --args 0xABCD, "new_data" vector<u8>{0x01, 0x02}
// signers 0xABCDE


// Featurres:
// cb1b678d25a02415a00eaff5d4db070b: Use control flow graph analysis to identify the predecessor blocks of each block in your Move code.
// b96aa00a04c014ffafa027357a5737bb: Lift lambda functions into higher scopes with optional inline function inclusion.
// acdaa6541ebd075c38b16fddc14104f1: Specify an item as publicly accessible to friends with 'public(friend)'.
