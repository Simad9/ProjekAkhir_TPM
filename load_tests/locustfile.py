# locustfile.py

import random
from locust import HttpUser, task, between

class HafalanAppUser(HttpUser):
    # Waktu tunggu acak antara 1 hingga 3 detik antara setiap tugas.
    # Ini mensimulasikan perilaku pengguna yang lebih realistis (tidak terus-menerus meminta).
    wait_time = between(1, 3)

    # --- KONFIGURASI API HOST ---
    # Ganti dengan URL API asli Anda jika tidak menggunakan fake-api
    # Jika menggunakan fake-api Node.js Anda (http://localhost:5000), pastikan servernya berjalan!
    # Jika menggunakan API asli, ganti host sesuai dengan base URL API tersebut.
    # Contoh untuk API asli:
    host = "https://equran.id/api/v2" # Untuk Surat
    # host = "https://doa-doa-api-ahmadramadhan.fly.dev" # Untuk Doa
    # host = "https://api.currencyapi.com/v3" # Untuk Konversi (perlu API key di task-nya)

    # Karena aplikasi Anda menggunakan 3 API yang berbeda, kita akan membagi host
    # menjadi dasar untuk kemudahan. Jika Anda ingin menguji semua API dalam satu run,
    # Anda perlu mengatur `host` ke base URL yang mencakup semua API atau
    # menyesuaikan URL di setiap `task` dengan host penuhnya.
    # Untuk tujuan load testing, kita sering menguji setiap API secara terpisah
    # atau dalam grup jika ada korelasi penggunaan.
    # Mari kita asumsikan kita akan menguji endpoint secara individual atau menggunakan fake-api sebagai satu host.

    # Misal, jika menguji fake-api lokal Anda:
    # host = "http://localhost:5000"

    # --- DAFTAR TUGAS (TASK) UNTUK SIMULASI PENGGUNA ---

    # Task 1: Mengambil semua daftar surat (GET /api/surat)
    @task(3) # Prioritas 3: akan dipanggil lebih sering daripada task dengan prioritas lebih rendah
    def get_all_surat(self):
        # Menggunakan `name` untuk mengelompokkan statistik di laporan Locust
        with self.client.get("/surat", name="/surat", catch_response=True) as response:
            if response.status_code == 200:
                try:
                    json_data = response.json()
                    # Verifikasi respons adalah list dan tidak kosong
                    if "data" in json_data and isinstance(json_data["data"], list) and len(json_data["data"]) > 0:
                        response.success()
                    else:
                        response.failure(f"Invalid or empty 'data' in response: {json_data}")
                except ValueError:
                    response.failure("Invalid JSON response")
            else:
                response.failure(f"GET /api/surat failed with status code {response.status_code}")

    # Task 2: Mengambil detail surat acak (GET /api/surat/{nomor})
    @task(2) # Prioritas 2
    def get_random_surat_detail(self):
        # Asumsi ada 114 surat, jadi pilih nomor acak dari 1 sampai 114
        surat_nomor = random.randint(1, 114)
        # Perhatikan: jika host adalah equran.id, URL akan menjadi
        # f"/api/v2/surat/{surat_nomor}"
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
            elif response.status_code == 404: # Tangani 404 jika ID tidak ditemukan (misal di fake-api hanya ada ID 1)
                response.success() # Anggap 404 valid untuk skenario tertentu jika diharapkan
                # Atau response.failure("Surat not found (404)") jika tidak diharapkan
            else:
                response.failure(f"GET /api/surat/[nomor] failed with status code {response.status_code}")

    # # Task 3: Mengambil semua daftar doa (GET /api)
    # @task(2) # Prioritas 2
    # def get_all_doa(self):
    #     # Perhatikan: jika host adalah doa-doa-api-ahmadramadhan.fly.dev, URL akan menjadi "/"
    #     with self.client.get("/api", name="/api", catch_response=True) as response:
    #         if response.status_code == 200:
    #             try:
    #                 json_data = response.json()
    #                 if isinstance(json_data, list) and len(json_data) > 0: # Doa API langsung mengembalikan list
    #                     response.success()
    #                 else:
    #                     response.failure(f"Invalid or empty list in response: {json_data}")
    #             except ValueError:
    #                 response.failure("Invalid JSON response")
    #         else:
    #             response.failure(f"GET /api failed with status code {response.status_code}")

    # # Task 4: Mengambil detail doa acak (GET /api/{id})
    # @task(1) # Prioritas 1
    # def get_random_doa_detail(self):
    #     # Asumsi ada 37 doa (dari dataDoa.js), jadi pilih ID acak dari 1 sampai 37
    #     doa_id = random.randint(1, 37)
    #     # Perhatikan: jika host adalah doa-doa-api-ahmadramadhan.fly.dev, URL akan menjadi "/{id}"
    #     with self.client.get(f"/api/{doa_id}", name="/api/[id]", catch_response=True) as response:
    #         if response.status_code == 200:
    #             try:
    #                 json_data = response.json()
    #                 if isinstance(json_data, list) and len(json_data) > 0 and "id" in json_data[0]:
    #                     response.success()
    #                 else:
    #                     response.failure(f"Invalid or missing 'id' in response: {json_data}")
    #             except ValueError:
    #                 response.failure("Invalid JSON response")
    #         elif response.status_code == 404: # Tangani 404 jika ID tidak ditemukan (misal di fake-api hanya ada ID 1)
    #             response.success() # Anggap 404 valid jika diharapkan
    #         else:
    #             response.failure(f"GET /api/[id] failed with status code {response.status_code}")

    # # Task 5: Mengambil kurs konversi mata uang (GET /api/konversi/)
    # @task(1) # Prioritas 1
    # def get_currency_rates(self):
    #     # Perhatikan: jika host adalah currencyapi.com, URL akan menjadi
    #     # "/v3/latest?apikey=YOUR_API_KEY&currencies=USD%2CEUR%2CSGD%2CJPY%2CCNY%2CBTC%2CIDR&base_currency=IDR"
    #     # Ganti YOUR_API_KEY dengan API key asli Anda
    #     with self.client.get("/api/konversi/", name="/api/konversi", catch_response=True) as response:
    #         if response.status_code == 200:
    #             try:
    #                 json_data = response.json()
    #                 if "data" in json_data and isinstance(json_data["data"], dict):
    #                     response.success()
    #                 else:
    #                     response.failure(f"Invalid or missing 'data' in response: {json_data}")
    #             except ValueError:
    #                 response.failure("Invalid JSON response")
    #         else:
    #             response.failure(f"GET /api/konversi failed with status code {response.status_code}")