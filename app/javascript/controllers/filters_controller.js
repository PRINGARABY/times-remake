import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { active: Boolean }

  connect() {
    this.element.open = this.activeValue
  }
}
