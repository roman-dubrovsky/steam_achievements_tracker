# frozen_string_literal: true

# Helpers for shallow rendering of view components
module ViewComponentMock
  def mock_component(component, *)
    mock = instance_double(component, render_in: yield.html_safe, set_original_view_context: true)

    allow(component).to receive(:new)
      .with(*)
      .and_return(mock)
  end
end
