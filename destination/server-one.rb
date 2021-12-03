require 'sinatra'
require 'openssl'

get '/' do 
end

get '/webhook' do
  status 200
  body 'Got it, thanks Convoy!'
end

post '/' do
  webhook_token = "dsfds87fhuidh87hsd8hf7sd8"
  body = request.body.read
  hook_signature = request.env['HTTP_X_CONVOY_SIGNATURE']
  digest = OpenSSL::Digest::SHA512.new
  signature = OpenSSL::HMAC.hexdigest(digest, webhook_token, body)

  puts signature
  puts hook_signature

  is_valid = Rack::Utils.secure_compare(signature, hook_signature)

  if is_valid
    status 200
    body 'Got it, thanks Convoy!'
  else
    status 400
    body "Hash did not match."
  end
end

