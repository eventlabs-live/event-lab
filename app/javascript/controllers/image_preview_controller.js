import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["canvas", "source", "chooser"];

    show() {
        const reader = new FileReader();

        reader.onload = function () {
            // this.containerTarget.removeAttribute("hidden");
            this.canvasTarget.removeAttribute("hidden");
            // this.chooserTarget.removeAttribute("hidden");
            this.chooserTarget.classList.add('hidden');

            this.canvasTarget.src = reader.result;
        }.bind(this)

        reader.readAsDataURL(this.sourceTarget.files[0]);
    }
}