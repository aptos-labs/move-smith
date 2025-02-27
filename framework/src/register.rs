pub trait Register<Entry> {
    fn register(&self) -> Entry;
}
