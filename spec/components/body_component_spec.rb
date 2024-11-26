RSpec.describe BodyComponent, type: :component do
  let(:content) { "This is the dynamic content." }

  subject(:rendered_component) do
    render_inline(BodyComponent.new) do
      content
    end
  end

  before do
    mock_component(Layout::NavigationButtonComponent, "Dashboard", path: "/dashboard") do
      "<li>Dashboard Navigation Link</li>"
    end

    mock_component(Layout::NavigationButtonComponent, "Games") do
      "<li>Games Navigation Link</li>"
    end

    mock_component(Layout::NavigationButtonComponent, "Sessions") do
      "<li>Sessions Navigation Link</li>"
    end
  end

  it 'renders the grid layout with navigation and content' do
    expect(rendered_component).to have_css('main.container.mx-auto.mt-28.px-5.grid.grid-cols-1.md\\:grid-cols-5.gap-4')
    expect(rendered_component).to have_css('nav.col-span-1.md\\:col-span-1.p-4')
    expect(rendered_component).to have_css('div.col-span-1.md\\:col-span-4.p-4')
    expect(rendered_component).to have_text(content)
  end

  [ "Dashboard Navigation Link", "Games Navigation Link", "Sessions Navigation Link" ].each do |link|
    it "renders #{link}" do
      expect(rendered_component).to have_css('nav li', text: link)
    end
  end
end
