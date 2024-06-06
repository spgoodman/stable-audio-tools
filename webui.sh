#!/bin/bash
# Start Web UI
#
# Set to limit to particular device
export CUDA_VISIBLE_DEVICES=1
# Set to bind to all IP addresses or leave blank for localhost only
export GRADIO_SERVER_NAME=0.0.0.0
# Set to bind to specific HTTP port, or leave blank for default
export GRADIO_SERVER_PORT=7360
# Set to true to create sharing link
#export GRADIO_SHARE=True
# Model Dir - if not set, will download from Huggingface into cache
export SDAUDIO_MODEL_DIR="../stable-audio-open-1.0"
# Virtual Environment directory
export SDAUDIO_VENV_DIR=".venv"
#
# Change to script directory
cd "$(dirname "$0")"
# Create venv
if [[ ! -d "$SDAUDIO_VENV_DIR" ]] then
	mkdir "$SDAUDIO_VENV_DIR"
	python -m venv "$SDAUDIO_VENV_DIR"
	source "$SDAUDIO_VENV_DIR/bin/activate"
	pip install pip --upgrade
	pip install wheel setuptools
	pip install .
	pip install flash_attn
else
	source "$SDAUDIO_VENV_DIR/bin/activate"
fi
if [[ "$SDAUDIO_MODEL_DIR" ]]
then
	python ./run_gradio.py \
		--model-config "$SDAUDIO_MODEL_DIR/model_config.json" \
		--ckpt-path "$SDAUDIO_MODEL_DIR/model.safetensors"
else
	python ./run_gradio.py \
		--pretrained-name stabilityai/stable-audio-open-1.0
fi
