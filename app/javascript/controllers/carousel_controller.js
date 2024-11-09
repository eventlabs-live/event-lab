// app/javascript/controllers/carousel_controller.js
// app/javascript/controllers/carousel_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["slide"];

    connect() {
        this.index = 0;
        this.showCurrentSlide();
    }

    next() {
        this.index = (this.index + 1) % this.slideTargets.length;
        this.showCurrentSlide();
    }

    prev() {
        this.index = (this.index - 1 + this.slideTargets.length) % this.slideTargets.length;
        this.showCurrentSlide();
    }

    showCurrentSlide() {
        this.slideTargets.forEach((slide, i) => {
            slide.classList.toggle("hidden", i !== this.index);
        });
    }
}