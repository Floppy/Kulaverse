require 'spec_helper'

describe "levels/new" do
  before(:each) do
    assign(:level, stub_model(Level).as_new_record)
  end

  it "renders new level form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => levels_path, :method => "post" do
    end
  end
end
