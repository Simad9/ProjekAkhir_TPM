import random
from locust import HttpUser, task, between


class HafalanAppUser(HttpUser):
    wait_time = between(1, 3)
    host = "https://equran.id/api/v2"

    @task(3)
    def get_all_surat(self):
        with self.client.get("/surat", name="/surat", catch_response=True) as response:
            if response.status_code == 200:
                try:
                    json_data = response.json()
                    if "data" in json_data and isinstance(json_data["data"], list) and len(json_data["data"]) > 0:
                        response.success()
                    else:
                        response.failure(f"Invalid or empty 'data' in response: {json_data}")
                except ValueError:
                    response.failure("Invalid JSON response")
            else:
                response.failure(f"GET /api/surat failed with status code {response.status_code}")

    @task(2)
    def get_random_surat_detail(self):
        surat_nomor = random.randint(1, 114)
        with self.client.get(f"/surat/{surat_nomor}", name="/surat/[nomor]", catch_response=True) as response:
            if response.status_code == 200:
                try:
                    json_data = response.json()
                    if "data" in json_data and isinstance(json_data["data"], dict) and "nomor" in json_data["data"]:
                        response.success()
                    else:
                        response.failure(f"Invalid or missing 'data' in response: {json_data}")
                except ValueError:
                    response.failure("Invalid JSON response")
            elif response.status_code == 404:
                response.success()
            else:
                response.failure(f"GET /api/surat/[nomor] failed with status code {response.status_code}")
