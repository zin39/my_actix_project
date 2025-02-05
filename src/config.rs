use serde::Deserialize;
use std::env;

pub struct Config {
    pub database_url: String,
    pub jwt_secret: String,
    pub aws_access_key_id: String,
    pub aws_secret_access_key: String,
    pub aws_s3_bucket: String,
    pub aws_region: String,
    pub redis_url: Option<String>,
    pub app_env: String,
    pub app_port: u16,
}

impl Config {
    pub fn from_env() -> Result<Self, envy::Error> {
        // Load the .env file if it exists.
        dotenv::dotenv().ok();
        // Deserialize environment variables into our Config struct.
        envy::from_env::<Config>()
    }
}
