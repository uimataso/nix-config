#![warn(clippy::pedantic, clippy::nursery)]
#![allow(
    clippy::missing_panics_doc,
    clippy::must_use_candidate,
    clippy::redundant_closure_for_method_calls
)]

use dotenv::dotenv;
use sqlx::{postgres::PgPoolOptions, Pool, Postgres};
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

use crate::prelude::*;

mod error;
mod handler;
mod prelude;

#[tokio::main]
#[allow(clippy::missing_errors_doc)]
pub async fn main() -> Result<()> {
    dotenv().ok();

    tracing_subscriber::registry()
        .with(tracing_subscriber::fmt::layer())
        .init();

    let state = AppState::new().await;

    let app = axum::Router::new()
        .merge(handler::router())
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;

    tracing::info!("listening on {}", listener.local_addr()?);
    axum::serve(listener, app).await?;

    Ok(())
}

#[derive(Clone)]
struct AppState {
    db_pool: Pool<Postgres>,
}

impl AppState {
    async fn new() -> Self {
        let db_url = std::env::var("DATABASE_URL").unwrap();
        let db_pool = PgPoolOptions::new()
            .max_connections(5)
            .connect(&db_url)
            .await
            .unwrap();

        Self { db_pool }
    }
}
