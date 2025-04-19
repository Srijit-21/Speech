from flask import Flask, request
import sys
import os

# Add the parent directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from app import app as flask_app

# Vercel serverless handler
def handler(request, response):
    with flask_app.request_context(request.environ):
        return flask_app.full_dispatch_request() 