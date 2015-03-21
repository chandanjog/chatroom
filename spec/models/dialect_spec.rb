require 'rails_helper'

describe Dialect, type: :model do
  let(:message) {'hello people'}

  it 'should correctly translate message to pirate dialect' do
    expect(Dialect.find('pirate').translate(message)).to match(/^a(hoy|vast) people/)
  end

  it 'should correctly translate message to yoda dialect' do
    expect(Dialect.find('yoda').translate(message)).to eq('Hello people')
  end

  it 'should correctly translate message to valley girl dialect' do
    expect(Dialect.find('valley-girl').translate(message)).to eq('hello people')
  end

  it 'should return back the original message if api is unreachable' do
    allow(Net::HTTP).to receive(:get_response).and_return(Net::HTTPError)
    expect(Dialect.find('pirate').translate(message)).to eq('hello people')
  end

  it 'should return select_options' do
    expect(Dialect.select_options).to eq([['Pirate', 'pirate'], ['Yoda', 'yoda'], ['Valley Girl', 'valley-girl']])
  end
end
