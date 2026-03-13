use log::info;

fn main() {
    env_logger::builder()
        .filter_level(log::LevelFilter::Info)
        .init();

    info!("Hello, world!");
}

