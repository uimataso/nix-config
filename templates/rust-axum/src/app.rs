use axum::{Router, routing::get};

pub fn router() -> axum::Router {
    Router::new()
        .route("/", get(todo))
        .route("/healthcheck", get(healthcheck))
}

async fn todo() -> &'static str {
    "unimplemented"
}

async fn healthcheck() -> &'static str {
    "healthy"
}
