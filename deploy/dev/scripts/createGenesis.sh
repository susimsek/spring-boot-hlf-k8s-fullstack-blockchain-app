

export FABRIC_CFG_PATH=${PWD}configtx


configtxgen -profile OneOrgOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block