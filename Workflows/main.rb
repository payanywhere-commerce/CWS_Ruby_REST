
#Publisher

client.sign_on(Config::PublisherIdentityToken)

result= IpcO2O_endpoint_publisher::publish_redemption(client, {
	"RedemptionPublication"=>{
		"RedemptionName"=>"SuperAwesomeCoupon",
		"RedemptionStatus"=>Ipc::RedemptionStatus::ReadyForPurchase
	}
})
p result.data

p IpcO2O_endpoint_publisher::query_redemption_detail(client, {
	"RedemptionId"=>result.data["RedemptionId"]
}).body

response= IpcO2O_endpoint_publisher::query_redemption_summary(client, {
	"Scope" =>{
		"ScopeId"=>client.retailer_id,
		"ScopeType"=>Ipc::ScopeType::Retailer,
	},
})

p response.body

p IpcO2O_endpoint_publisher::update_redemption_status(client, {
	"RedemptionUpdate"=>{
		"RedemptionId"=>response.data["Redemptions"][0]["RedemptionId"],
		"ConsumerMessage"=>"Your pizza is being baked."
	}
}).body

p IpcO2O_endpoint_publisher::query_redemption_detail(client, {
	"RedemptionId"=>response.data["Redemptions"][0]["RedemptionId"],
}).body



ipc_sts_client= IpcSTSClient.new();

claims= [];
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/Issuer",
	"ClaimValue"=> "IPC Solutions Consulting Security Domain 5",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/CommerceModule/Email",
	"ClaimValue"=> "user@example.com",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/Email",
	"ClaimValue"=> "user@example.com",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/FirstName",
	"ClaimValue"=> "John",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/LastName",
	"ClaimValue"=> "Smith",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/Phone",
	"ClaimValue"=> "+1 555 555 0123",
	"Confidential"=> false}

result= IpcSTS_endpoint.issue_user_token(ipc_sts_client, claims);


result= IpcO2O_endpoint_publisher::publish_redemption(client, {
	"UserToken"=>result,
	"RedemptionPublication"=>{
		"RedemptionName"=>"SuperAwesomeCoupon",
		"RedemptionStatus"=>Ipc::RedemptionStatus::ReadyForRedeem
	}
})
p result.data

p IpcO2O_endpoint_publisher::query_redemption_detail(client, {
	"RedemptionId"=>result.data["RedemptionId"]
}).body

response= IpcO2O_endpoint_publisher::query_redemption_summary(client, {
	"Scope" =>{
		"ScopeId"=>client.retailer_id,
		"ScopeType"=>Ipc::ScopeType::Retailer,
	},
})

p response.body

p IpcO2O_endpoint_publisher::update_redemption_status(client, {
	"RedemptionUpdate"=>{
		"RedemptionId"=>response.data["Redemptions"][0]["RedemptionId"],
		"ConsumerMessage"=>"Your pizza is being baked."
	}
}).body

p IpcO2O_endpoint_publisher::query_redemption_detail(client, {
	"RedemptionId"=>response.data["Redemptions"][0]["RedemptionId"],
}).body

ipc_sts_client= IpcSTSClient.new();

claims= [];
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/Issuer",
	"ClaimValue"=> "IPC Solutions Consulting Security Domain 5",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/CommerceModule/Email",
	"ClaimValue"=> "user@example.com",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/Email",
	"ClaimValue"=> "user@example.com",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/FirstName",
	"ClaimValue"=> "John",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/LastName",
	"ClaimValue"=> "Smith",
	"Confidential"=> false}
claims << {
	"ClaimNs"=> "http://schemas.ipcommerce.com/Identity/Phone",
	"ClaimValue"=> "+1 555 555 0123",
	"Confidential"=> false}

	
result= IpcSTS_endpoint.issue_user_token(ipc_sts_client, claims);


result= IpcO2O_endpoint_publisher::publish_redemption(client, {
	"UserToken"=>result,
	"RedemptionPublication"=>{
		"RedemptionName"=>"SuperAwesomeCoupon",
		"RedemptionStatus"=>Ipc::RedemptionStatus::ReadyForRedeem
	}
})
p result.data

p IpcO2O_endpoint_publisher::query_redemption_detail(client, {
	"RedemptionId"=>result.data["RedemptionId"]
}).body

response= IpcO2O_endpoint_publisher::query_redemption_summary(client, {
	"Scope" =>{
		"ScopeId"=>client.retailer_id,
		"ScopeType"=>Ipc::ScopeType::Retailer,
	},
})

p response.body

p IpcO2O_endpoint_merchant::update_redemption_status(client, {
	"RedemptionUpdate"=>{
		"RedemptionId"=>response.data["Redemptions"][0]["RedemptionId"],
		"RedemptionStatus"=>Ipc::RedemptionStatus::Redeemed
	}
}).body

p IpcO2O_endpoint_publisher::query_redemption_detail(client, {
	"RedemptionId"=>response.data["Redemptions"][0]["RedemptionId"],
}).body

#Consumer

#client.sign_on(Config::ConsumerIdentityToken)

#p IpcO2O_endpoint_consumer::purchase_item(client, {}).body

#p IpcO2O_endpoint_consumer::query_redemption_detail(client, {}).body

#p IpcO2O_endpoint_consumer::query_redemption_summary(client, {}).body

#p IpcO2O_endpoint_consumer::update_redemption_status(client, {}).body

#Merchant \ Redemption

#client.sign_on(Config::MerchantIdentityToken)

#p IpcO2O_endpoint_merchant::query_redemption_detail(client, {}).body

#p IpcO2O_endpoint_merchant::query_redemption_summary(client, {}).body

#p IpcO2O_endpoint_merchant::update_redemption_status(client, {}).body

