// src/smartptr.rs
// ScrapeC Smart Pointers and Collections (Stub)

pub struct Boxed<T> {
    value: T,
}

impl<T> Boxed<T> {
    pub fn new(value: T) -> Self {
        Boxed { value }
    }
}
