require 'bunny'

class AMQP_Plugged_In

  attr_accessor :mq_connection
  attr_accessor :mq_channel
  attr_accessor :mq_exchange
  attr_accessor :mq_queue

  def connect(mq_connection_in)
    mq_connection = mq_connection_in
    mq_connection.start
    mq_channel = mq_connection.create_channel
    mq_exchange = mq_channel.topic('event')
    mq_queue = mq_channel.queue("", :exclusive => true)
  end

  def bind_queue(routing_key)
    mq_queue.bind(mq_exchange, :routing_key => routing_key)
  end


end