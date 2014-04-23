require_relative 'IPC/client_api'

require_relative 'Workflows/b'
require_relative 'Workflows/VantivIBM'
require_relative 'Workflows/VantivTandem'
require_relative 'config'

#Used to log request to file if stdout is insufficient.
#def p (string)
#fp= File.open('.\log.txt','a+')
#	fp.write(string.to_s+"\n")
#	fp.close()
#end

p "Hello! Before you test this sample code, please crack open the code and check out what's going on."
p "Your solutions consultant has selected a number of tests to run through to ensure this sample works."
p "If you have questions, please contact us at solutionsconsulting@ipcommerce.com"

# Publisher

client=IpcCWSClient.new
client.merchant_profile_id= Config::MerchantProfileId
client.application_profile_id=Config::ApplicationProfileId


client.sign_on(Config::IdentityToken)


module Workflows
	def self.test_assert(test, result)
		if (!test)
			p "FAILED: "+result.last_call
			exit()
		else
			p "SUCCESS: "+result.last_call
		end
	end
end

p "Ready for VantivTandem"
gets.chomp
Workflows::VantivTandem(client)

p "Ready for VantivIBM"
gets.chomp
Workflows::VantivIBM(client)

def _skip
p "Ready for B"
gets.chomp
Workflows::B(client)
end

p("Done.")
