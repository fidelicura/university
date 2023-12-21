# Build

To build this in WASM, follow this guide:
1) Install [trunk](https://trunkrs.dev/) via `cargo install --locked trunk`;
2) Install WASM target for Rust via `rustup target add wasm32-unknown-unknown`;
3) Execute `trunk build`;
4) Copy `assets` folder to `dist` folder;
5) Run `run.sh` script (you'll need Python);
