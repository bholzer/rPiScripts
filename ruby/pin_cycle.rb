require 'optparse'
require 'wiringpi2'

options = {
  iterations: 100,
  delay:500
}

OptionParser.new do |opts|
  opts.banner = "Usage: pin_cycle.rb [options]"

  opts.on('-p', '--pin PIN', 'Pin number to cycle through') do |v|
    if options[:pins].nil?
      options[:pins] = [v.to_i]
    else
      options[:pins].push(v.to_i)
    end
  end
  opts.on('-d', '--delay DELAY', 'Time to keep relay on in milliseconds') { |v| options[:delay] = v.to_f }
  opts.on('-c', '--count COUNT', 'Number of steps to take') { |v| options[:iterations] = v.to_i }
end.parse!

io = WiringPi::GPIO.new do |gpio|
  options[:pins].each do |pin|
    gpio.pin_mode(pin, WiringPi::OUTPUT)
  end
end

(0..options[:iterations]).each do |i|
  pin_index = (i % options[:pins].length)
  io.digital_write(options[:pins][pin_index], WiringPi::HIGH)
  sleep(options[:delay]/1000)
  io.digital_write(options[:pins][pin_index], WiringPi::LOW)
end
