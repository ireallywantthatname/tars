# Project Context: TARS

## Overview
TARS is a physical voice agent and reactive display interface built for Raspberry Pi (Pi 4 and Pi 5). Inspired by the TARS robot, it combines offline wake-word detection with OpenWakeWord, speech transcription via local `whisper.cpp` or Groq Whisper, streaming LLM chat completions and tool execution via the Groq API (`llama-3.1-8b-instant`), on-device neural speech synthesis with Piper TTS, ESP32 USB serial room temperature sensing, and a fullscreen animated Tkinter interface (`800x480`) with state-driven sound effects.

## Tech Stack
- **Language & Platform**: Python 3.9+ targeting Raspberry Pi OS (`aarch64` on Raspberry Pi 4 / 5)
- **Wake-Word Detection**: Offline OpenWakeWord using `.onnx` models (`wakeword.onnx`, defaulting to `hey_jarvis_v0.1.onnx`)
- **Speech-to-Text (STT)**: Local `whisper.cpp` (`./whisper.cpp/build/bin/whisper-cli`) when compiled, or remote Groq Whisper (`whisper-large-v3-turbo`)
- **LLM & Tool Calling**: Groq API (`llama-3.1-8b-instant`) for low-latency chat responses and tool invocation
- **Text-to-Speech (TTS)**: On-device Piper TTS (`aarch64` binary with `.onnx` voice models such as `piper/en_GB-semaine-medium.onnx`)
- **Audio I/O**: `sounddevice` with automatic microphone and speaker sample-rate querying and resampling
- **Display & UI**: Fullscreen Tkinter GUI (`800x480`) rendering animated PNG frame sequences from `faces/<state>/`
- **Web Search & Hardware Integrations**: DuckDuckGo (`duckduckgo-search`) for live web/news lookup and `pyserial` for reading room temperature in Celsius from an ESP32 over USB serial (`/dev/ttyACM*` or `/dev/ttyUSB*`)

## Architecture & Runtime Pipeline
1. **Wake Word / Push-to-Talk**: Continuously listens for the offline wake word via OpenWakeWord, or starts recording manually when the user presses `Return`.
2. **Audio Capture & Resampling**: Captures audio from the configured USB microphone via `sounddevice` and resamples frames to match the active wake-word and transcription models.
3. **Speech Transcription**: Transcribes recorded audio locally via `whisper-cli` if available, or sends it to Groq `whisper-large-v3-turbo`.
4. **LLM & Tool Execution**: Sends the prompt and optional persistent conversation history (`memory.json`) to Groq (`llama-3.1-8b-instant`). Supports tool calls for:
   - Live web and news search via DuckDuckGo when current information is needed.
   - Room temperature measurement by sending `TEMP\n` over USB serial to an ESP32 and parsing `TEMP_C:<number>` responses.
5. **Speech Synthesis & Sound Effects**: Synthesizes the assistant response on-device with Piper TTS, resamples to the speaker sample rate, and plays randomized WAV sound effects from `sounds/` (`greeting_sounds`, `thinking_sounds`, `ack_sounds`, `error_sounds`). Pressing `Space` interrupts active speech playback.
6. **Reactive Face Animations**: Cycles sorted `800x480` PNG sequences from `faces/` across seven states: `warmup`, `idle`, `listening`, `capturing`, `thinking`, `speaking`, and `error`.

## Project Structure
- `agent.py`: Main application entrypoint orchestrating Tkinter GUI, audio I/O, wake-word detection, STT, Groq LLM/tool calls, ESP32 serial queries, and Piper TTS playback.
- `setup.sh`: Provisioning script that installs apt packages, creates `venv/`, installs `requirements.txt`, downloads the `aarch64` Piper runtime and default voice models, and fetches `wakeword.onnx`.
- `start_agent.sh` & `tars.desktop`: Launch script and desktop autostart entry.
- `config.json`: Runtime configuration for models (`text_model`, `vision_model`, `transcription_model`, `voice_model`), `chat_memory`, `camera_rotation`, `system_prompt_extras`, audio device/sample rate, and ESP32 serial settings (`sensor_serial_port`, `sensor_serial_baud`, `sensor_serial_timeout`).
- `faces/`: State-based PNG animation sequences (`capturing/`, `error/`, `idle/`, `listening/`, `speaking/`, `thinking/`, `warmup/`).
- `sounds/`: Categorized WAV sound effects (`greeting_sounds/`, `thinking_sounds/`, `ack_sounds/`, `error_sounds/`).
- `voices/` & `piper/`: Piper TTS runtime and ONNX voice models.
