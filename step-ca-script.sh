#!/bin/bash

# Definizione delle variabili di ambiente
STEP_VERSION="0.15.15"
STEP_CA_VERSION="0.15.15"
INSTALL_DIR="/usr/local/bin"
WORK_DIR="/etc/step-ca"
CA_PASSWORD="your_ca_password" # <--- Cambiare con una password sicura
CA_URL="https://github.com/smallstep/certificates/releases/download/v${STEP_CA_VERSION}"
CA_CONFIG="${WORK_DIR}/config/ca-config.json"
CA_DB="${WORK_DIR}/db"
ROOT_CERT="${WORK_DIR}/certs/root_ca.crt"
ROOT_KEY="${WORK_DIR}/secrets/root_ca_key"
ACME_PROVISIONER_NAME="acme"

# Installazione di step e step-ca
#echo "Scaricamento e installazione di step CLI e step-ca..."
#wget -q "https://github.com/smallstep/cli/releases/download/v${STEP_VERSION}/step-cli_${STEP_VERSION}_amd64.deb" -O step-cli.deb
#wget -q "${CA_URL}/step-ca_${STEP_CA_VERSION}_amd64.deb" -O step-ca.deb
#dpkg -i step-cli.deb step-ca.deb
#rm -f step-cli.deb step-ca.deb

# Creazione della directory di lavoro
mkdir -p "${WORK_DIR}/certs" "${WORK_DIR}/secrets" "${CA_DB}"
chmod -R 700 "${WORK_DIR}/secrets"

# Inizializzazione di step-ca
echo "Inizializzazione di step-ca..."
step ca init \
  --name "Example Root CA" \
  --dns "ca.example.com" \
  --address ":8443" \
  --provisioner admin \
  --password-file <(echo -n "${CA_PASSWORD}") \
  --with-ca-url "${CA_URL}" \
  --no-db

# MV dei file di configurazione e dei certificati nella directory di lavoro
mv $(step path)/config/ca.json "${CA_CONFIG}"
mv $(step path)/certs/root_ca.crt "${ROOT_CERT}"
mv $(step path)/secrets/root_ca_key "${ROOT_KEY}"

# Configurazione di step-ca per utilizzare ACME come provisioner
echo "Configurazione di ACME provisioner..."
step ca provisioner add ${ACME_PROVISIONER_NAME} --type ACME

# Avvio di step-ca
echo "Avvio di step-ca..."
step-ca "${CA_CONFIG}" &
