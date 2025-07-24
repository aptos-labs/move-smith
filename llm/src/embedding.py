from __future__ import annotations

import atexit
import time
from multiprocessing import Process, Queue
from typing import Union

import torch
from loguru import logger
from sentence_transformers import SentenceTransformer

model = None


def load_embedding_model() -> None:
    global model
    if model is None:
        model = ModelClient()


def encode_text(text: str) -> list[float]:
    global model
    if model is None:
        model = ModelClient()
    return model.encode(text)


def similarity_score(left: Union[str, list[str]], right: Union[str, list[str]]) -> float:
    """
    Calculate embedding of (1) union of left (2) each string in right.
    Return the sum of similarities between left embedding and each right embedding.
    """
    global model
    if model is None:
        model = ModelClient()

    if isinstance(left, list):
        left_text = "\n".join(left)
    else:
        left_text = left

    if isinstance(right, str):
        right_texts = [right]
    else:
        right_texts = right
    left_embedding = model.encode(left_text)
    right_embeddings = [model.encode(text) for text in right_texts]
    similarities = [
        torch.nn.functional.cosine_similarity(torch.tensor(left_embedding), torch.tensor(right_embedding), dim=0).item()
        for right_embedding in right_embeddings
    ]
    return sum(similarities)


def close_embedding_model() -> None:
    global model
    if model is not None:
        model.close()
        model = None


atexit.register(close_embedding_model)


class ModelClient:
    def __init__(self) -> None:
        self.request_q = Queue()
        self.response_q = Queue()
        self.proc = Process(target=self._model_server, args=(self.request_q, self.response_q))
        self.proc.start()

    def _model_server(self, request_q, response_q) -> None:
        device = "cuda" if torch.cuda.is_available() else "cpu"
        logger.info(f"Loading embedding model on device: {device}")
        start = time.perf_counter()
        model = SentenceTransformer("all-mpnet-base-v2", device=device)
        logger.trace(f"Time taken to load model: {time.perf_counter() - start} seconds")
        while True:
            text = request_q.get()
            if text == "__EXIT__":
                break
            response_q.put(model.encode(text, normalize_embeddings=True).tolist())

    def encode(self, text: str) -> list[float]:
        self.request_q.put(text)
        return self.response_q.get()

    def close(self) -> None:
        self.request_q.put("__EXIT__")
        self.proc.join()
