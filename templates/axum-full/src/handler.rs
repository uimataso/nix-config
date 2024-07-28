use axum::{
    extract::State,
    http::StatusCode,
    response::IntoResponse,
    routing::{get, post},
    Json,
};
use serde::{Deserialize, Serialize};
use sqlx::types::{time::PrimitiveDateTime, Uuid};
use tracing::warn;

use crate::AppState;

pub fn router() -> axum::Router<AppState> {
    axum::Router::new()
        .route("/hello", get(get_hello))
        .route("/insert", post(insert_user))
        .fallback(fallback)
}

pub async fn fallback() -> impl IntoResponse {
    (StatusCode::NOT_FOUND, "404 Not Found")
}

pub async fn get_hello() -> impl IntoResponse {
    (StatusCode::OK, "Hello")
}

#[derive(Deserialize)]
pub struct InsertUserRequest {
    username: String,
    password: String,
}

struct InsertUserDBResponse {
    sub: Uuid,
    username: String,
    bcrypt_password: String,
    created_at: PrimitiveDateTime,
    updated_at: PrimitiveDateTime,
}

#[derive(Serialize)]
struct InsertUserResponse {
    sub: String,
    username: String,
    bcrypt_password: String,
    created_at: String,
    updated_at: String,
}

pub async fn insert_user(
    State(state): State<AppState>,
    Json(request): Json<InsertUserRequest>,
) -> impl IntoResponse {
    let result = sqlx::query_as!(
        InsertUserDBResponse,
        "
            INSERT INTO users (username, bcrypt_password)
            VALUES ($1, $2)
            RETURNING *;
        ",
        request.username,
        request.password,
    )
    .fetch_one(&state.db_pool)
    .await;

    match result {
        Ok(res) => (
            StatusCode::OK,
            Json(InsertUserResponse {
                sub: res.sub.to_string(),
                username: res.username,
                bcrypt_password: res.bcrypt_password,
                created_at: res.created_at.to_string(),
                updated_at: res.updated_at.to_string(),
            }),
        )
            .into_response(),
        Err(err) => {
            warn!("{:?}", err);
            StatusCode::BAD_REQUEST.into_response()
        }
    }
}
