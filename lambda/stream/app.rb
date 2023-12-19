require 'json'
require 'base64'
require 'zlib'
require 'stringio'
require 'aws-sdk-eventbridge'

def lambda_handler(event:, context:)
  logger = Logger.new($stdout)
  # Initialize the EventBridge client
  eventbridge = Aws::EventBridge::Client.new(region: ENV['AWS_REGION'])
  puts event

  log_data = event['awslogs']['data']
  decoded_data = Base64.decode64(log_data)
  log_message = Zlib::GzipReader.new(StringIO.new(decoded_data)).read

  event_to_send = {
    entries: [
      {
        time: Time.now,
        source: 'custom.cloudwatch.logs',
        detail_type: 'CloudWatch Log Event',
        detail: log_message,
        event_bus_name: ENV['EVENT_BUS_NAME']
      }
    ]
  }

  logger.info { 'attempting to send event to event bridge' }
  begin
    response = eventbridge.put_events(event_to_send)
  rescue => err
    puts err
  end
  logger.info { response }
  { statusCode: 200, body: JSON.generate(response) }
rescue => e
  { statusCode: 500, body: e.message }
end
