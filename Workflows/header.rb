require_relative '../NAB/O2O_REST/client_api'
require_relative '../NAB/STS_SOAP/client_api'


require_relative '../config'

module Header
def self.new_client()
client=IpcO2OClient.new
client.location_id= Config::LocationId;
client.publisher_id= Config::PublisherId;
client.retailer_id= Config::RetailerId;
client.publisher_application_profile_id=Config::PublisherApplicationProfileId;
client.merchant_application_profile_id=Config::MerchantApplicationProfileId;
client.consumer_application_profile_id=Config::ConsumerApplicationProfileId;
client.search_application_profile_id=Config::SearchApplicationProfileId;

client.search_service_id=Config::SearchServiceId;


p "Hello! Before you test this sample code, please crack open the code and check out what's going on."
p "Your solutions consultant has selected a number of tests to run through to ensure this sample works."
p "If you have questions, please contact us at solutionsconsulting@ipcommerce.com"

client
end

def self.new_sts_client()
sts_client=IpcSTSClient.new
sts_client
end
end