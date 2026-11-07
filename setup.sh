#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}TARS Setup Script${NC}"

if /usr/bin/python3 -c "import tkinter" >/dev/null 2>&1; then
    PYTHON_BIN="/usr/bin/python3"
else
    PYTHON_BIN="python3"
fi

echo -e "${YELLOW}Using Python interpreter: ${PYTHON_BIN}${NC}"

echo -e "${YELLOW}[1/6] Installing System Tools (apt)...${NC}"
sudo apt update
sudo apt install -y python3-tk python3-dev libasound2-dev portaudio19-dev liblapack-dev libblas-dev cmake build-essential espeak-ng git

echo -e "${YELLOW}[2/6] Creating Folders...${NC}"
mkdir -p piper
mkdir -p voices
mkdir -p sounds/greeting_sounds
mkdir -p sounds/thinking_sounds
mkdir -p sounds/ack_sounds
mkdir -p sounds/error_sounds
mkdir -p faces/idle
mkdir -p faces/listening
mkdir -p faces/thinking
mkdir -p faces/speaking
mkdir -p faces/error
mkdir -p faces/warmup

echo -e "${YELLOW}[3/6] Setting up Piper TTS...${NC}"
ARCH=$(uname -m)
if [ "$ARCH" == "aarch64" ]; then
    wget -O piper.tar.gz https://github.com/rhasspy/piper/releases/download/2023.11.14-2/piper_linux_aarch64.tar.gz
    tar -xvf piper.tar.gz -C piper --strip-components=1
    rm piper.tar.gz
else
    echo -e "${RED}Not on Raspberry Pi (aarch64). Skipping Piper download.${NC}"
fi

echo -e "${YELLOW}[4/6] Downloading Voice Models...${NC}"
cd piper
wget -nc -O en_GB-semaine-medium.onnx https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/semaine/medium/en_GB-semaine-medium.onnx
wget -nc -O en_GB-semaine-medium.onnx.json https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/semaine/medium/en_GB-semaine-medium.onnx.json
cd ..

echo -e "${YELLOW}Downloading voice...${NC}"
curl -L -o voices/bmo-custom.onnx "https://github.com/brenpoly/be-more-agent/releases/latest/download/bmo.onnx"
curl -L -o voices/bmo-custom.onnx.json "https://github.com/brenpoly/be-more-agent/releases/latest/download/bmo.onnx.json"

echo -e "${YELLOW}[5/6] Installing Python Libraries...${NC}"
if [ ! -d "venv" ] || ! ./venv/bin/python -c "import tkinter" >/dev/null 2>&1; then
    echo -e "${YELLOW}Creating virtual environment with ${PYTHON_BIN}...${NC}"
    "${PYTHON_BIN}" -m venv --clear venv
fi
source venv/bin/activate
pip install --upgrade pip
pip install --force-reinstall --no-cache-dir sounddevice
pip install -r requirements.txt

echo -e "${YELLOW}[6/6] Checking Wake Word Model...${NC}"
if [ ! -f "wakeword.onnx" ]; then
    echo -e "${YELLOW}Downloading default 'Hey Jarvis' wake word...${NC}"
    curl -L -o wakeword.onnx https://github.com/dscripka/openWakeWord/raw/main/openwakeword/resources/models/hey_jarvis_v0.1.onnx
fi

echo -e "${GREEN}Setup Complete! Export GROQ_API_KEY, then run 'source venv/bin/activate' and 'python agent.py'.${NC}"
