# TARS

A customizable voice agent for Raspberry Pi.

![Python](https://img.shields.io/badge/Python-3.9%2B-blue) ![Platform](https://img.shields.io/badge/Platform-Raspberry%20Pi-red) ![License](https://img.shields.io/badge/License-MIT-green)

This project turns a Raspberry Pi into a conversational AI agent. It listens for a wake word, processes speech, sends chat requests to the Groq API, and speaks back with a low-latency neural voice while displaying reactive face animations.

You can swap the face images and sound effects to create your own character.

## Features

* Groq-powered chat: Uses the Groq API for fast text responses with `llama-3.1-8b-instant` by default.
* Open source wake word: Wakes up to your custom model using OpenWakeWord offline.
* Hardware-aware audio: Detects your microphone sample rate and resamples audio on the fly.
* Web search: Uses DuckDuckGo to find real-time information when the model does not have the answer.
* USB sensor queries: Reads room temperature from an attached ESP32 over serial.
* Reactive faces: Updates the interface based on state (listening, thinking, speaking, idle).
* Fast text-to-speech: Uses Piper TTS for local voice synthesis on the Pi.
* Speech-to-text fallback: Uses local `whisper.cpp` when installed, or Groq transcription when it is not.

## Hardware requirements

* Raspberry Pi 5 or Pi 4 (4GB RAM minimum)
* USB microphone and speaker
* LCD screen (DSI or HDMI)

## Project structure

```text
tars/
├── agent.py
├── setup.sh
├── wakeword.onnx
├── config.json
├── memory.json
├── requirements.txt
├── whisper.cpp/
├── piper/
├── sounds/
│   ├── greeting_sounds/
│   ├── thinking_sounds/
│   ├── ack_sounds/
│   └── error_sounds/
└── faces/
    ├── idle/
    ├── listening/
    ├── thinking/
    ├── speaking/
    ├── error/
    └── warmup/
```

## Installation

### 1. Prerequisites
Ensure your Raspberry Pi OS is up to date:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git -y
```

### 2. Clone and setup
```bash
git clone https://github.com/ireallywantthatname/tars.git
cd tars
chmod +x setup.sh
./setup.sh
```

### 3. Configure Groq
Export your Groq API key before running the agent:
```bash
export GROQ_API_KEY="your_api_key_here"
```

### 4. Configure the wake word
The setup script downloads a default wake word ("Hey Jarvis"). To use your own:
1. Train a model at [OpenWakeWord](https://github.com/dscripka/openWakeWord).
2. Place the `.onnx` file in the root folder.
3. Rename it to `wakeword.onnx`.

### 5. Run the agent
```bash
source venv/bin/activate
python agent.py
```

## Configuration (`config.json`)

You can modify hardware settings and personality options in `config.json`:

```json
{
    "text_model": "llama-3.1-8b-instant",
    "vision_model": null,
    "transcription_model": "whisper-large-v3-turbo",
    "voice_model": "piper/en_GB-semaine-medium.onnx",
    "chat_memory": true,
    "camera_rotation": 0,
    "system_prompt_extras": "You are TARS, a helpful assistant. Keep responses short.",
    "sensor_serial_port": null,
    "sensor_serial_baud": 115200,
    "sensor_serial_timeout": 2.0
}
```

### ESP32 temperature sensor protocol

The Pi queries the ESP32 serial port directly for temperature readings:

* Pi request: `TEMP` followed by a newline
* ESP32 response: `TEMP_C:<number>` followed by a newline
* Example response: `TEMP_C:26.4`

If `sensor_serial_port` is `null`, the agent auto-detects the first matching `/dev/ttyACM*` or `/dev/ttyUSB*` device.

## Customizing character assets

1. Faces: Place PNG sequences in `faces/[state]/`. The script loops through all images in the folder.
2. Sounds: Place `.wav` files in `sounds/[category]/`. TARS selects one file at random for each state.

## Troubleshooting

* Web search fails: Ensure `duckduckgo-search` is installed in the virtual environment.
* Temperature sensor not found: Ensure the ESP32 is connected over USB, `pyserial` is installed, and baud rates match.
* Missing API key: Export `GROQ_API_KEY` before running `python agent.py` or `./start_agent.sh`.
* Playback speed mismatch: Match the sample rate in your voice model JSON configuration to `PIPER_RATE` in `agent.py`.

## License
MIT License. See [LICENSE](LICENSE) for details.
