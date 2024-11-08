use rand::{rngs::StdRng, Rng, SeedableRng};

mod msmith;

pub fn main() {
    env_logger::init();
    let mut rng = StdRng::seed_from_u64(123);
    let mut buffer = vec![0u8; 4096];
    rng.fill(&mut buffer[..]);
    let ms = msmith::MoveSmith::new();
    println!("{}", ms.generate(&buffer));
}
