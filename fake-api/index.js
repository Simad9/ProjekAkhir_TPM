// file: server.js
const express = require("express");
const cors = require("cors");
const data = require("./data/surat.js");
const dataSuratSatu = require("./data/detailSuratSatu.js");
const dataKonversi = require("./data/dataKonversi.js");
const dataDoa = require("./data/dataDoa.js");
const dataDoaSatu = require("./data/dataDoaSatu.js");

const app = express();
const port = 5000;

app.use(cors());
app.use(express.json());

// Endpoint GET semua surat
app.get("/api/surat", (req, res) => {
  res.status(200).json(data);
});

app.get("/api/surat/:nomor", (req, res) => {
  const nomor = parseInt(req.params.nomor);
  if (nomor != 1) return res.status(404).send("Surat tidak ditemukan");
  res.status(200).json(dataSuratSatu);
});

app.get("/api/konversi/", (req, res) => {
  res.status(200).json(dataKonversi);
});

app.get("/api", (req, res) => {
  res.status(200).json(dataDoa);
});

app.get("/api/:id", (req, res) => {
  const id = parseInt(req.params.id);
  if (id != 1) return res.status(404).send("Surat tidak ditemukan");
  res.status(200).json(dataDoaSatu);
});

app.listen(port, () => {
  console.log(`Server berjalan di http://localhost:${port}`);
});
