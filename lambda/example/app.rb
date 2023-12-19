require 'json'

def lambda_handler(event:, context:)
  { statusCode: 200, body: { "hello" => "world" } }
rescue => e
  { statusCode: 500, body: e.message }
end
