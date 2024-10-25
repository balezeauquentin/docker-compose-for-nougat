FROM nvidia/cuda:12.1.0-base-ubuntu22.04

# Install system dependencies
RUN apt-get update && \
    apt-get install -y git python3 python3-pip wget

RUN wget https://github.com/facebookresearch/nougat/releases/download/0.1.0-base/config.json -P /app/models/base/
RUN wget https://github.com/facebookresearch/nougat/releases/download/0.1.0-base/pytorch_model.bin -P /app/models/base/
RUN wget https://github.com/facebookresearch/nougat/releases/download/0.1.0-base/special_tokens_map.json -P /app/models/base/
RUN wget https://github.com/facebookresearch/nougat/releases/download/0.1.0-base/tokenizer.json -P /app/models/base/
RUN wget https://github.com/facebookresearch/nougat/releases/download/0.1.0-base/tokenizer_config.json -P /app/models/base/


# Set the working directory to /app
WORKDIR /app

# Copy all files from current directory to /app in the container
COPY . /app

# Install the Python package via setup.py
RUN python3 setup.py install

RUN pip3 install torch torchvision torchaudio
# Install Python dependencies
RUN pip3 install transformers==4.38.2 \
    huggingface-hub==0.23.5 fastapi uvicorn[standard] \
    fsspec[http]==2023.5.0 multiprocess==0.70.15 python-multipart --no-cache-dir

# Expose the port your app will run on
EXPOSE 8503

# Start the FastAPI app using Uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8503"]
