require 'spec_helper'

describe Beer do
  it "is not created without a name" do
    beer = Beer.create

    expect(beer.valid?).to eq(false)
    expect(Beer.count).to eq(0)
  end

  it "is not created without a style" do
    beer = Beer.create :name => "testbeer"

    expect(beer.valid?).to eq(false)
    expect(Beer.count).to eq(0)
  end
end
