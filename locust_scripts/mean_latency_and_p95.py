from locust import HttpUser, task, constant
from datasets import load_dataset


class LatencyTestUser(HttpUser):
    wait_time = constant(1)

    def on_start(self) -> None:
        self.dataset = load_dataset(
            "zeroshot/twitter-financial-news-sentiment", split="train"
        )
        self.batch_size = 1

    @task
    def predict(self) -> None:
        for rows in self.dataset.iter(self.batch_size):
            self.client.post(
                "/",
                json={"inputs": rows["text"]},
                headers={"Content-Type": "application/json", "Authorization": "Bearer"},
            )
