GenerateArtifacts() {
    rm genesis.block mychannel.tx
    rm -rf ../../channel-artifacts/*

    # System channel
    SYS_CHANNEL="sys-channel"

    # channel name defaults to "mychannel"
    CHANNEL_NAME="mychannel"

    # Generate System Genesis block
    configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL -outputBlock ./genesis.block

    # Generate channel configuration block
    configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./mychannel.tx -channelID $CHANNEL_NAME

    echo "#######    Generating anchor peer update for Org1MSP  ##########"
    configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./admin1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg admin1MSP

    echo "#######    Generating anchor peer update for Org2MSP  ##########"
    configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./admin2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg admin2MSP
}

GenerateArtifacts
