require 'rspec'
require './amqp_plugged_in'


describe 'On start' do
  let(:connection_mock) { instance_double('Session') }
  let(:channel_mock) { instance_double('Channel') }
  let(:exchange_mock) { instance_double('Exchange') }
  let(:queue_mock) { instance_double('Bunny::Queue') }

  amqp_plugged_in_ut = AMQP_Plugged_In.new

  it 'AMQP_Plugged_In connects to the exchange' do
    expect(connection_mock).to receive(:start)
    expect(connection_mock).to receive(:create_channel).and_return(channel_mock)
    expect(channel_mock).to receive(:topic).with('event').and_return(exchange_mock)
    expect(channel_mock).to receive(:queue).with('', {:exclusive => true} ).and_return(queue_mock)
    amqp_plugged_in_ut.connect(connection_mock)
  end

  it 'AMQP_Plugged_In binds to the desired topic on the exchange' do
    # pending('Step 1 - Bind The Queue To Your Desired Topic')
    amqp_plugged_in_ut.mq_queue = queue_mock
    amqp_plugged_in_ut.mq_exchange = exchange_mock

    expect(queue_mock).to receive(:bind).with(exchange_mock, :routing_key => 'abc.def.*')

    amqp_plugged_in_ut.bind_queue('abc.def.*')
  end

  # it 'AMQP_PLugged_In'
end