// Import and register all your controllers from the importmap via controllers/**/*_controller
// import { Application } from "controllers/application"
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// eagerLoadControllersFrom("controllers", application)
//
// const application = Application.start();
// application.register("carousel", CarouselController);

// app/javascript/controllers/index.js
import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
import CarouselController from "./carousel_controller";

const application = Application.start();
eagerLoadControllersFrom("controllers", application);
application.register("carousel", CarouselController);