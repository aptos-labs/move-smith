use arbitrary::Unstructured;
use framework::Framework;
use generators;
use log::debug;

pub struct MoveSmith {
    framework: Framework,
}

impl MoveSmith {
    pub fn new() -> Self {
        let framework = Framework::new();
        MoveSmith { framework }
    }

    pub fn generate(&self, data: &[u8]) -> String {
        let u = &mut Unstructured::new(data);
        let ast = self.framework.generate_program(u).unwrap();
        debug!("Final Env:\n{:#?}", self.framework.env.borrow());
        println!("The generated program:");
        format!("{:#?}", ast)
    }
}
