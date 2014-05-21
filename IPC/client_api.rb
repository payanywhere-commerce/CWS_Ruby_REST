require 'net/http'
require 'time'
require 'base64'
require 'json'

require_relative 'simple_response'
require_relative 'constants_shared'
require_relative 'endpoint_svcinfo'
require_relative 'endpoint_txn'

module Ipc

	class Client
		#Your Solutions Consultant may have commented out some of the lines below to match your implementation.

		
		
		def initialize()
			@do_log=false
			@do_proxy=false
			
			@session_token=""
			
			@merchant_profile_id=""
			@application_profile_id=""
			@workflow_id
			
			@last_call=""
			#Used to debug the last called url.
		end
		
		attr_accessor :application_profile_id, :workflow_id
		attr_accessor :merchant_profile_id
		attr_accessor :do_log, :do_proxy
		attr_accessor :last_call
		
		def send(path, body, rest_action, url='api.cert.nabcommerce.com')
		    @do_log=true
			path = "/REST/2.0.18" + path
			#@do_proxy=true;
			if (@do_proxy)
				url='localhost'
				https = Net::HTTP.new(url, 80)
			else
				https = Net::HTTP.new(url, 443)
				https.use_ssl= true
			end
			@last_call = @last_call + " to URL: "+ rest_action.to_s[11..-1] +" "+ path
			
			https.verify_mode = OpenSSL::SSL::VERIFY_NONE
				#Please verify the connection when you go to production!
			request = rest_action.new(path)
			
			if @session_token == ""
				p "Session token is blank!"
				return {'data'=>{'success'=>false}}
			end
			request.basic_auth(@session_token,nil)
			request.set_content_type("application/json")
			request.delete "accept"
			request.add_field("Expect","100-continue")
			request.add_field("Host", url)
			if (!body.nil?)
				body = JSON.generate(body)
				if (@do_log)
					p body
				end
			end
			response=https.start { |https|
				https.request(request, body)
			}
			if (@do_log)
				p response.code
				p response.body
			end
			Ipc::SimpleResponse.new(response)
		end

		# Careful, super coder!
		# The identity_token is a base64'd saml assertion that lasts 3 years.
		# The session_token is a base64'd saml assertion that lasts 30 minutes.
		# The SvcInfo/token endpoint only accepts the 3 year saml assertion, 
		#  and replies with a session token in quotes.
		# All of the endpoints outside of SvcInfo expect a valid session_token.
	
		def sign_on(identity_token)
			@session_token= identity_token
			
			p "Requesting signOn..."+@session_token[0..32]
			response= send("/svcinfo/token", nil, Net::HTTP::Get)
			p "Done"
			
			if (response.code != "200" || response.body.length < 100)
				p "Oops, it seems we didn't get a session token. Response code="+ response.code;
				p response.body
				@session_token = nil
				return
			end
			@session_token=response.body[1,response.body.length-2] #remove quotes
			
			# Protip: The saml assertion can be read and verified of its duration.
			# It would be prudent to make a type of check_session() function to be called before any calls
			# to check the @session_expires is not < time.now()   -- and if so, call sign on.
			# Or, for a constant connection do a 25 minute cron job that gets the latest session token
			# to *securely* share among all your servers.
			
			#match_expires=/(?<=NotOnOrAfter=\")[\s\S]*?(?=\")/
			#match= match_expires.match(Base64.decode64(@session_token))
			#if match
			#	@session_expires=match[0]
			#	p "Security Token Expires on: #{match[0]}"
			#end
			#@session_token
		end
	end
end


IpcCWSClient = Ipc::Client
IpcCWS_endpoint_svcinfo = Ipc::SvcInfo
IpcCWS_endpoint_txn = Ipc::Txn
