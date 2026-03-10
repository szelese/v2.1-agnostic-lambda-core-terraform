def process_data(payload: dict) -> dict:
    user = payload.get("user", "Pilot")
    # environment-agnostic logic with no external dependencies
    return {
        "message": f"Hello {user}! Hello, CI/CD GitHubActions, AWS! All OK!",
        "status": "works", 
        "engine_version": "3.12.3",
        "subsystem": "v2.1-agnostic-lambda-core-terraform"
    }