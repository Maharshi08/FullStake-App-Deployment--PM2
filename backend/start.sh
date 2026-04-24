#!/bin/bash
# Wrapper script to activate venv and run gunicorn

cd "$(dirname "$0")"
source venv/bin/activate
exec gunicorn -w 2 -b 127.0.0.1:8010 app:app
