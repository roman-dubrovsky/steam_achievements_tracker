RSpec.describe Layout::NavigationButtonComponent, type: :component do
  let(:title) { 'Home' }
  let(:path) { '/home' }

  context 'when path is passed' do
    subject(:rendered_component) { render_inline(Layout::NavigationButtonComponent.new(title, path: path)) }

    it 'renders a navigation button with the correct title' do
      expect(rendered_component).to have_text(title)
    end

    it 'renders a navigation button with the correct link' do
      expect(rendered_component).to have_link(title, href: path)
    end
  end

  context 'when path is not passed' do
    subject(:rendered_component) { render_inline(Layout::NavigationButtonComponent.new(title)) }

    it 'uses default path' do
      expect(rendered_component).to have_link(title, href: "#")
    end
  end
end
