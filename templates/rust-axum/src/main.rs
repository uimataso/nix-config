use std::net;

use anyhow::Context as _;
use axum::{Router, routing::get};
use tracing::{info, warn};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    setup_tracing();

    let addr = net::SocketAddrV4::new(net::Ipv4Addr::UNSPECIFIED, 8080);

    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .with_context(|| format!("failed to listen on address: {}", addr))?;

    let router = router();
    let router = add_tracing_layer(router);

    info!("serve http api at {}", addr);

    axum::serve(listener, router)
        .await
        .context("failed to serve")?;

    Ok(())
}

fn router() -> axum::Router {
    Router::new().route("/", get(todo))
}

async fn todo() -> &'static str {
    "unimplemented"
}

fn setup_tracing() {
    use tracing_subscriber::layer::SubscriberExt as _;
    use tracing_subscriber::util::SubscriberInitExt as _;

    let default_env =
        tracing_subscriber::EnvFilter::try_from_default_env().unwrap_or_else(|error| {
            warn!(?error, "failed to read RUST_LOG, using default");
            "debug,hyper=off,sqlx=off".into()
        });

    let fmt_layer = tracing_subscriber::fmt::layer()
        .with_line_number(true)
        .pretty();

    tracing_subscriber::registry()
        .with(default_env)
        .with(fmt_layer)
        .init();
}

pub fn add_tracing_layer(router: axum::Router) -> axum::Router {
    use axum::http::header;
    use tower_http::ServiceBuilderExt as _;
    use tower_http::sensitive_headers::SetSensitiveHeadersLayer;
    use tower_http::trace;

    let trace_layer = trace::TraceLayer::new_for_http();

    let layer = tower::ServiceBuilder::new()
        .set_x_request_id(tower_http::request_id::MakeRequestUuid)
        .layer(SetSensitiveHeadersLayer::new([
            header::AUTHORIZATION,
            header::PROXY_AUTHORIZATION,
            header::COOKIE,
            header::SET_COOKIE,
        ]))
        .layer(trace_layer)
        .propagate_x_request_id();

    router.layer(layer)
}
