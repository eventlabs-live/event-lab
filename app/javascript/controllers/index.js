// Import and register all your controllers from the importmap via controllers/**/*_controller
// import { Application } from "controllers/application"

// app/javascript/controllers/index.js
import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

const application = Application.start();
eagerLoadControllersFrom("controllers", application);
