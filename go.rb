require './amqp_plugged_in'

amqp_plugged_in = AMQP_Plugged_In.new

amqp_plugged_in.connect(Bunny.new)

puts 'connected...'

amqp_plugged_in.go
