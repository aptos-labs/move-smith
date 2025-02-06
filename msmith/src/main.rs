use msmith::{
    execution::{
        transactional::{TransactionalExecutor, TransactionalInputBuilder, TransactionalResult},
        ExecutionManager,
    },
    MoveSmith, Variant,
};
use rand::{rngs::StdRng, Rng, SeedableRng};

pub fn main() {
    env_logger::init();
    let mut rng = StdRng::seed_from_u64(123);
    let mut buffer = vec![0u8; 4096];
    rng.fill(&mut buffer[..]);
    // let ms = MoveSmith::new();
    let ms = MoveSmith::variant(Variant::FlushWrites);
    let code = ms.generate(&buffer).unwrap();
    println!("{}", code);
    // let input = TransactionalInputBuilder::new().set_code(&code).build();
    // let executor = ExecutionManager::<TransactionalResult, TransactionalExecutor>::new();
    // let result = executor.execute(&input);
    // println!("{:?}", result);
}
