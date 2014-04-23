#
#
#
#This workflow demonstrates:
#-Publishing an item
#-Purchasing that item
#
#
#

module Workflows
	def self.B(client)

		client.do_log=true

		# Call publish_redemption. No need for a usertoken if publishing as ready for purchase.

		service_response = IpcCWS_endpoint_svcinfo::get_service_info(client)

		test_assert(service_response.data["Success"]==true, "IpcCWS_endpoint_svcinfo::get_service_info")
		pindebit_auth_template= {
			"Transaction" => {
				"TenderData" => {
					"CardData" => {
						"CardType" => 3,
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
					"AccountType"=> 1,
					"EntryMode" => 3,
				}
			}
		}
		
		
		if (service_response.data["BankcardServices"].count != 0) then
			service_response.data["BankcardServices"].each { |service|
				puts service
				next if service["Operations"].nil?
		
				client.workflow_id = service["ServiceId"]
				
				profiles_response = IpcCWS_endpoint_svcinfo::get_merchant_profiles(client, "")
				puts profiles_response.data
				test_assert(profiles_response.data["Success"]==true, "IpcCWS_endpoint_svcinfo::get_merchant_profiles")
				
				# We only need to test one merchant profile.
				
				client.merchant_profile_id = profiles_response.data["Results"][0]["id"]
				
				if (service["Operations"]["AuthAndCapture"]) then
					if (service["Tenders"]["CreditAuthorizeSupport"] == 0) then	# If Auth&Cap or (Auth and Auth&Cap)
						template= pindebit_auth_template
					else
						template= {}
					end
					
					captured_response = IpcCWS_endpoint_txn::authorize_and_capture(client, template)
					puts( captured_response.data )
				end
				if (service["Operations"]["Authorize"]) then
					authorized_response = IpcCWS_endpoint_txn::authorize(client, {})
					puts( authorized_response.data )
				end
				
				if (service["Operations"]["Capture"] && !authorized_response.nil?) then
					captured_response = IpcCWS_endpoint_txn::capture(client, {
					 "DifferenceData" => {
						 "TransactionId" => authorized_response.data["TransactionId"]}})
					puts(captured_response.data)
				end
				if (service["Operations"]["Undo"] && service["Operations"]["Authorize"]) then
					authorized_response = IpcCWS_endpoint_txn::authorize(client, {})
					puts( authorized_response.data )
					
					response = IpcCWS_endpoint_txn::undo(client, {
						"DifferenceData" => {
							"TransactionId" => authorized_response.data["TransactionId"]}})
					puts( response.data )
				end
				if (service["Operations"]["ReturnById"] && service["Operations"]["AuthAndCapture"] && service["Tenders"]["CreditAuthorizeSupport"] != 0) then
	
					captured_response = IpcCWS_endpoint_txn::authorize_and_capture(client, template)
					puts( captured_response.data )
					
					response = IpcCWS_endpoint_txn::return_by_id(client, {
						"DifferenceData" => {
							"TransactionId" => captured_response.data["TransactionId"]}})
					puts( response.data )
				end
				if (service["Operations"]["ReturnUnlinked"] && service["Tenders"]["CreditAuthorizeSupport"] != 0) then
					response = IpcCWS_endpoint_txn::return_unlinked(client, {})
					puts( response.data )
				end
				if (service["Operations"]["CaptureAll"]) then
					response = IpcCWS_endpoint_txn::capture_all(client, {})
					puts( response.data )
				end
				if (service["Operations"]["CaptureSelective"] && service["Operations"]["Authorize"]) then
					authorized_response = IpcCWS_endpoint_txn::authorize(client, {})
					puts( authorized_response.data )
					
					authorized2_response = IpcCWS_endpoint_txn::authorize(client, {})
					puts( authorized2_response.data )
					
					response = IpcCWS_endpoint_txn::capture_selective(client, {
						"TransactionIds" => [authorized2_response.data["TransactionId"], authorized_response.data["TransactionId"]],
						"DifferenceData" => {
							"Capture" => [{
								"Amount" => "10.00",
								"TransactionId" => authorized_response.data["TransactionId"],
								"TipAmount" => "0.00",
								"Addendum" => nil
							}]
						}
					})
					puts( response.data )
				end
			}
		
		end


	end
end
