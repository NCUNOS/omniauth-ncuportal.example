require 'rubygems'
require 'bundler'
require 'logger'

Bundler.setup :default
require 'sinatra'
require 'omniauth-ncuportal'

set :sessions, true
set :logging, true
set :environment, :production

use Rack::Session::Cookie

use OmniAuth::Builder do
	provider :ncuportal, ENV['NCUPORTAL_CLIENT_ID'], ENV['NCUPORTAL_CLIENT_SECRET']
end

get '/' do
	<<-HTML
		<ul>
			<li><a href='/auth/ncuportal'>Sign in with NCU Portal(3g) OAuth</a></li>
		</ul>
	HTML
end

[:get, :post].each do |method|
	send method, '/auth/:provider/callback' do
		content_type 'text/plain'
		request.env['omniauth.auth'].info.to_hash.to_s + "\n" + \
			request.env['omniauth.auth'].extra.to_hash.to_s
	end
end
