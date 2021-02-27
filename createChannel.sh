export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/msp/tlscacerts/tlsca.bitlumens.com-cert.pem
export PEER0_admin1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/ca.crt
export PEER0_admin2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=mychannel

# setGlobalsForOrderer(){
#     export CORE_PEER_LOCALMSPID="OrdererMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/msp/tlscacerts/tlsca.bitlumens.com-cert.pem
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/bitlumens.com/users/Admin@bitlumens.com/msp
    
# }

setGlobalsForPeer0admin1(){
    export CORE_PEER_LOCALMSPID="admin1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_admin1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin1.bitlumens.com/users/Admin@admin1.bitlumens.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1admin1(){
    export CORE_PEER_LOCALMSPID="admin1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_admin1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin1.bitlumens.com/users/Admin@admin1.bitlumens.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
}

setGlobalsForPeer0admin2(){
    export CORE_PEER_LOCALMSPID="admin2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_admin2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin2.bitlumens.com/users/Admin@admin2.bitlumens.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
}

setGlobalsForPeer1admin2(){
    export CORE_PEER_LOCALMSPID="admin2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_admin2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/admin2.bitlumens.com/users/Admin@admin2.bitlumens.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
    
}

createChannel(){
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0admin1
    
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.bitlumens.com \
    -f ./artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

removeOldCrypto(){
    rm -rf ./api-1.4/crypto/*
    rm -rf ./api-1.4/fabric-client-kv-admin1/*
    rm -rf ./api-2.0/admin1-wallet/*
    rm -rf ./api-2.0/admin2-wallet/*
}


joinChannel(){
    setGlobalsForPeer0admin1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer1admin1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer0admin2
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer1admin2
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
}

updateAnchorPeers(){
    setGlobalsForPeer0admin1
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.bitlumens.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0admin2
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.bitlumens.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}

removeOldCrypto

createChannel
joinChannel
updateAnchorPeers
