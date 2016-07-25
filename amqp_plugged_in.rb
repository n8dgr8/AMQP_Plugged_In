require 'bunny'
require 'json'

class AMQP_Plugged_In

  attr_accessor :mq_connection_rx
  attr_accessor :mq_channel_rx
  attr_accessor :mq_exchange_rx
  attr_accessor :mq_queue_rx

  attr_accessor :mq_connection_tx
  attr_accessor :mq_channel_tx
  attr_accessor :mq_exchange_tx

  def connect(mq_connection_in_rx)
    mq_connection_rx = mq_connection_in_rx
    mq_connection_rx.start
    mq_channel_rx = mq_connection_rx.create_channel
    mq_exchange_rx = mq_channel_rx.topic('event')
    mq_queue_rx = mq_channel_rx.queue("", :exclusive => true)


  end

  def bind_queue(routing_key)
    mq_queue.bind(mq_exchange_rx, :routing_key => routing_key)
  end

  def wait_for_message
    begin
      mq_queue_rx.subscribe(:block => true) do |_, _, message_body|
        handle_message(message_body)
      end
    rescue Interrupt => _
      mq_channel.close
      mq_connection.close
    end
  end

  def handle_message(message_body_as_string)
    message_hash = JSON.parse(message_body_as_string)
    #   Step 2 - Put your message handler logic here!
    #   Step 3 - Publish an action message (if needed)
    publish_action_message(routing_key, JSON.generate({:hello => 'bye'}))
  end

  def publish_action_message(routing_key, message)
    #  mq_connection_tx = Bunny.new
    #  mq_connection_tx.start
    mq_channel_tx = mq_connection_tx.create_channel
    mq_exchange_tx = mq_channel_tx.default_exchange
    mq_exchange_tx.publish(message, :headers => {'type' => 'action'}, :routing_key => routing_key)

    #  mq_connection_tx.close
  end

end