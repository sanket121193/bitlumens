createcertificatesForadmin1() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/admin1.bitlumens.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.admin1.bitlumens.com --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-admin1-bitlumens-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-admin1-bitlumens-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-admin1-bitlumens-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-admin1-bitlumens-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.admin1.bitlumens.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.admin1.bitlumens.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.admin1.bitlumens.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.admin1.bitlumens.com --id.name admin1admin --id.secret admin1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/admin1.bitlumens.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.admin1.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/msp --csr.hosts peer0.admin1.bitlumens.com --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.admin1.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls --enrollment.profile tls --csr.hosts peer0.admin1.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/tlsca/tlsca.admin1.bitlumens.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer0.admin1.bitlumens.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/ca/ca.admin1.bitlumens.com-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p ../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.admin1.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com/msp --csr.hosts peer1.admin1.bitlumens.com --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.admin1.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com/tls --enrollment.profile tls --csr.hosts peer1.admin1.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/peers/peer1.admin1.bitlumens.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/admin1.bitlumens.com/users
  mkdir -p ../crypto-config/peerOrganizations/admin1.bitlumens.com/users/User1@admin1.bitlumens.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.admin1.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/users/User1@admin1.bitlumens.com/msp --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/admin1.bitlumens.com/users/Admin@admin1.bitlumens.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://admin1admin:admin1adminpw@localhost:7054 --caname ca.admin1.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/users/Admin@admin1.bitlumens.com/msp --tls.certfiles ${PWD}/fabric-ca/admin1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/admin1.bitlumens.com/users/Admin@admin1.bitlumens.com/msp/config.yaml

}

# createcertificatesForadmin1

createCertificateForadmin2() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/admin2.bitlumens.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.admin2.bitlumens.com --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-admin2-bitlumens-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-admin2-bitlumens-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-admin2-bitlumens-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-admin2-bitlumens-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.admin2.bitlumens.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  echo
  echo "Register peer1"
  echo

  fabric-ca-client register --caname ca.admin2.bitlumens.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.admin2.bitlumens.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.admin2.bitlumens.com --id.name admin2admin --id.secret admin2adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/admin2.bitlumens.com/peers
  mkdir -p ../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.admin2.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/msp --csr.hosts peer0.admin2.bitlumens.com --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.admin2.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls --enrollment.profile tls --csr.hosts peer0.admin2.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/tlsca/tlsca.admin2.bitlumens.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer0.admin2.bitlumens.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/ca/ca.admin2.bitlumens.com-cert.pem

  # --------------------------------------------------------------------------------
  #  Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.admin2.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer1.admin2.bitlumens.com/msp --csr.hosts peer1.admin2.bitlumens.com --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer1.admin2.bitlumens.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.admin2.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer1.admin2.bitlumens.com/tls --enrollment.profile tls --csr.hosts peer1.admin2.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer1.admin2.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer1.admin2.bitlumens.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer1.admin2.bitlumens.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer1.admin2.bitlumens.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer1.admin2.bitlumens.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/peers/peer1.admin2.bitlumens.com/tls/server.key
  # -----------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/admin2.bitlumens.com/users
  mkdir -p ../crypto-config/peerOrganizations/admin2.bitlumens.com/users/User1@admin2.bitlumens.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.admin2.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/users/User1@admin2.bitlumens.com/msp --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/admin2.bitlumens.com/users/Admin@admin2.bitlumens.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://admin2admin:admin2adminpw@localhost:8054 --caname ca.admin2.bitlumens.com -M ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/users/Admin@admin2.bitlumens.com/msp --tls.certfiles ${PWD}/fabric-ca/admin2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/admin2.bitlumens.com/users/Admin@admin2.bitlumens.com/msp/config.yaml

}

# createCertificateForadmin2

createCretificateForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/bitlumens.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/bitlumens.com

  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer2"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer3"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register the orderer admin"
  echo

  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/bitlumens.com/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/bitlumens.com/orderers/bitlumens.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/msp --csr.hosts orderer.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/tls --enrollment.profile tls --csr.hosts orderer.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/msp/tlscacerts/tlsca.bitlumens.com-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/msp/tlscacerts/tlsca.bitlumens.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com

  echo
  echo "## Generate the orderer2 msp"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/msp --csr.hosts orderer2.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/msp/config.yaml

  echo
  echo "## Generate the orderer2-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/tls --enrollment.profile tls --csr.hosts orderer2.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer2.bitlumens.com/msp/tlscacerts/tlsca.bitlumens.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com

  echo
  echo "## Generate the orderer3 msp"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/msp --csr.hosts orderer3.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/tls --enrollment.profile tls --csr.hosts orderer3.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer3.bitlumens.com/msp/tlscacerts/tlsca.bitlumens.com-cert.pem
  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/bitlumens.com/users
  mkdir -p ../crypto-config/ordererOrganizations/bitlumens.com/users/Admin@bitlumens.com

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/users/Admin@bitlumens.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/users/Admin@bitlumens.com/msp/config.yaml

}

# createCretificateForOrderer


createCryptomaterialsForOrderer4() {

  # -------------Orderer 4----------------------
  mkdir -p ../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com

  echo
  echo "## Generate the orderer4 msp"
  echo

  fabric-ca-client enroll -u https://orderer4:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/msp --csr.hosts orderer4.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer4:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/tls --enrollment.profile tls --csr.hosts orderer4.bitlumens.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/bitlumens.com/orderers/orderer4.bitlumens.com/msp/tlscacerts/tlsca.bitlumens.com-cert.pem

}


 rm -rf ../crypto-config/*
# sudo rm -rf fabric-ca/*
createcertificatesForadmin1
createCertificateForadmin2
createCretificateForOrderer

# createCryptomaterialsForOrderer4
