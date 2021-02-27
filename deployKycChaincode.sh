export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/msp/tlscacerts/tlsca.bitlumens.com-cert.pem
export PEER0_admin1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/ca.crt
export PEER0_admin2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=mychannel

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/msp/tlscacerts/tlsca.bitlumens.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/bitlumens.com/users/Admin@bitlumens.com/msp
}

setGlobalsForPeer0admin1() {
    export CORE_PEER_LOCALMSPID="admin1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_admin1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin1.bitlumens.com/users/Admin@admin1.bitlumens.com/msp
    # export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1admin1() {
    export CORE_PEER_LOCALMSPID="admin1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_admin1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin1.bitlumens.com/users/Admin@admin1.bitlumens.com/msp
    export CORE_PEER_ADDRESS=localhost:8051

}

setGlobalsForPeer0admin2() {
    export CORE_PEER_LOCALMSPID="admin2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_admin2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin2.bitlumens.com/users/Admin@admin2.bitlumens.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

}

setGlobalsForPeer1admin2() {
    export CORE_PEER_LOCALMSPID="admin2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_admin2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin2.bitlumens.com/users/Admin@admin2.bitlumens.com/msp
    export CORE_PEER_ADDRESS=localhost:10051

}

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./artifacts/src/github.com/kyc_cc/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup

CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./artifacts/src/github.com/kyc_cc/go"
CC_NAME="kyc_cc"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0admin1
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.admin1 ===================== "
}
# packageChaincode

installChaincode() {
    setGlobalsForPeer0admin1
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.admin1 ===================== "

    # setGlobalsForPeer1admin1
    # peer lifecycle chaincode install ${CC_NAME}.tar.gz
    # echo "===================== Chaincode is installed on peer1.admin1 ===================== "

    setGlobalsForPeer0admin2
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.admin2 ===================== "

    # setGlobalsForPeer1admin2
    # peer lifecycle chaincode install ${CC_NAME}.tar.gz
    # echo "===================== Chaincode is installed on peer1.admin2 ===================== "
}

# installChaincode

queryInstalled() {
    setGlobalsForPeer0admin1
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.admin1 on channel ===================== "
}

approveForMyadmin1() {
    setGlobalsForPeer0admin1
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.bitlumens.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}


checkCommitReadyness() {
    setGlobalsForPeer0admin1
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

approveForMyadmin2() {
    setGlobalsForPeer0admin2

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.bitlumens.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from org 2 ===================== "
}

# approveForMyadmin2

checkCommitReadyness() {

    setGlobalsForPeer0admin1
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_admin1_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0admin1
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.bitlumens.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_admin1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_admin2_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required

}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0admin1
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0admin1
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.bitlumens.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_admin1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_admin2_CA \
        --isInit -c '{"Args":[]}'

}

 # chaincodeInvokeInit

chaincodeInvoke() {
    # setGlobalsForPeer0admin1
    # peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.bitlumens.com \
    # --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} \
    # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_admin1_CA \
    # --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_admin2_CA  \
    # -c '{"function":"initLedger","Args":[]}'

    setGlobalsForPeer0admin1

    # Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.bitlumens.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 \
        --tlsRootCertFiles $PEER0_admin1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_admin2_CA   \
        -c '{"function": "createCar","Args":["Car-ABCDEEE", "Audi", "R8", "Red", "Pavan"]}'

    ## Init ledger
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.bitlumens.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_admin1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_admin2_CA \
        -c '{"function": "initLedger","Args":[]}'
}

# chaincodeInvoke

chaincodeQuery() {
    setGlobalsForPeer0admin2

    # Query all cars
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryAllCars"]}'

    # Query Car by Id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["CAR0"]}'

}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode
presetup

packageChaincode
installChaincode
queryInstalled
approveForMyadmin1
checkCommitReadyness
approveForMyadmin2
checkCommitReadyness
commitChaincodeDefination
queryCommitted
chaincodeInvokeInit
sleep 5
#chaincodeInvoke
sleep 3
#chaincodeQuery
