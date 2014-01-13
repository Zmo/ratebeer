require 'spec_helper'

describe "styles/show" do
  before(:each) do
    @style = assign(:style, stub_model(Style,
      :name => "Name",
      :description => "MyText"
    ))
  end
end
