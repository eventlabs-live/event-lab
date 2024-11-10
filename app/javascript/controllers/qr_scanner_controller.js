import { Controller } from "@hotwired/stimulus"
import QrScanner from "qr-scanner"
// import { BrowserQRCodeReader } from "@zxing/library"
// Connects to data-controller="qr-scanner"
// app/javascript/controllers/qr_scanner_controller.js

export default class extends Controller {
  static targets = ["video", "result", "startScanner"]

  connect() {
    console .log("QR Scanner connected");
    this.startScannerTarget.addEventListener('click', () => this.initializeScanner());
    console .log("QR Scanner initialized");
  }

  async initializeScanner() {
    try {
      this.videoTarget.classList.remove('hidden');
      this.scanner = new QrScanner(
          this.videoTarget,
          result => this.handleScan(result),
          {
            highlightScanRegion: true,
            highlightCodeOutline: true,
          }
      )
      await this.scanner.start()
    } catch (error) {
      console.error('Failed to start scanner:', error)
    }
  }

  handleScan(result) {
    console.log("***********");
    console.log("Scanned result: ", result)
    console.log("***********");
    const barcodeData = result.data;
    const checkInUrl = "/check_ins";
    console .log("Fetching check-in URL: ", checkInUrl);
    fetch(checkInUrl, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      credentials: 'same-origin',
      body: JSON.stringify({ barcode: barcodeData })
    })
        .then(response => response.json())
        .then(data => {
          console .log("!!!!!!!!  RESPONSE RECEIVED  !!!!!!!!!\n");
            console.log(data);
          this.resultTarget.textContent = "SUCCESS = TRUE";
          this.resultTarget.classList.add(data.success ? 'text-green-500' : 'text-red-500');
          this.disconnect();
        })
        .catch(error => {
          console .log("!!!!!!!!!  SOMETHING WENT WRONG !!!!!!!!!\n");
          console.error('Error:', error);
          console .log("!!!!!!!!!  ERROR ABOVE  !!!!!!!!!\n");
          this.resultTarget.textContent = "Failed to process check-in";
          this.resultTarget.classList.add('text-red-500');
          this.disconnect();
        })
  }
  disconnect() {
    if (this.scanner) {
      this.scanner.destroy()
    }
  }
}
