import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-form"
export default class extends Controller {
  navigate(event) {
    console.log('navigate !!!!!')
    const [data, status, xhr] = event.detail
    console.log(data, status, xhr)
    if (status === 200) {
      console.log('status 200')
      this.element.outerHTML = xhr.response
    }
    console.log('done !!!!!')
  }
}
