import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
// app/javascript/controllers/tabs_controller.js
// import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  connect() {
    console.log("Connected to tabs controller")
    this.showTab(this.tabTargets[0])
  }

  show(event) {
    console.log("Clicked tab", event.currentTarget)
    event.preventDefault()
    this.showTab(event.currentTarget)
  }

  showTab(tab) {
    console.log("Showing tab", tab)
    this.tabTargets.forEach(t => t.classList.remove("border-l", "border-t", "border-r", "rounded-t", "text-blue-700"))
    this.contentTargets.forEach(c => c.classList.add("hidden"))

    tab.classList.add("border-l", "border-t", "border-r", "rounded-t", "text-blue-700")
    document.querySelector(tab.getAttribute("href")).classList.remove("hidden")
  }
}
