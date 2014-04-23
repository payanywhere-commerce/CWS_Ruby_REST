require 'time'
require_relative 'constants_shared'
require_relative 'recursive_merge'
module Ipc
class Txn
	def self.authorize_and_capture(ipc_cws_client, request)
		defaults= {
			"$type" => "AuthorizeAndCaptureTransaction,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Rest",
			"ApplicationProfileId" => "",
			"MerchantProfileId" => "",
			"Transaction" => {
				"$type" => "BankcardTransaction,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Bankcard",
				"CustomerData" => nil,
				"ReportingData" => nil,
				"Addendum" => {
					"Unmanaged" => {
						"Any" => ["<Username>DougTest</Username>", "<Password>Tests</Password>"]
					}
				},
				"ApplicationConfigurationData" => nil,
				"TenderData" => {
					"PaymentAccountDataToken" => nil,
					"SecurePaymentAccountData" => nil,
					"CardData" => {
						"CardType" => Ipc::TypeCardType::MasterCard,
						"CardholderName" => nil,
						"PAN" => "5454545454545454",
						"Expire" => "1210",
						"Track1Data" => nil,
						"Track2Data" => nil
					},
					"CardSecurityData" => {
						"AVSData" => {
							"CardholderName" => "SJohnson",
							"Street" => "777 Cherry Street",
							"City" => "Denver",
							"StateProvince" => "CO",
							"PostalCode" => "80220",
							"Country" => Ipc::ISOCountryCodeA3::USA,
							"Phone" => nil
						},
						"CVDataProvided" => Ipc::CVDataProvided::Provided,
						"CVData" => "123",
						"KeySerialNumber" => nil,
						"PIN" => nil
					},
					"EcommerceSecurityData" => nil
				},
				"TransactionData" => {
					"Amount" => "10.00",
					"CurrencyCode" => Ipc::TypeISOCurrencyCodeA3::USD,
					"TransactionDateTime" => "2012-03-22T14:57:28-06:00",
					"AccountType" => Ipc::AccountType::NotSet,
					"AlternativeMerchantData" => nil,
					"ApprovalCode" => nil,
					"CashBackAmount" => "0.00",
					"CustomerPresent" => Ipc::CustomerPresent::Ecommerce,
					"EmployeeId" => "12345",
					"EntryMode" => Ipc::EntryMode::Keyed,
					"GoodsType" => Ipc::GoodsType::DigitalGoods,
					"IndustryType" => Ipc::IndustryType::Ecommerce,
					"InternetTransactionData" => {
						"IpAddress" => "1.1.1.1",
						"SessionId" => "12345"
					},
					"InvoiceNumber" => nil,
					"OrderNumber" => "12345",
					"IsPartialShipment" => false,
					"SignatureCaptured" => false,
					"TerminalId" => nil,
					"TipAmount" => "0.00",
	                "LaneId" => 3,
					"BatchAssignment" => nil
				}
			}
		};

		defaults["MerchantProfileId"] = ipc_cws_client.merchant_profile_id;
		defaults["ApplicationProfileId"] = ipc_cws_client.application_profile_id;

		request = Ipc.recursive_merge(defaults, request);

		workflow_id = URI::encode(ipc_cws_client.workflow_id);

		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
		ipc_cws_client.send('/txn/'+workflow_id, request, Net::HTTP::Post);
	end

	def self.authorize(ipc_cws_client, request)
		defaults= {
			"$type" => "AuthorizeTransaction,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Rest",
			"ApplicationProfileId" => "",
			"MerchantProfileId" => "",
			"Transaction" => {
				"$type" => "BankcardTransaction,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Bankcard",
				"CustomerData" => nil,
				"ReportingData" => nil,
				"Addendum" => {
					"Unmanaged" => {
						"Any" => ["<Username>DougTest</Username>", "<Password>Tests</Password>"]
					}
				},
				"ApplicationConfigurationData" => nil,
				"TenderData" => {
					"PaymentAccountDataToken" => nil,
					"SecurePaymentAccountData" => nil,
					"CardData" => {
						"CardType" => Ipc::TypeCardType::MasterCard,
						"CardholderName" => nil,
						"PAN" => "5454545454545454",
						"Expire" => "1210",
						"Track1Data" => nil,
						"Track2Data" => nil
					},
					"CardSecurityData" => {
						"AVSData" => {
							"CardholderName" => "SJohnson",
							"Street" => "777 Cherry Street",
							"City" => "Denver",
							"StateProvince" => "CO",
							"PostalCode" => "80220",
							"Country" => Ipc::ISOCountryCodeA3::USA,
							"Phone" => nil
						},
						"CVDataProvided" => Ipc::CVDataProvided::Provided,
						"CVData" => "123",
						"KeySerialNumber" => nil,
						"PIN" => nil
					},
					"EcommerceSecurityData" => nil
				},
				"TransactionData" => {
					"Amount" => "10.00",
					"CurrencyCode" => Ipc::TypeISOCurrencyCodeA3::USD,
					"TransactionDateTime" => "2012-03-22T14:57:28-06:00",
					"AccountType" => Ipc::AccountType::NotSet,
					"AlternativeMerchantData" => nil,
					"ApprovalCode" => nil,
					"CashBackAmount" => "0.00",
					"CustomerPresent" => Ipc::CustomerPresent::Ecommerce,
					"EmployeeId" => "12345",
					"EntryMode" => Ipc::EntryMode::Keyed,
					"GoodsType" => Ipc::GoodsType::DigitalGoods,
					"IndustryType" => Ipc::IndustryType::Ecommerce,
					"InternetTransactionData" => {
						"IpAddress" => "1.1.1.1",
						"SessionId" => "12345"
					},
					"InvoiceNumber" => nil,
					"OrderNumber" => "12345",
					"IsPartialShipment" => false,
					"SignatureCaptured" => false,
					"TerminalId" => nil,
					"TipAmount" => "0.00",
	                "LaneId" => 3,
					"BatchAssignment" => nil
				}
			}
		};

		defaults["ApplicationProfileId"] = ipc_cws_client.application_profile_id;


		defaults["MerchantProfileId"] = ipc_cws_client.merchant_profile_id;

		request = Ipc.recursive_merge(defaults, request);

		workflow_id = URI::encode(ipc_cws_client.workflow_id);
		
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
		ipc_cws_client.send('/txn/'+workflow_id, request, Net::HTTP::Post);
	end


	def self.capture(ipc_cws_client, request)
		defaults={
			 "$type" => "Capture,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Rest",
			 "ApplicationProfileId" => "",
			 "DifferenceData" => {
				 "$type" => "BankcardCapture,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Bankcard",
				 "Amount" => "10.00",
				 "TransactionId" => "--Transaction ID Required--",
				 "TipAmount" => "0.00",
				 "Addendum" => nil
			 }
		 };

		defaults["ApplicationProfileId"] = ipc_cws_client.application_profile_id;

		request = Ipc.recursive_merge(defaults, request);

		workflow_id = URI::encode(ipc_cws_client.workflow_id);
		
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
		ipc_cws_client.send('/txn/'+workflow_id+'/'+request['DifferenceData']['TransactionId'], request, Net::HTTP::Put);
	end

	def self.undo(ipc_cws_client, request)
		defaults={
			"$type" => "Undo,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Rest",
			"ApplicationProfileId" => "",
			"DifferenceData" => {
				"$type" => "BankcardUndo,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Bankcard",
				"TransactionId" => "--Transaction ID Required--",
				"Addendum" => nil
			}
		};

		defaults["ApplicationProfileId"] = ipc_cws_client.application_profile_id;

		request = Ipc.recursive_merge(defaults, request)

		workflow_id = URI::encode(ipc_cws_client.workflow_id);
		
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
		ipc_cws_client.send('/txn/'+workflow_id+'/'+request['DifferenceData']['TransactionId'], request, Net::HTTP::Put);
	end

	def self.return_by_id(ipc_cws_client, request)
		defaults={
			"$type" => "ReturnById,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Rest",
			"ApplicationProfileId" => "",
			"MerchantProfileId" => "z",
			"DifferenceData" => {
				"$type" => "BankcardReturn,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Bankcard",
				"TransactionId" => "--Transaction ID Required--",
				"Amount" => "10.00",
				"Addendum" => nil
			}
		};

		defaults["ApplicationProfileId"] = ipc_cws_client.application_profile_id;
		defaults["MerchantProfileId"] = ipc_cws_client.merchant_profile_id;

		request = Ipc.recursive_merge(defaults, request);

		workflow_id = URI::encode(ipc_cws_client.workflow_id);
		
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
		ipc_cws_client.send('/txn/'+workflow_id, request, Net::HTTP::Post);
	end

	def self.return_unlinked(ipc_cws_client, request)
		defaults={
			"$type" => "ReturnTransaction,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Rest",
			"ApplicationProfileId" => "",
			"MerchantProfileId" => "",
			"Transaction" => {
				"$type" => "BankcardTransaction,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Bankcard",
				"CustomerData" => nil,
				"ReportingData" => nil,
				"Addendum" => {
					"Unmanaged" => {
						"Any" => ["<Username>DougTest</Username>", "<Password>Tests</Password>"]
					}
				},
				"ApplicationConfigurationData" => nil,
				"TenderData" => {
					"PaymentAccountDataToken" => nil,
					"SecurePaymentAccountData" => nil,
					"CardData" => {
						"CardType" => Ipc::TypeCardType::MasterCard,
						"CardholderName" => nil,
						"PAN" => "5454545454545454",
						"Expire" => "1210",
						"Track1Data" => nil,
						"Track2Data" => nil
					},
					"CardSecurityData" => {
						"AVSData" => {
							"CardholderName" => "SJohnson",
							"Street" => "777 Cherry Street",
							"City" => "Denver",
							"StateProvince" => "CO",
							"PostalCode" => "80220",
							"Country" => Ipc::ISOCountryCodeA3::USA,
							"Phone" => nil
						},
						"CVDataProvided" => Ipc::CVDataProvided::Provided,
						"CVData" => "123",
						"KeySerialNumber" => nil,
						"PIN" => nil
					},
					"EcommerceSecurityData" => nil
				},
				"TransactionData" => {
					"Amount" => "10.00",
					"CurrencyCode" => Ipc::TypeISOCurrencyCodeA3::USD,
					"TransactionDateTime" => "2012-03-22T14:57:28-06:00",
					"AccountType" => Ipc::AccountType::NotSet,
					"AlternativeMerchantData" => nil,
					"ApprovalCode" => nil,
					"CashBackAmount" => "0.00",
					"CustomerPresent" => Ipc::CustomerPresent::Ecommerce,
					"EmployeeId" => "12345",
					"EntryMode" => Ipc::EntryMode::Keyed,
					"GoodsType" => Ipc::GoodsType::DigitalGoods,
					"IndustryType" => Ipc::IndustryType::Ecommerce,
					"InternetTransactionData" => {
						"IpAddress" => "1.1.1.1",
						"SessionId" => "12345"
					},
					"InvoiceNumber" => nil,
					"OrderNumber" => "12345",
					"IsPartialShipment" => false,
					"SignatureCaptured" => false,
					"TerminalId" => nil,
					"TipAmount" => "0.00",
	                "LaneId" => 3,
					"BatchAssignment" => nil
				}
			}
		};

		defaults["ApplicationProfileId"] = ipc_cws_client.application_profile_id;
		defaults["MerchantProfileId"] = ipc_cws_client.merchant_profile_id;

		request = Ipc.recursive_merge(defaults, request);

		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
		ipc_cws_client.send('/txn/'+ipc_cws_client.workflow_id, request, Net::HTTP::Post);
	end


	def self.capture_all(ipc_cws_client, request)
		defaults={
			"$type" => "CaptureAll,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Rest",
			"ApplicationProfileId" => "",
			"MerchantProfileId" => ""
		};

		defaults["ApplicationProfileId"] = ipc_cws_client.application_profile_id;
		defaults["MerchantProfileId"] = ipc_cws_client.merchant_profile_id;

		request = Ipc.recursive_merge(defaults, request);

		workflow_id = URI::encode(ipc_cws_client.workflow_id);
		
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
		ipc_cws_client.send('/txn/'+workflow_id, request, Net::HTTP::Put);
	end


	def self.capture_selective(ipc_cws_client, request)
		defaults={
			"$type" => "CaptureSelective,http://schemas.ipcommerce.com/CWS/v2.0/Transactions/Rest",
			"ApplicationProfileId" => "",
			"TransactionIds" => ["--Transaction ID Required--"],
			"DifferenceData" => {
				"Capture" => [{
					"Amount" => "10.00",
					"TransactionId" => "--Transaction ID Required--",
					"TipAmount" => "0.00",
					"Addendum" => nil
				}]
			}
		};

		defaults["ApplicationProfileId"] = ipc_cws_client.application_profile_id;

		request = Ipc.recursive_merge(defaults, request);

		workflow_id = URI::encode(ipc_cws_client.workflow_id);
		
		ipc_cws_client.last_call = self.name + "::" + __method__.to_s;
		ipc_cws_client.send('/txn/'+workflow_id, request, Net::HTTP::Put);
	end

end
end
