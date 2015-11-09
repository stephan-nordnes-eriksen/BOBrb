require 'spec_helper'

describe BOB do
  it 'has a version number' do
    expect(BOB::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(BOB.new("div").to eq("<div></div>")
  end
end
