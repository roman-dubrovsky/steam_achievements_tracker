# frozen_string_literal: true

class Layout::NavigationButtonComponent < ViewComponent::Base
  attr_reader :title, :path

  def initialize(title, path: "#")
    @title = title
    @path = path
  end
end
