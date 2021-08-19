#!/usr/bin/env bash

# This script generates certificate for client vpn

[ -z "$1" ] && echo "Usage: $0 first.last" && exit 1

export EASYRSA_BATCH=1

client="$1"
cert_domain="nonprod.vpn.ca"
client_full="${client}.${cert_domain}"
outfile="/tmp/${client}-cvpn-endpoint.ovpn"
vpn_endpoint_id="cvpn-endpoint-001231324234"

tput setaf 2; echo ">> clone repo ..."; tput setaf 9
cd $(mktemp -d)
git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3

tput setaf 2; echo ">> init ..."; tput setaf 9
./easyrsa init-pki
./easyrsa build-ca nopass
rm -f pki/ca.crt
rm -f pki/private/ca.key

tput setaf 2; echo ">> get ca crt/key from param store ..."; tput setaf 9
aws acm get-certificate \
    --certificate-arn arn:aws:acm:eu-west-1:654001826221:certificate/52355f71-9c62-4d08-80b2-e2c754ed4f6c \
    --output text > pki/ca.crt
aws secretsmanager get-secret-value \
    --secret-id nonprod_ca_openvpn_key \
    --query SecretString \
    --output text > pki/private/ca.key

tput setaf 2; echo ">> create and import crt/key for $client ..."; tput setaf 9
./easyrsa build-client-full ${client_full} nopass
# aws acm import-certificate \
#     --certificate fileb://pki/issued/${client_full}.crt \
#     --private-key fileb://pki/private/${client_full}.key \
#     --certificate-chain fileb://pki/ca.crt

tput setaf 2; echo ">> generate vpn client config file ..."; tput setaf 9
aws ec2 export-client-vpn-client-configuration \
    --client-vpn-endpoint-id $vpn_endpoint_id \
    --output text >| $outfile
sed -i~ "s/^remote /remote ${client}./" "${outfile}"
echo "<cert>"                      >> "${outfile}"
cat pki/issued/${client_full}.crt  >> "${outfile}"
echo "</cert>"                     >> "${outfile}"
echo "<key>"                       >> "${outfile}"
cat pki/private/${client_full}.key >> "${outfile}"
echo "</key>"                      >> "${outfile}"

tput setaf 2; echo ">> ${outfile} ..."; tput setaf 9
ls -alh "${outfile}"