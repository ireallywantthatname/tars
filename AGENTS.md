# Repository Guidelines

## Project Structure & Module Organization
`agent.py` is the main application entrypoint and currently contains most runtime logic: GUI, audio I/O, wake-word handling, Groq calls, and TTS orchestration. Setup and launch scripts live at the repo root in `setup.sh` and `start_agent.sh`.

Runtime assets are organized by type: `faces/` for state-based PNG sequences, `sounds/` for grouped WAV effects, `voices/` for custom voice models, and `piper/` for the downloaded Piper runtime. Local state such as `config.json`, `memory.json`, and temporary audio files is generated in the root directory.

## Build, Test, and Development Commands
Use the provided scripts rather than ad hoc setup.

- `./setup.sh` installs system packages, creates `venv/`, downloads Piper assets, and fetches the default wake-word model.
- `source venv/bin/activate && python agent.py` runs the agent directly for development.
- `./start_agent.sh` validates `GROQ_API_KEY` and launches with the project virtualenv.
- `./venv/bin/pip install -r requirements.txt` refreshes Python dependencies after editing `requirements.txt`.

## Coding Style & Naming Conventions
Follow existing Python style in `agent.py`: 4-space indentation, `snake_case` for functions and variables, `UPPER_SNAKE_CASE` for constants, and small helper functions for hardware or config concerns. Keep comments sparse and practical.

Asset names should stay descriptive and sequence-friendly, for example `faces/thinking/thinking 01.png` or `sounds/ack_sounds/okay.wav`. Shell scripts should remain POSIX-style Bash with `set -euo pipefail` when practical.

## Testing Guidelines
There is no automated test suite in this repository today. Validate changes manually on target hardware:

- run `./start_agent.sh`
- confirm wake-word detection, transcription, chat response, and TTS playback
- verify asset loading for any modified `faces/` or `sounds/` directory

If you add logic that can be isolated from hardware, prefer `pytest` tests under a new `tests/` directory with filenames like `test_config.py`.

## Commit & Pull Request Guidelines
History shows short, imperative subjects with occasional prefixes such as `feat:` and `Fix:`. Prefer that format: `feat: add configurable input device` or `Fix: handle missing Piper model`.

Pull requests should include a concise summary, note any Raspberry Pi or audio hardware used for validation, mention config or asset changes, and attach screenshots for UI/face updates when relevant.

## Security & Configuration Tips
Do not commit secrets. `GROQ_API_KEY` must be provided through the environment, and large generated artifacts such as `piper/`, `.onnx` models, `memory.json`, and temporary media should stay untracked per `.gitignore`.
