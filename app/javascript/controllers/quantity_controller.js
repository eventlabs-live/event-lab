import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="quantity"
export default class extends Controller {
  static targets = ["quantity"];

  connect() {
    console.log(this.qauntityTarget);
  }
  increment() {
    console.log("increment");
    let quantity = parseInt(this.quantityTarget.value);
    this.quantityTarget.value = quantity + 1;
  }

  decrement() {
    console.log("decrement");
    let quantity = parseInt(this.quantityTarget.value);
    if (quantity > 0) {
      this.quantityTarget.value = quantity - 1;
    }
  }
}
