import { Application } from "@hotwired/stimulus";
import AutocompleteController from "controllers/autocomplete_controller";
import { fireEvent, waitFor } from "@testing-library/dom";

describe("AutocompleteController", () => {
  let application;
  let body = `
    <div
      data-controller="autocomplete"
      data-autocomplete-target="container"
      data-autocomplete-games='[{"appid":"1","name":"Game 1"},{"appid":"2","name":"Game 2"}]'
    >
      <input 
        type="text" 
        data-autocomplete-target="input" 
        data-action="input->autocomplete#search input->autocomplete#clearHiddenField" 
      />
      <input 
        type="hidden" 
        data-autocomplete-target="select" 
      />
      <ul 
        data-autocomplete-target="list" 
        class="hidden"
      ></ul>
    </div>
  `;

  beforeEach(() => {
    document.body.innerHTML = body;

    application = Application.start();
    application.register("autocomplete", AutocompleteController);
  });

  afterEach(() => {
    application.stop();
  });

  test("initializes with games data", () => {
    const controller = application.getControllerForElementAndIdentifier(
      document.querySelector("[data-controller='autocomplete']"),
      "autocomplete",
    );

    expect(controller).toBeDefined();
    expect(controller.games).toEqual([
      { appid: "1", name: "Game 1" },
      { appid: "2", name: "Game 2" },
    ]);
  });

  test("filters games based on input", async () => {
    const input = document.querySelector("[data-autocomplete-target='input']");
    const list = document.querySelector("[data-autocomplete-target='list']");

    input.value = "Game 1";
    fireEvent.input(input);

    await waitFor(() => {
      expect(list.children.length).toBe(1);
      expect(list.children[0].textContent).toBe("Game 1");
    });
  });

  test("updates hidden field when selecting a game", async () => {
    const input = document.querySelector("[data-autocomplete-target='input']");
    const select = document.querySelector(
      "[data-autocomplete-target='select']",
    );
    const list = document.querySelector("[data-autocomplete-target='list']");

    input.value = "Game 1";
    fireEvent.input(input);

    await waitFor(() => {
      expect(list.children.length).toBe(1);
    });

    const firstItem = list.children[0];
    fireEvent.click(firstItem);

    await waitFor(() => {
      expect(select.value).toBe("1");
    });

    expect(input.value).toBe("Game 1");
  });

  describe("when some value were passed as an value for hidden field", () => {
    body = `
      <div
        data-controller="autocomplete"
        data-autocomplete-target="container"
        data-autocomplete-games='[{"appid":"1","name":"Game 1"},{"appid":"2","name":"Game 2"}]'
      >
        <input 
          type="text" 
          data-autocomplete-target="input" 
          data-action="input->autocomplete#search input->autocomplete#clearHiddenField" 
        />
        <input 
          type="hidden" 
          value="1"
          data-autocomplete-target="select" 
        />
        <ul 
          data-autocomplete-target="list" 
          class="hidden"
        ></ul>
      </div>
    `;

    test("sets selected item if the game was passed as a parameter", () => {
      const input = document.querySelector(
        "[data-autocomplete-target='input']",
      );
      expect(input.value).toBe("Game 1");
    });

    test("remove value from hidden field after clearing the input", async () => {
      const input = document.querySelector(
        "[data-autocomplete-target='input']",
      );
      const select = document.querySelector(
        "[data-autocomplete-target='select']",
      );

      input.value = "";
      fireEvent.input(input);

      await waitFor(() => {
        expect(select.value).toBe("");
      });

      expect(input.value).toBe("");
    });
  });
});
