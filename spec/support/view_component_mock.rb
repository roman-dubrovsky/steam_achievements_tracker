module ViewComponentMock
  def mock_component(component, *args)
    mock = instance_double(component, render_in: yield.html_safe, set_original_view_context: true)

    allow(component).to receive(:new)
      .with(*args)
      .and_return(mock)
  end
end
