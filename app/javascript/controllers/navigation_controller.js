import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  toggle(event) {
    if (event.target.open) {
      this.panelTargets.forEach(panel => {
        if (panel !== event.target) panel.open = false
      })
    }
  }

  close() {
    const openPanel = this.panelTargets.find(panel => panel.open)
    if (openPanel) {
      openPanel.open = false
      openPanel.querySelector("summary").focus()
    }
  }

  dismiss(event) {
    if (!this.element.contains(event.target)) this.reset()
  }

  reset() {
    this.panelTargets.forEach(panel => { panel.open = false })
  }
}
