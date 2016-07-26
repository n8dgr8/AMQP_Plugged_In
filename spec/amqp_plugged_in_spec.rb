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

  it 'AMQP_Plugged_In subscribes and waits for a message' do
    amqp_plugged_in_ut.mq_queue_rx = queue_mock
    expect(queue_mock).to receive(:subscribe).with({:block => true})
    amqp_plugged_in_ut.wait_for_message
  end

  it 'AMQP_Plugged_In binds to the desired topic on the exchange' do
    pending('Step 1 - Bind The Queue To Your Desired Topic')
    amqp_plugged_in_ut.mq_queue_rx = queue_mock
    amqp_plugged_in_ut.mq_exchange_rx = exchange_mock

    expect(queue_mock).to receive(:bind).with(exchange_mock, :routing_key => 'YOUR.ROUTING.KEY.HERE.*')

    amqp_plugged_in_ut.bind_queue('barf')
  end

  it 'AMQP_Plugged_In publishes valid action messages' do
    # pending('Step 3 - Publish A Valid JSON Message To The Default Exchange')

    amqp_plugged_in_ut.mq_connection_tx = connection_mock

    allow(connection_mock).to receive(:create_channel).and_return(channel_mock)
    allow(channel_mock).to receive(:default_exchange).and_return(exchange_mock)

    expect(exchange_mock).to receive(:publish).with(
        '{"hello":"bye"}', {:headers=>{'type' => 'action'}, :routing_key => 'i.am.a.routing.key.*'})

    amqp_plugged_in_ut.publish_action_message('i.am.a.routing.key.*', JSON.generate({:hello => 'bye'}))

    # assert(false, true)
  end
end