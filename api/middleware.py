from fastapi import Request, HTTPException, Response
from starlette.middleware.base import BaseHTTPMiddleware

# Define allowed domains
ALLOWED_DOMAINS = ["v1.dev.recordtimeapp.com.au/", "v1.dev.recordtimeapp.com.au"]

# Custom middleware to check request domain
class DomainFilterMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Get the Host header
        host = request.headers.get("host")
        print(request.headers)
        
        # Check if host is null, check if the host ends with any of the allowed domains
        if host and any(host.endswith(domain) for domain in ALLOWED_DOMAINS):
            # Proceed if the domain is allowed
            response = await call_next(request)
            return response
        else:
            # Block if the domain is not allowed
            return Response("Forbidden Domain", status_code=403)