pub struct Scope {
    pub name: String,
    pub parent: Option<Box<Scope>>,
}
