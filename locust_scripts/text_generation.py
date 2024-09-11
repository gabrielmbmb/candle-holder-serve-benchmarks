from locust import HttpUser, task, between
import random


class TextGenerationTestUser(HttpUser):
    wait_time = between(0.5, 1)

    @task
    def predict(self) -> None:
        lengths = [50, 100, 250, 500]
        text_length = random.choice(lengths)
        self.client.post(
            "/generate",
            json={"inputs": "The future of AI is", "max_length": text_length},
            headers={"Content-Type": "application/json", "Authorization": "Bearer"},
        )
