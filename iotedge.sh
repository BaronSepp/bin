#!/bin/bash

# Check arguments
if [ "$#" -eq  "0" ]; then
	echo 'A device connectionstring should be provided.'
else
	# Setup msft package list
	curl https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > ./microsoft-prod.list
	cp ./microsoft-prod.list /etc/apt/sources.list.d/

	# Setup msft key to keyring
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	cp ./microsoft.gpg /etc/apt/trusted.gpg.d/

	# Install the runtime
	apt-get update
	apt-get install -y moby-engine
	apt-get install -y aziot-edge

	# Configure runtime
	echo '[provisioning]' > /etc/aziot/config.toml
	echo 'source = "manual"' >> /etc/aziot/config.toml
	echo connection_string = \"$1\" >> /etc/aziot/config.toml
	iotedge config apply
fi