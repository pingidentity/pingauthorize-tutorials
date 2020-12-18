# PingDataGovernance tutorial source files

## Overview

This repository contains companion source files to be used with the PingDataGovernance tutorials found at
<https://documentation.pingidentity.com>.

## Prerequisites

* `docker` (version 19.03.12)
* `docker-compose` (version 1.26.2)
* You have followed the documentation at
  <https://pingidentity-devops.gitbook.io/devops/getstarted> to obtain a DevOps
  key and set up the `ping-devops` environment and command-line tool (version
  0.6.8).

## Configuration

The following table lists the default ports used and their respective environment variables. To change the default ports
used by the tutorials, copy the provided `env-template.txt` file to `.env` for use by `docker-compose` and then modify
the ports.

| Environment variable                 | Default port | Description                         |
| ------------------------------------ | -----------: | ----------------------------------- |
| PDG\_TUTORIALS\_CONSOLE\_PORT        | 5443         | The PingData Console port.          |
| PDG\_TUTORIALS\_DG\_PORT             | 7443         | The PingDataGovernance Server port. |
| PDG\_TUTORIALS\_PAP\_PORT            | 8443         | The Policy Administration GUI port. |

## Usage

### Bringing up the environment

1. Copy the `env-template.txt` file to `.env` if you have not already done so.

```bash
cp env-template.txt .env
```

2. Run the following command to bring up the environment.

```bash
docker-compose up --detach
```

3. Once the containers are started, it will take a few minutes (up to 15 on some systems) for them to become
   healthy. You can determine their state by running the following command:

```bash
docker container ls --format '{{ .Names }}: {{ .Status }}'
```

Eventually all 4 containers should have the `healthy` status.

### Bringing down the environment

1. To stop and remove the containers, run the command:

```bash
docker-compose down
```

Note that any progress made on the tutorials will be cleared after the containers are removed.

## Provided servers

Baseline `docker-compose.yml` for DG/PAP/Directory environment. The PingData Console may be used to administer both
PingDirectory and PingDataGovernance by logging in with the correct value in the `Server` field.

| Product                   | URL                                | PingDataConsole `Server`      | Username        | Password          |
| ------------------------- | ---------------------------------- | ----------------------------  | --------------- | ----------------- |
| PingData Console          | <https://localhost:5443/console/>  | N/A                           | N/A             | N/A               |
| PingDirectory             | N/A                                | `pingdirectory:636`           | `administrator` | `2FederateM0re`   |
| PingDataGovernance        | N/A                                | `pingdatagovernance:636`      | `administrator` | `2FederateM0re`   |
| Policy Administration GUI | <https://localhost:8443>           | N/A                           | `admin`         | `password123`     |

