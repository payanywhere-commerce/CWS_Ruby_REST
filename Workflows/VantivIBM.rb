module Workflows
	def self.VantivIBM(client)
	
client.do_log=true;


# Get service information to see the avilable functions.

service_response = IpcCWS_endpoint_svcinfo.get_service_info(client);
p( service_response.data );
test_assert(service_response.data["Success"]==true, client);

pindebit_auth_template= {
	"Transaction" => {
		"TenderData" => {
			"CardData" => {
				"CardType" => Ipc::TypeCardType::MasterCard,
				"CardholderName" => nil,
				"PAN" => "5454545454545454",
				"Expire" => "1210",
				"Track2Data" => "5454545454545454=10121010134988000010",
			},
			"CardSecurityData" => {
				"KeySerialNumber" => "12345678",
				"PIN" => "1234"
			},
		},
		"TransactionData" => {
			"AccountType"=> Ipc::AccountType::CheckingAccount,
			"EntryMode" => Ipc::EntryMode::Keyed,
		}
	}
};

if (service_response.data["BankcardServices"].length != 0) then

	service_response.data["BankcardServices"].each { |service|
	
		if (service["Operations"].nil?) then next; end
		if (service["ServiceId"] != "D806000001") then next; end
	
		client.workflow_id = service["ServiceId"];
		
		profiles_response = IpcCWS_endpoint_svcinfo.get_merchant_profiles(client, "");
		p( profiles_response.data );
		test_assert(profiles_response.data["Success"]==true, client);
		if (profiles_response.data["Results"].length<= 0 ) 
			p ("\n\nFAILED: Need a merchant profile for the service id: ".client.workflow_id);
			next;
		end
		# Skip the service if there aren't any merchant profiles defined.
		
		# We only need to test one merchant profile.
		profiles_response.data["Results"].each { |the_merchant_profile|
			client.merchant_profile_id = the_merchant_profile["id"];
			if (client.merchant_profile_id[0..7] != "Default") then break; end
			# Avoid selecting a "Default" profile, generated by SaveMerchant profile in the basic testing.
			# Fallthrough is okay. It selects the most recently created profile.
		}
		
		profile= IpcCWS_endpoint_svcinfo.is_merchant_profile_initialized(client, "");
		p( profile.data );
		test_assert(profile.data["Success"]==true, client);
		
		####################
		
			authorized_response = IpcCWS_endpoint_txn.authorize(client, {});
		
			p( authorized_response.data );
			test_assert(authorized_response.data["Success"]==true, client);
			test_assert(authorized_response.data["Status"]!="Failure", client);
	
			captured_response = IpcCWS_endpoint_txn.capture_selective(client, {
				"TransactionIds"=>[
					authorized_response.data["TransactionId"]
				],
				"DifferenceData"=>[{
						"$type" => "BankcardCapture,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Bankcard",
						"Amount"=>"10.00",
						"TransactionId"=>authorized_response.data["TransactionId"]
				}]
			});
		   
			p(captured_response.data);
			test_assert(captured_response.data["Success"]==true, client);
			test_assert(captured_response.data["Status"]!="Failure", client);
			
			returned_response = IpcCWS_endpoint_txn.return_by_id(client, {
				"DifferenceData" => {
					"TransactionId" => authorized_response.data["TransactionId"]
				}
			});
			
			p(returned_response.data);
			test_assert(returned_response.data["Success"]==true, client);
			test_assert(returned_response.data["Status"]!="Failure", client);
	
			captured_return_response = IpcCWS_endpoint_txn.capture_selective(client, {
				"TransactionIds"=>[
					returned_response.data["TransactionId"]
				],
				"DifferenceData"=>[{
						"$type" => "BankcardCapture,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Bankcard",
						"Amount"=>"10.00",
						"TransactionId"=>returned_response.data["TransactionId"]
					
				}]
			});
		   
			p(captured_return_response.data);
			test_assert(captured_return_response.data["Success"]==true, client);
			test_assert(captured_return_response.data["Status"]!="Failure", client);
		
		########################
		
			authorized_response = IpcCWS_endpoint_txn.authorize(client, {});
			
			p( authorized_response.data );
			test_assert(authorized_response.data["Success"]==true, client);
			test_assert(authorized_response.data["Status"]!="Failure", client);
		
			undo_response = IpcCWS_endpoint_txn.undo(client, {
				"DifferenceData" => {
					"TransactionId" => authorized_response.data["TransactionId"]
				}
			});
					
			p( undo_response.data );
			test_assert(undo_response.data["Success"]==true, client);
			test_assert(undo_response.data["Status"]!="Failure", client);
		
		########################
			response = IpcCWS_endpoint_txn.return_unlinked(client, {});
			test_assert(undo_response.data["Success"]==true, client);
			test_assert(undo_response.data["Status"]!="Failure", client);
		
		########################
		
			authorized_response = IpcCWS_endpoint_txn.authorize(client, {});
			
			p( authorized_response.data );
			test_assert(authorized_response.data["Success"]==true, client);
			test_assert(authorized_response.data["Status"]!="Failure", client);
		
			response = IpcCWS_endpoint_txn.capture_all(client, {});
			p( response.data );
			test_assert(authorized_response.data["Success"]==true, client);
			test_assert(authorized_response.data["Status"]!="Failure", client);
	}
end

	end
end

