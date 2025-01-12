import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "results"]

  connect() {
    console.log("CSV Upload controller connected")
  }

  submit(event) {
    event.preventDefault()
    const formData = new FormData(this.formTarget)

    fetch(this.formTarget.action, {
      method: "POST",
      body: formData,
      headers: {
        "Accept": "application/json"
      }
    })
      .then(response => response.json())
      .then(data => {
        this.resultsTarget.innerHTML = this.formatResults(data)
      })
  }

  formatResults(data) {
    let html = '<div class="results">'

    if (data.success.length > 0) {
      html += `<div class="success">
        <h3>Successfully imported ${data.success.length} users</h3>
        <ul>
          ${data.success.map(name => `<li>${name}</li>`).join('')}
        </ul>
      </div>`
    }

    if (data.errors.length > 0) {
      html += `<div class="error">
        <h3>Failed to import ${data.errors.length} users</h3>
        <ul>
          ${data.errors.map(error => `<li>${error}</li>`).join('')}
        </ul>
      </div>`
    }

    html += '</div>'
    return html
  }
}