import { Controller } from "@hotwired/stimulus"
import QrScanner from "qr-scanner"

export default class extends Controller {
  static targets = ["video", "result", "startScanner", "stopScanner", "details", "overlay"];
  connect() {
    console .log("QR Scanner connected");
    this.startScannerTarget.addEventListener('click', () => this.initializeScanner());
    this.stopScannerTarget.addEventListener('click', () => this.stopScanner());
    console .log("QR Scanner initialized");
  }

  async initializeScanner() {
    try {
      const videoPlayer = this.videoTarget;
      const overLayDiv = this.overlayTarget;
      console.log("Overlay div: ", overLayDiv);
      this.detailsTarget.classList.add("hidden");
      this.videoTarget.classList.remove('hidden');
      this.overlayTarget.classList.remove('hidden');
      this.startScannerTarget.classList.add('hidden');
      this.stopScannerTarget.classList.remove('hidden');

      this.scanner = new QrScanner(
          videoPlayer,
          result => this.handleScan(result),
          {
            maxScansPerSecond:1,
            highlightScanRegion:  true ,
            highlightCodeOutline: true,
            overlay: overLayDiv,
            returnDetailedScanResult: true
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
          this.stopScanner()
          this.disconnect();
        })
        .catch(error => {
          console .log("!!!!!!!!!  SOMETHING WENT WRONG !!!!!!!!!\n");
          console.error('Error:', error);
          console .log("!!!!!!!!!  ERROR ABOVE  !!!!!!!!!\n");
          this.resultTarget.textContent = "Failed to process check-in";
          this.resultTarget.classList.add('text-red-500');
          this.stopScanner()
          this.disconnect();
        })
  }

  stopScanner() {
    if (this.scanner) {
      this.scanner.stop();
      this.overlayTarget.classList.add('hidden');
      this.videoTarget.classList.add('hidden');
      this.detailsTarget.classList.remove('hidden');
      this.startScannerTarget.classList.remove('hidden');
      this.stopScannerTarget.classList.add('hidden');
    }
  }

  disconnect() {
    if (this.scanner) {
      this.scanner.destroy()
      this.scanner = null;
    }
    this.detailsTarget.classList.remove("hidden");
  }
}
