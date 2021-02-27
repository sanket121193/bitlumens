package main

import (
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/golang/protobuf/ptypes"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)


// SmartContract provides functions for managing an Asset
type SmartContract struct {
	contractapi.Contract
}

// Asset describes basic details of what makes up a simple asset
type Asset struct {

    CitizenID             string `json:"CitizenID"`
    FirstName             string `json:"firstname"`
    LastName              string `json:"lastname"`
    Gender                string `json:"gender"`
    DOB                   string `json:"dob"`
    Address               string `json:"address"`
    FamilyMembers         string `json:"familymembers"`
    WagePerFamily         string `json:"wageperfamily"`
    SmartMeterID          string `json:"smartmeterid"`
    TypeOfFuel            string `json:"fueltype"`
    EconomicActivity      string `json:"economicactivity"`
    TypeOfFloor           string `json:"typeoffloor"`
    GridConnection        string `json:"gridconnection"`
    CropType              string `json:"croptype"`
    HarvestMonths         string `json:"harvestmonth"`
    CreditScore           string `json:"creditscore"`
    CarbonEmission        string `json:"carbonemission"`
    EnergyEfficiency      string `json:"energyefficiency"`

}

//type Carbon struct {

//	CarbonEmission        string `json:"CarbonEmission"`
//}

// HistoryQueryResult structure used for returning result of history query
type HistoryQueryResult struct {
	Record    *Asset    `json:"record"`
	TxId     string    `json:"txId"`
	Timestamp time.Time `json:"timestamp"`
	IsDelete  bool      `json:"isDelete"`
}


// CreateAsset issues a new asset to the world state with given details.
func (s *SmartContract) KycRecords(ctx contractapi.TransactionContextInterface, kycData string) (string, error) {

	if len(kycData) == 0 {
		return "", fmt.Errorf("Please pass the correct kyc data")
	}

	var asset Asset
	err := json.Unmarshal([]byte(kycData), &asset)
	if err != nil {
		return "", fmt.Errorf("Failed while unmarshling kyc records %s", err.Error())
	}

	assetAsBytes, err := json.Marshal(asset)
	if err != nil {
		return "", fmt.Errorf("Failed while marshling kyc records %s", err.Error())
	}

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(asset.CitizenID, assetAsBytes)
}

// ReadAsset returns the asset stored in the world state with given id.
func (s *SmartContract) GetRecordsById(ctx contractapi.TransactionContextInterface, CitizenID string) (*Asset, error) {
	if len(CitizenID) == 0 {
		return nil, fmt.Errorf("Please provide correct citizen Id")
	}

	assetAsBytes, err := ctx.GetStub().GetState(CitizenID)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if assetAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", CitizenID)
	}
		

	asset := new(Asset)
	_ = json.Unmarshal(assetAsBytes, asset)

	return asset, nil
	

}
//calling payment chaincode

func (s *SmartContract) GetPaymentsDetails(ctx contractapi.TransactionContextInterface, TransactionID string) (string, error) {

   if len(TransactionID) == 0 {
   
   	return "", fmt.Errorf("Please provide correct tx Id")
   	
   	}
   

	params := []string{"GetPaymentsById", TransactionID}
	queryArgs := make([][]byte, len(params))
	for i, arg := range params {
		queryArgs[i] = []byte(arg)
	}

	response := ctx.GetStub().InvokeChaincode("pay_cc", queryArgs, "mychannel")
	//if response.Status != shim.OK {
	//	return "", fmt.Errorf("Failed to query chaincode. Got error: %s", response.Payload)
	//}
	return string(response.Payload), nil
}

//credit score function

// // func (s *SmartContract) CalculateWageScore(ctx contractapi.TransactionContextInterface, creditscore string) (*Asset, error) {


// 	var wage string;

// 	for i :=4000; j :=0;  i++ {

// 		var a string = i - (i * 0.2)

// 		wage string  <= a string 
// 	}

// 	var wagescore string;

// 	for i :=850;  j :=0; i++ {

// 		var b string = i - (i * 0.2)
		
// 		wagescore string <= b string;

// 	}

// 	var finalwagescore string = (wageperfamily *  b) / a

	

// }

// func (s *SmartContract) CalculateCreditHostoryScore(ctx contractapi.TransactionContextInterface, creditscore string) (*Asset, error) {

// 		var days string

// 		for i :=365; j :=0; i++ {

// 			var d = i -30;

// 		}

// 		var dayscore string

// 	for i :=850;  j :=0; i++ {

// 		var b string = i - (i * 0.2)
		
// 		dayscore string <= b string

// 	}

// 	var finaldayscore string = (days *  b) / d


// }

// func (s *SmartContract) CalculateSmartMeterLock(ctx contractapi.TransactionContextInterface, creditscore string) (*Asset, error) {

// 	var date string

// 	for i:= 0 ;j=0 i++{

// 		date = 	currentdate - duedate;
//    }

// }

// for i :=850;  j :=0; i++ {

// 	var b string = i - (i * 0.9)
	
// 	datescore string <= b string

// }


// func (s *SmartContract) CalculateTypeFloor(ctx contractapi.TransactionContextInterface, creditscore string) (*Asset, error) {

// 	var floorscore string

// 	if(typeoffloor == "Granite"){

// 		floorscore = 850
// 	}

// 	else if(typeoffloor == "ceramic"){

// 		floorscore = 595
// 	}
// 	else if(typeoffloor == "cement")

// 	floorscore = 298

// 	else if(typeoffloor == "No floor") {

// 	floorscore = 0
// 	}
// }

// func (s *SmartContract) CalculateFinalCreditScore(ctx contractapi.TransactionContextInterface, creditscore string) (*Asset, error) {

// 	var creditscore = (floorscore * 0.2) + (wage * 0.3) + (dateofpayment * 0.3)  + (datescore * 0.2)

// }



//			var emissionfactor string
//			var galloninlitre string


//			var CarbonPerLitre string = (emissionfactor / galloninlitre)




//var CarbonPerMonth string = CarbonPerLitre * 2.6

//var CarbonPerYear string = CarbonPerMonth * 12

//var CarbonKiloWatt string = (2.6*10) * 12

//func (s *SmartContract) CarbonEmission(ctx contractapi.TransactionContextInterface, EmissionData string) (string, error) {


//var carbon Carbon
//	err := json.Unmarshal([]byte(EmissionData), &carbon)
//	if err != nil {
//		return "", fmt.Errorf("Failed while unmarshling Emission records %s", err.Error())
//	}

//	carbonAsBytes, err := json.Marshal(carbon)
//	if err != nil {
//		return "", fmt.Errorf("Failed while marshling Emission records %s", err.Error())
//	}




//	var CarbonEmission string = (CarbonPerYear / CarbonKiloWatt )

//	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(carbon.CarbonEmission, carbonAsBytes)
//}



// GetAssetHistory returns the chain of custody for an asset since issuance.
func (s *SmartContract) GetAssetHistory(ctx contractapi.TransactionContextInterface, CitizenID string) ([]HistoryQueryResult, error) {
	log.Printf("GetAssetHistory: ID %v", CitizenID)

	resultsIterator, err := ctx.GetStub().GetHistoryForKey(CitizenID)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var records []HistoryQueryResult
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var asset Asset
		if len(response.Value) > 0 {
			err = json.Unmarshal(response.Value, &asset)
			if err != nil {
				return nil, err
			}
		} else {
			asset = Asset{
				CitizenID: CitizenID,
			}
		}

		timestamp, err := ptypes.Timestamp(response.Timestamp)
		if err != nil {
			return nil, err
		}

		record := HistoryQueryResult{
			TxId:      response.TxId,
			Timestamp: timestamp,
			Record:    &asset,
			IsDelete:  response.IsDelete,
		}
		records = append(records, record)
	}

	return records, nil
}


// UpdateAsset updates an existing asset in the world state with provided parameters.
//func (s *SmartContract) UpdateRecords(ctx contractapi.TransactionContextInterface, CitizenID string, firstname string, lastname string, gender string, dob string, address string , familymembers s/string , wageperfamily string , smartmeterid string , fueltype string , economicactivity string) error {
//	exists, err := s.AssetExists(ctx, CitizenID)

//	if err != nil {
//		return err
//	}
//	if !exists {
//		return fmt.Errorf("the asset %s does not exist", CitizenID)
//	}
//
//	// overwriting original asset with new asset
//	asset := Asset{
//	
	
//	CitizenID:            CitizenID,
//	FirstName:           firstname,
//	LastName:            lastname,
//	Gender:              gender,
//	DOB:                 dob,
//	Address:             address,
//      FamilyMembers:       familymembers,
//       WagePerFamily:       wageperfamily,
//        SmartMeterID:        smartmeterid,
//        TypeOfFuel:          fueltype,
//        EconomicActivity:    economicactivity,
//        
//	}
//	assetJSON, err := json.Marshal(asset)
//	if err != nil {
//		return err
//	}
//
//	return ctx.GetStub().PutState(CitizenID, assetJSON)
//}

// DeleteAsset deletes an given asset from the world state.
//func (s *SmartContract) DeleteAsset(ctx contractapi.TransactionContextInterface, CitizenID string) error {
//	exists, err := s.AssetExists(ctx, CitizenID)
//	if err != nil {
//		return err
//	}
//	if !exists {
//		return fmt.Errorf("the asset %s does not exist", CitizenID)
//	}
//
//	return ctx.GetStub().DelState(CitizenID)
//}

// AssetExists returns true when asset with given ID exists in world state
func (s *SmartContract) AssetExists(ctx contractapi.TransactionContextInterface, CitizenID string) (bool, error) {
	assetJSON, err := ctx.GetStub().GetState(CitizenID)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return assetJSON != nil, nil
}

// TransferAsset updates the owner field of asset with given id in world state.
//func (s *SmartContract) TransferAsset(ctx contractapi.TransactionContextInterface, id string, newOwner string) error {/
//	asset, err := s.ReadAsset(ctx, id)
//	if err != nil {
//		return err
//	}

//	asset.Owner = newOwner
//	assetJSON, err := json.Marshal(asset)
//	if err != nil {
//		return err
//	}

//	return ctx.GetStub().PutState(id, assetJSON)
//}

// GetAllAssets returns all assets found in world state
//func (s *SmartContract) GetAllAssets(ctx contractapi.TransactionContextInterface) ([]*Asset, error) {
	// range query with empty string for startKey and endKey does an
	// open-ended query of all assets in the chaincode namespace.
//	resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
//	if err != nil {
//		return nil, err
//	}
//	defer resultsIterator.Close()

//	var assets []*Asset
//	for resultsIterator.HasNext() {
//		queryResponse, err := resultsIterator.Next()
//		if err != nil {
//			return nil, err
//		}

//		var asset Asset
//		err = json.Unmarshal(queryResponse.Value, &asset)
//		if err != nil {
//			return nil, err
//		}
//		assets = append(assets, &asset)
//	}

//	return assets, nil
//}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error create kyc chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting kyc chaincode: %s", err.Error())
	}
	
	}
