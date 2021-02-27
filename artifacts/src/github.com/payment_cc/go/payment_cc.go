package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing an Asset
type SmartContract struct {
	contractapi.Contract
}

// Asset describes basic details of what makes up a simple asset
type Payment struct {

    TransactionID         string `json:"transactionID"`
    FirstName             string `json:"firstname"`
    LastName              string `json:"lastname"`
    Latitude              string `json:"latitude"`
    Longitude             string `json:"longitude"`
    PaymentMethod         string `json:"paymentmethod"`
    Amount	           string `json:"amount"`
    Currency              string `json:"currency"`
    IntervalOfPayment     string `json:"intervalofpayment"`
    Date                  string `json:"date"`	
    Status      	   string `json:"status"`
    
}


func (s *SmartContract) PaymentRecords(ctx contractapi.TransactionContextInterface, paymentData string) (string, error) {

	if len(paymentData) == 0 {
		return "", fmt.Errorf("Please pass the correct payment data")
	}

	var payment Payment
	err := json.Unmarshal([]byte(paymentData), &payment)
	if err != nil {
		return "", fmt.Errorf("Failed while unmarshling payments. %s", err.Error())
	}

	paymentAsBytes, err := json.Marshal(payment)
	if err != nil {
		return "", fmt.Errorf("Failed while marshling payments %s", err.Error())
	}

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(payment.TransactionID, paymentAsBytes)
}

// ReadAsset returns the asset stored in the world state with given id.
func (s *SmartContract) GetPaymentsById(ctx contractapi.TransactionContextInterface, transactionID string) (*Payment, error) {
	if len(transactionID) == 0 {
		return nil, fmt.Errorf("Please provide correct transaction Id")
	}

	paymentAsBytes, err := ctx.GetStub().GetState(transactionID)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if paymentAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", transactionID)
	}

	payment := new(Payment)
	_ = json.Unmarshal(paymentAsBytes, payment)

	return payment, nil
}

// UpdateAsset updates an existing asset in the world state with provided parameters.
func (s *SmartContract) UpdatePayments(ctx contractapi.TransactionContextInterface, txID string, amount string, date string) (string, error) {
	if len(txID) == 0 {
		return "", fmt.Errorf("Please provide correct Transaction Id")
		// return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	paymentAsBytes, err := ctx.GetStub().GetState(txID)

	if err != nil {
		return "", fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if paymentAsBytes == nil {
		return "", fmt.Errorf("%s does not exist", txID)
	}

	payment := new(Payment)
	_ = json.Unmarshal(paymentAsBytes, payment)

	payment.TransactionID = txID
	payment.Amount = amount
	payment.Date = date
	payment.Status = "Paid"

	paymentAsBytes, err = json.Marshal(payment)
	if err != nil {
		return "", fmt.Errorf("Failed while marshling payment. %s", err.Error())
	}

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(payment.TransactionID, paymentAsBytes)

}

// DeleteAsset deletes an given asset from the world state.
//func (s *SmartContract) DeleteAsset(ctx contractapi.TransactionContextInterface, citizenid string) error {
//	exists, err := s.AssetExists(ctx, citizenid)
//	if err != nil {
//		return err
//	}
//	if !exists {
//		return fmt.Errorf("the asset %s does not exist", citizenid)
//	}
//
//	return ctx.GetStub().DelState(citizenid)
//}

// AssetExists returns true when asset with given ID exists in world state
//func (s *SmartContract) AssetExists(ctx contractapi.TransactionContextInterface, citizenid string) (bool, error) {
//	assetJSON, err := ctx.GetStub().GetState(citizenid)
//	if err != nil {
//		return false, fmt.Errorf("failed to read from world state: %v", err)
//	}

//	return assetJSON != nil, nil
//}

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
		fmt.Printf("Error create payment chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting payment chaincode: %s", err.Error())
	}
	
	}
