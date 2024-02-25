Docker Compose File Analysis and Setup Guide MiniLAB
==============================================================

This document serves as a comprehensive guide to understanding and setting up the Docker Compose file for a robust home network infrastructure. It outlines the configuration of various services including WireGuard, WireGuard UI, Homepage, STEP-CA, Unbound, and Pi-hole within a Docker environment. Additionally, it provides instructions for initial setup and customization tips to enhance security and functionality.

Overview

The Docker Compose file is designed to deploy a set of interconnected services that work together to provide a secure, efficient, and user-friendly network management solution. The services configured in this Docker Compose file are as follows:

*   **WireGuard**: A modern VPN service that aims to be faster, simpler, and leaner than IPsec. It provides secure and private communication between devices.
*   **WireGuard UI**: A web-based user interface for managing WireGuard configurations easily.
*   **Homepage**: A customizable homepage for your network, providing quick access to commonly used websites and services.
*   **STEP-CA**: A simple, powerful, and flexible Certificate Authority (CA) for secure communication.
*   **Unbound**: A validating, recursive, and caching DNS resolver that provides added security by validating DNS responses.
*   **Pi-hole**: A network-wide ad blocker that acts as a DNS sinkhole to protect your devices from unwanted content.

Initial Setup and Configuration

Before deploying the Docker Compose stack, follow these preliminary steps to ensure a smooth setup:

### Setup STEP-CA

1.  Create a dedicated directory for STEP-CA:
    
    shell
    
    Copy code
    
    `mkdir -p "$PWD/volumes/step-ca"`
    
2.  Change the owner of the directory to match the Docker user IDs:
    
    shell
    
    Copy code
    
    `sudo chown -R 1000:1000 "$PWD/volumes/step-ca"`
    
3.  Initialize the STEP-CA configuration:
    
    shell
    
    Copy code
    
    `docker run --rm -it -v "$PWD/volumes/step-ca:/home/step" smallstep/step-ca step ca init`
    
4.  Secure the CA with a password:
    
    shell
    
    Copy code
    
    `echo PasswordCA | sudo tee "$PWD/volumes/step-ca/secrets/password" sudo chown -R 1000:1000 "$PWD/volumes/step-ca/secrets/password"`
    

### Customize Configuration Files

It is highly recommended to review and customize all files ending with "\_example" to fit your specific needs. This may include environment variables, network settings, and service configurations.

Docker Compose Services
-----------------------

Below is a detailed explanation of each service defined in the Docker Compose file:

### WireGuard

*   **Purpose**: Secure VPN service for private communication.
*   **Configuration**:
    *   Exposes port `5000` and maps UDP port `51820` for VPN traffic.
    *   Utilizes `NET_ADMIN` and `SYS_MODULE` capabilities for network management.
    *   Stores configuration in `./volumes/wireguard/config`.
    *   Uses an environment file `.env_wire` for environment variables.

WireGuard UI

*   **Purpose**: Web UI for managing WireGuard configurations.
*   **Configuration**:
    *   Depends on the WireGuard service.
    *   Shares volumes with WireGuard for configuration management.
    *   Uses the same network mode as WireGuard for simplified networking.

Homepage

*   **Purpose**: Customizable homepage for easy access to network services.
*   **Configuration**:
    *   Uses DNS settings to integrate with internal network DNS services.
    *   Exposes port `3000` for web access.
    *   Configurable via volumes for persistent settings and service links.

### STEP-CA

*   **Purpose**: Certificate Authority for secure communication.
*   **Configuration**:
    *   Exposes port `9000` for CA services.
    *   Stores configuration and certificates in `./volumes/step-ca`.

### Unbound

*   **Purpose**: DNS resolver for added security and privacy.
*   **Configuration**:
    *   Configured as a container named `unbound`.
    *   Exposes DNS port `53` for resolving queries.
    *   Stores configuration in `./volumes/unbound`.

### Pi-hole

*   **Purpose**: Network-wide ad blocking and DNS service.
*   **Configuration**:
    *   Depends on Unbound for DNS resolution.
    *   Exposes multiple ports for DNS, web interface, and optional services.
    *   Stores configuration and custom lists in `./volumes/pihole_data` and `./volumes/pihole_custom_list/custom.list`.

Network Configuration
---------------------

The services are configured to communicate over a custom network `admin-subnet`, defined with a subnet of `100.100.100.0/24`. This setup facilitates easy service discovery and secure internal communication.

Logging

Each service is configured with `json-file` logging, capped at a maximum size of `10m` and a maximum file count of `3` to manage disk usage effectively.

## TODO
'''
All is work in progress i would like to make some script tu aoutomatizies all, and i working on a podman vertion rootless.
If you wanna help just contact me.

'''
### Not use the script for step-ca-