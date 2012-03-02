require 'spec_helper'

describe "levels/show" do
  before(:each) do
    @level = assign(:level, stub_model(Level))
  end

  it "renders attributes in <p>" do
    render
  end
end
