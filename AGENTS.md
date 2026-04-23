# Repository Guidelines

## Project Structure & Module Organization
This repository is intentionally flat. [`agent.py`](/home/dietpi/projects/agent/agent.py) is the main application and contains the GUI, audio pipeline, wake-word handling, Ollama integration, web search, and vision flow. [`setup.sh`](/home/dietpi/projects/agent/setup.sh) installs OS packages, creates asset folders, downloads Piper assets, and prepares `venv/`. [`start_agent.sh`](/home/dietpi/projects/agent/start_agent.sh) is the simplest launch entrypoint.

Runtime assets live under `faces/` and `sounds/`, grouped by state such as `faces/idle/` or `sounds/error_sounds/`. Treat `piper/`, `voices/`, `.onnx` files, captured media, and memory files as generated or local-only artifacts unless a change explicitly requires them.

## Build, Test, and Development Commands
Use the existing shell workflow:

- `./setup.sh` installs system and Python dependencies and pulls required models.
- `source venv/bin/activate` activates the local virtual environment.
- `python agent.py` runs the agent directly for development.
- `./start_agent.sh` starts the agent from the repo root with stricter shell settings.
- `python -m py_compile agent.py` performs a quick syntax check before submitting changes.

## Coding Style & Naming Conventions
Follow the existing Python style in `agent.py`: 4-space indentation, `snake_case` for functions and variables, `PascalCase` for classes, and `UPPER_CASE` for module constants like `DEFAULT_CONFIG`. Keep imports grouped, prefer small helper functions over deeply nested blocks, and preserve the current inline comment style for hardware- or model-specific logic.

No formatter or linter is configured in-repo. Keep changes consistent with surrounding code and avoid large style-only rewrites.

## Testing Guidelines
There is no automated test suite yet. Validate changes with targeted manual smoke tests: start the app, confirm the Tkinter UI loads, verify a wake-word or push-to-talk path, and test any changed audio, search, or camera behavior. If you add tests later, place them under `tests/` and name files `test_*.py`.

## Commit & Pull Request Guidelines
Recent history uses short imperative subjects such as `Update README.md` and `Update setup.sh`. Keep commit titles brief and specific, for example `Fix input device selection`. PRs should summarize behavior changes, list manual test coverage, mention hardware assumptions, and include screenshots when UI states or face assets change.

## Configuration & Asset Notes
Do not commit personal config or conversation history unnecessarily. Review `.gitignore` before adding assets; large models, generated media, and local memory files are intentionally excluded.
