# web_learner

Flutter client scaffold for a study and exam platform driven by non-standard web APIs.

This repository is intentionally structured for the API shape described in the local `docs/` folder:
- Cookie-based session authentication
- form-urlencoded requests
- custom request encoding
- HTML payload entry points
- multi-step business flows such as question-bank selection

The current codebase is not a finished product. It is a runnable industrial-style scaffold that prepares the project for real integration work without forcing a later rewrite.

## Current Status

Implemented now:
- `app / core / features` application structure
- Riverpod-based application wiring
- GoRouter-based login and shell routing
- first-pass feature boundaries for auth, home, profile, question bank, reading, check-in, daily points, and exam modules
- placeholder question-bank flow model that supports mixed child nodes instead of assuming "year only"
- basic test skeleton

Not implemented yet:
- real login API integration
- Cookie session persistence
- request encoder and HTML parsing pipeline
- real question-bank selection flow
- reading, points, check-in, profile, mobile-exam, and mock-exam business logic

## Project Structure

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router/
    theme/
  core/
    config/
    di/
    errors/
    logging/
    network/
    session/
    storage/
  features/
    auth/
    checkin/
    daily_points/
    exam_core/
    home/
    mobile_exam/
    mock_exam/
    profile/
    question_bank/
    reading/
    shell/
```

### Layer Rules

`app`
- owns application composition
- owns router and theme
- does not own business APIs

`core`
- owns cross-feature capabilities
- should hold shared infrastructure such as environment, storage contracts, logging, encoding, networking, and parsing
- should not absorb feature-specific business flows

`features`
- each business module owns its own domain, application, and presentation logic
- feature-specific API adaptation belongs inside the feature, not in `core`

## Routing

Current navigation flow:
- `/login`
- shell route with:
  - `/home`
  - `/question-bank`
  - `/profile`

The router already enforces authenticated vs unauthenticated entry flow.

## Question-Bank Modeling Direction

The local API docs describe a real flow closer to:

```text
unit -> top category -> child node -> exam type list -> save selection
```

The important part is that the child node layer is not modeled as "year only".  
The scaffold already supports:
- branch nodes
- year nodes
- mixed nodes

This prevents a future rewrite when the backend returns intermediate categories and years in the same layer.

## Testing

Current test baseline covers:
- domain modeling assumptions
- auth repository behavior
- app smoke boot

Run:

```bash
flutter analyze
flutter test
```

## Next Recommended Steps

1. replace the mock auth repository with the real login API implementation
2. add core request encoding and session persistence abstractions
3. implement the full question-bank flow from the docs
4. add fixture-based parser and repository tests for every real API document

## Notes

- `docs/` is intentionally ignored from Git in this repository.
- the old local project at `E:\web_learner` can still serve as a reference, but this repository is now the clean scaffold to continue from.
