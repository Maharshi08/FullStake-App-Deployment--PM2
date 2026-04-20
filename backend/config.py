# Configuration file for Flask app

class Config:
    DEBUG = False
    TESTING = False
    SECRET_KEY = 'your-secret-key'  # Change in production

class DevelopmentConfig(Config):
    DEBUG = True

class ProductionConfig(Config):
    DEBUG = False
    # Add production settings here