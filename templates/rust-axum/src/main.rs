mod app;
mod utils;

use std::net;

use anyhow::Context as _;
use tracing::info;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    utils::setup_tracing();

    let addr = net::SocketAddrV4::new(net::Ipv4Addr::UNSPECIFIED, 8080);

    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .with_context(|| format!("failed to listen on address: {}", addr))?;

    let router = app::router();
    let router = utils::add_tracing_layer(router);

    info!("serve http api at {}", addr);

    axum::serve(listener, router)
        .with_graceful_shutdown(utils::shutdown_signal())
        .await
        .context("failed to serve")?;

    info!("serve ended");

    Ok(())
}
