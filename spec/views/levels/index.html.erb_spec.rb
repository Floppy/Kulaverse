require 'spec_helper'

describe "levels/index" do
  before(:each) do
    assign(:levels, [
      stub_model(Level),
      stub_model(Level)
    ])
  end

  it "renders a list of levels" do
    render
  end
end
