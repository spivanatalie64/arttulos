// src/traits.rs
// ScrapeC Traits, Generics, and Type Classes (Stub)

pub trait Addable<T> {
    fn add(&self, other: &T) -> T;
}

impl Addable<i64> for i64 {
    fn add(&self, other: &i64) -> i64 {
        *self + *other
    }
}
