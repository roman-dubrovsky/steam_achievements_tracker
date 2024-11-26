import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "list", "select", "container"];

  connect() {
    this.games = JSON.parse(this.data.get("games") || "[]");
    this.listTarget.classList.add("hidden");
  }

  search(event) {
    const query = event.target.value.toLowerCase().trim();
    this.listTarget.innerHTML = "";

    if (query === "") {
      this.listTarget.classList.add("hidden");
      return;
    }

    const filteredGames = this.games.filter((game) =>
      game.name.toLowerCase().includes(query),
    );

    if (filteredGames.length === 0) {
      this.listTarget.classList.add("hidden");
      return;
    }

    this.listTarget.classList.remove("hidden");

    filteredGames.forEach((game) => {
      const li = document.createElement("li");
      li.textContent = game.name;
      li.classList.add("p-2", "hover:bg-gray-100", "cursor-pointer", "text-sm");
      li.dataset.value = game.appid;
      li.dataset.action = "click->autocomplete#selectGame";
      this.listTarget.appendChild(li);
    });
  }

  selectGame(event) {
    const appid = event.target.dataset.value;
    const gameName = event.target.textContent;

    this.inputTarget.value = gameName;
    this.listTarget.classList.add("hidden");
    this.selectTarget.value = appid;
  }
}
