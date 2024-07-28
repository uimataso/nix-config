use axum::{
    extract::{rejection::FormRejection, Json},
    http::StatusCode,
    response::{IntoResponse, Response},
};
use serde::Serialize;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum Error {
    #[error(transparent)]
    IO(#[from] std::io::Error),
    #[error(transparent)]
    AxumFormRejection(#[from] FormRejection),
    #[error(transparent)]
    SqlxError(#[from] sqlx::Error),
}

#[derive(Serialize)]
struct ErrorJsonResponse {
    message: String,
}

impl IntoResponse for Error {
    fn into_response(self) -> Response {
        match self {
            _ => (
                StatusCode::BAD_REQUEST,
                Json(ErrorJsonResponse {
                    message: self.to_string(),
                }),
            ),
        }
        .into_response()
    }
}
