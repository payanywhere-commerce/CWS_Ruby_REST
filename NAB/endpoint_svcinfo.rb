require 'time'
require_relative 'constants_shared'
require_relative 'recursive_merge'
require 'open-uri'

module Ipc
class SvcInfo

    def self.save_application_data(nab_cws_client, request)
      	defaults = {
			"ApplicationAttended" => false,
			"ApplicationLocation" => Ipc::ApplicationLocation::OffPremises,
			"ApplicationName" => "TestApp",
			"HardwareType" => Ipc::HardwareType::PC,
			"PINCapability" => Ipc::PINCapability::PINNotSupported,
			"PTLSSocketId" => "MIIEwjCCA6qgAwIBAgIBEjANBgkqhkiG9w0BAQUFADCBsTE0MDIGA1UEAxMrSVAgUGF5bWVudHMgRnJhbWV3b3JrIENlcnRpZmljYXRlIEF1dGhvcml0eTELMAkGA1UEBhMCVVMxETAPBgNVBAgTCENvbG9yYWRvMQ8wDQYDVQQHEwZEZW52ZXIxGjAYBgNVBAoTEUlQIENvbW1lcmNlLCBJbmMuMSwwKgYJKoZIhvcNAQkBFh1hZG1pbkBpcHBheW1lbnRzZnJhbWV3b3JrLmNvbTAeFw0wNjEyMTUxNzQyNDVaFw0xNjEyMTIxNzQyNDVaMIHAMQswCQYDVQQGEwJVUzERMA8GA1UECBMIQ29sb3JhZG8xDzANBgNVBAcTBkRlbnZlcjEeMBwGA1UEChMVSVAgUGF5bWVudHMgRnJhbWV3b3JrMT0wOwYDVQQDEzRFcWJwR0crZi8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vL0E9MS4wLAYJKoZIhvcNAQkBFh9zdXBwb3J0QGlwcGF5bWVudHNmcmFtZXdvcmsuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD7BTLqXah9t6g4W2pJUfFKxJj/R+c1Dt5MCMYGKeJCMvimAJOoFQx6Cg/OO12gSSipAy1eumAqClxxpR6QRqO3iv9HUoREq+xIvORxm5FMVLcOv/oV53JctN2fwU2xMLqnconD0+7LJYZ+JT4z3hY0mn+4SFQ3tB753nqc5ZRuqQIDAQABo4IBVjCCAVIwCQYDVR0TBAIwADAdBgNVHQ4EFgQUk7zYAajw24mLvtPv7KnMOzdsJuEwgeYGA1UdIwSB3jCB24AU3+ASnJQimuunAZqQDgNcnO2HuHShgbekgbQwgbExNDAyBgNVBAMTK0lQIFBheW1lbnRzIEZyYW1ld29yayBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxCzAJBgNVBAYTAlVTMREwDwYDVQQIEwhDb2xvcmFkbzEPMA0GA1UEBxMGRGVudmVyMRowGAYDVQQKExFJUCBDb21tZXJjZSwgSW5jLjEsMCoGCSqGSIb3DQEJARYdYWRtaW5AaXBwYXltZW50c2ZyYW1ld29yay5jb22CCQD/yDY5hYVsVzA9BglghkgBhvhCAQQEMBYuaHR0cHM6Ly93d3cuaXBwYXltZW50c2ZyYW1ld29yay5jb20vY2EtY3JsLnBlbTANBgkqhkiG9w0BAQUFAAOCAQEAFk/WbEleeGurR+FE4p2TiSYHMau+e2Tgi+L/oNgIDyvAatgosk0TdSndvtf9YKjCZEaDdvWmWyEMfirb5mtlNnbZz6hNpYoha4Y4ThrEcCsVhfHLLhGZZ1YaBD+ZzCQA7vtb0v5aQb25jX262yPVshO+62DPxnMiJevSGFUTjnNisVniX23NVouUwR3n12GO8wvzXF8IYb5yogaUcVzsTIxEFQXEo1PhQF7JavEnDksVnLoRf897HwBqcdSs0o2Fpc/GN1dgANkfIBfm8E9xpy7k1O4MuaDRqq5XR/4EomD8BWQepfJY0fg8zkCfkuPeGjKkDCitVd3bhjfLSgTvDg==",
			"ReadCapability" => Ipc::ReadCapability::KeyOnly,
			"SerialNumber" => 208093707,
			"SoftwareVersion" => "1.0",
			"SoftwareVersionDate" => "/Date(1332282250000)/"
      	};
		

        request = Ipc.recursive_merge(defaults, request);

		nab_cws_client.last_call = self.name + "::" + __method__.to_s;
        nab_cws_client.send('/svcinfo/appprofile', request, Net::HTTP::Put);
    end

    def self.get_application_data(ipc_cws_client, app_id)

		if (app_id == "") then
			app_id = ipc_cws_client.application_profile_id;
			return
		end
		app_id=URI::encode(app_id);
		ipc_cws_client.last_call = self.class + self.method
		
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
        ipc_cws_client.send('/svcinfo/appprofile/'+app_id, nil, Net::HTTP::Get);
    end

    def self.delete_application_data(ipc_cws_client, app_id)
        
		if (app_id == "") then
			false;
			# We wont just default to deleting the main application profile.
			return;
		end
		app_id=URI::encode(app_id);

		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
        ipc_cws_client.send('/svcinfo/appprofile/'+app_id, nil, Net::HTTP::Delete);
    end

    def self.get_service_info(ipc_cws_client)
        
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
        ipc_cws_client.send('/svcinfo/serviceinformation', nil, Net::HTTP::Get);
    end
    
    def self.get_merchant_profiles(ipc_cws_client, workflow_id="")
		
		if (workflow_id == "") then
			workflow_id = ipc_cws_client.workflow_id;
		end
		if (workflow_id != "") then
			params="serviceId="+URI::encode(workflow_id);
		else
		    params=""
		end
        
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
        ipc_cws_client.send('/svcinfo/merchprofile?'+params, nil, Net::HTTP::Get);
    end
    
    def self.get_merchant_profile(ipc_cws_client, merchant_profile_id="", workflow_id="")
		
		if (workflow_id == "") then
			workflow_id = ipc_cws_client.workflow_id;
		end
		if (workflow_id != "") then
			params="serviceId="+URI::encode(workflow_id);
		else
		    params=""
		end
		
		if (merchant_profile_id == "") then
			merchant_profile_id = ipc_cws_client.merchant_profile_id;
		end
		merchant_profile_id = URI::encode(merchant_profile_id);

		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
        ipc_cws_client.send('/svcinfo/merchprofile/'+merchant_profile_id+'?'+params, nil, Net::HTTP::Get);
    end
    
    
    
    def self.is_merchant_profile_initialized(ipc_cws_client, merchant_profile_id = "", workflow_id="")
      
		if (workflow_id == "") then

			workflow_id = ipc_cws_client.workflow_id;
		end
		if (workflow_id != "") then
			params="serviceId="+URI::encode(workflow_id);
		else
		    params=""
		end
		
		if (merchant_profile_id == "") then
			merchant_profile_id = ipc_cws_client.merchant_profile_id;
		end
		merchant_profile_id = URI::encode(merchant_profile_id);
		
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
        result= ipc_cws_client.send('/svcinfo/merchprofile/'+merchant_profile_id+'/OK?'+params, nil, Net::HTTP::Get);

        if (result.data["RuleMessage"] == "true")
            result.data["Success"] = true;
        end
        result
    end
    
    def self.delete_merchant_profile(ipc_cws_client, merchant_profile_id = "", workflow_id="")
		if (workflow_id == "") then
			workflow_id = ipc_cws_client.workflow_id;
		end
		if (workflow_id != "") then
			params="serviceId="+URI::encode(workflow_id);
		else
		    params=""
		end
		if (merchant_profile_id == "") then
			false
			return
		end
		
		merchant_profile_id = URI::encode(merchant_profile_id);

		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
        ipc_cws_client.send('/svcinfo/merchprofile/'+merchant_profile_id+'?'+params, nil, Net::HTTP::Delete);
    end
    
    # Use this guy with caution- No defaults are set.
    # Try to use save_merchant_profile (Without the S) because we setup the default values.
    
    def self.save_merchant_profiles(ipc_cws_client, merchant_profiles, workflow_id = "")
    	
		if (workflow_id == "") then
			workflow_id = ipc_cws_client.workflow_id;
		end
		if (workflow_id != "") then
			params="serviceId="+URI::encode(workflow_id);
		else
		    params=""
		end
		merchant_profile_id = URI::encode(merchant_profile_id);
        
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
        ipc_cws_client.send('/SvcInfo/merchProfile'+merchant_profile_id+'?'+params, merchant_profiles, Net::HTTP::Put);
    end
    
    # Most implementations save a singlle merchant profile at a time.
    def self.save_merchant_profile(ipc_cws_client, merchant_profile, workflow_id = "")
    	defaults= {
			"ProfileId" => "Default"+Time.new.to_i,
			"WorkflowId" => "",	# ala ServiceId
			"MerchantData" => {
				"CustomerServiceInternet" => "",
				"CustomerServicePhone" => "555 5550123",
				"Language" => 127,
				"Address" => {
					"Street1" => "123 Main Street",
					"Street2" => "",
					"City" => "Denver",
					"StateProvince" => 7,
					"PostalCode" => "80202",
					"CountryCode" => 234
				},
				"MerchantId" => "123456789012",
				"Name" => "TestMerchant",
				"Phone" => "720 3773700",
				"TaxId" => "",
				"BankcardMerchantData" => {
					"ABANumber" => "1234",
					"AcquirerBIN" => "123456",
					"AgentBank" => "123456",
		            "AgentChain" => "1444",
					"Aggregator" => false,
					"ClientNumber" => "1224",
					"Location" => "001",
					"MerchantType" => "",
					"PrintCustomerServicePhone" => false,
					"QualificationCodes" => "",
					"ReimbursementAttribute" => "1",
					"SIC" => "5734",
					"SecondaryTerminalId" => "123",
					"SettlementAgent" => "1234",
					"SharingGroup" => "1234",
					"StoreId" => "1234",
					"TerminalId" => "123",
					"TimeZoneDifferential" => "123",
					"IndustryType" => Ipc::IndustryType::Restaraunt
				},
				"ElectronicCheckingMerchantData" => {
					"OrginatorId" => "",
					"ProductId" => "",
					"SiteId" => ""
				}
			},
			"TransactionData" => {
				"BankcardTransactionDataDefaults" => {
					"CurrencyCode" => Ipc::TypeISOCurrencyCodeA3::USD,
					"CustomerPresent" => Ipc::CustomerPresent::Ecommerce,
					"EntryMode" => Ipc::EntryMode::Keyed,
					"RequestACI" => Ipc::RequestACI::IsCPSMeritCapable,
					"RequestAdvice" => Ipc::RequestAdvice::Capable
				}
			}
		};
    	
		defaults["WorkflowId"] = workflow_id;
    
		merchant_profile = Ipc.recursive_merge(defaults, merchant_profile);
		
        response= Ipc.Svcinfo.save_merchant_profiles(ipc_cws_client, [merchant_profile], workflow_id);
    	if (count(response.data) == 1) then
    		response.data = response.data.MerchantProfiles[0];
    		response.data.Success = true;
    	else
    		response.data = {"Success" => false, "id" => "", "href" => ""};
        end
    	response;
    end

end
end

