//! # i386 emulator
//! TODO: write a documentation

use super::super::config::Config;
mod Core;
use Core::State;
use super::super::binary;

pub fn run (cfg: &Config, filename: &str) {
    fn main_loop (st: State) {
        println!("{}", st.to_string())
    };
    let bin = binary::load(filename);
    let ist = State::init()
        .set_mem_size(1024 * 1024)
        .set_eip(0x7c00)
        .set_esp(0x7c00);
    main_loop(ist);
}


#[test]
fn test_run() {
    // write an unit test
    assert!(true);
}
