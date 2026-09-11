import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "product", "count", "empty"]

  connect() {
    this.filter()
  }

  filter() {
    const words = this.inputTarget.value.toLocaleLowerCase().trim().split(/\s+/).filter(Boolean)
    let visible = 0
    this.productTargets.forEach(product => {
      const matches = words.every(word => product.dataset.searchText.toLocaleLowerCase().includes(word))
      product.hidden = !matches
      if (matches) visible += 1
    })
    this.countTarget.textContent = words.length ? `${visible} of ${this.productTargets.length} pieces` : `${visible} ${visible === 1 ? "piece" : "pieces"}`
    this.emptyTarget.hidden = visible > 0 || words.length === 0
  }

  clear() {
    this.inputTarget.value = ""
    this.filter()
    this.inputTarget.focus()
  }
}
