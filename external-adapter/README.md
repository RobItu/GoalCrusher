# Chainlink NodeJS FitBit External Adapter

This folder contains the external adapter built to receive user daily health data from fitbit. Once the API-specific values (headers and API key authentication) have been added to the adapter, data will be formatted when returned to the Chainlink node. There is no need to use any additional frameworks or to run a Chainlink node in order to test the adapter.

## Create adapter
I used [this](https://github.com/thodges-gh/CL-EA-NodeJS-Template "CL-EA-NodeJS-Template") to create my adapter. Or you can just copy the files above.

## FitBit API
- Create a developer account and register an app [here](https://dev.fitbit.com/login) .
- Make sure Redirect URI field points to `http://localhost`
- Allow Read and Write access
- [OAuth 2.0 tutorial page](https://dev.fitbit.com/apps/oauthinteractivetutorial?clientEncodedId=238VNJ&clientSecret=707495e811e6a3e100516d5eb53d224c&redirectUri=http://localhost&applicationType=PERSONAL) is very helpful too


## Call the external adapter/API server
Make sure you have started the adapter with
```bash
yarn start
```
On a separate terminal, run:

```bash
curl -X POST -H "content-type:application/json" "http://localhost:8080/" --data '{ "id": 0, "data": {"date":"today"} }'
```
"today" can be replaced with a specific date in mm/dd/yyyy
```bash
curl -X POST -H "content-type:application/json" "http://localhost:8080/" --data '{ "id": 0, "data": {"date":"mm/dd/yyyy"} }'
```
## Output
```bash
{"jobRunID":1,"data":{"activities":[],"goals":{"activeMinutes":30,"caloriesOut":2603,"distance":8.05,"floors":10,"steps":10000},"summary":{"activeScore":-1,"activityCalories":773,"caloriesBMR":1036,ut":1645,"distances":[{"activity":"total","distance":3.81},{"activity":"tracker","distance":3.81},{"activity":"loggedActivities","distance":0},{"activity":"veryActive","distance":0.35},{"activity":"Active","distance":0.23},{"activity":"lightlyActive","distance":3.23},{"activity":"sedentaryActive","distance":0}],"elevation":30.48,"fairlyActiveMinutes":8,"floors":10,"heartRateZones":[{"caloriesO1629,"max":99,"min":30,"minutes":661,"name":"Out of Range"},{"caloriesOut":132.16405,"max":138,"min":99,"minutes":24,"name":"Fat Burn"},{"caloriesOut":0,"max":168,"min":138,"minutes":0,"name":"CardiriesOut":0,"max":220,"min":168,"minutes":0,"name":"Peak"}],"lightlyActiveMinutes":187,"marginalCalories":413,"restingHeartRate":58,"sedentaryMinutes":476,"steps":5651,"veryActiveMinutes":7},"result":null,"statusCode":200}
```

## Chainlink node job config
This is the configuration in TOML for the Chainlink node job in order to send multiple responses (in this case, calories expended and calories goal.)

```bash
type = "directrequest"
schemaVersion = 1
name = "fitbit multivariable response"
externalJobID = "6aaad23b-7858-49b1-a22a-9da3a88fdc2b"
forwardingAllowed = false
maxTaskDuration = "0s"
contractAddress = "0x4e07bDC58A5441cfE3FdEa2f293b4bc721f413D0"
minContractPaymentLinkJuels = "0"
observationSource = """
    decode_log   [type="ethabidecodelog"
                  abi="OracleRequest(bytes32 indexed specId, address requester, bytes32 requestId, uint256 payment, address callbackAddr, bytes4 callbackFunctionId, uint256 cancelExpiration, uint256 dataVersion, bytes data)"
                  data="$(jobRun.logData)"
                  topics="$(jobRun.logTopics)"]

    decode_cbor  [type="cborparse" data="$(decode_log.data)"]
    fetch        [type=bridge name=testbridge requestData="{\\"id\\":$(jobSpec.externalJobID), \\"data\\":{\\"date\\":$(decode_cbor.date)}}"]
    parse1        [type="jsonparse" path="data,summary,caloriesOut" data="$(fetch)"]
parse2        [type="jsonparse" path="data,goals,caloriesOut" data="$(fetch)"]
    encode_data  [type="ethabiencode" abi="(bytes32 requestId, uint256 value, uint256 value2)" data="{ \\"requestId\\": $(decode_log.requestId), \\"value\\": $(parse1), \\"value2\\": $(parse2) }"]
    encode_tx    [type="ethabiencode"
                  abi="fulfillOracleRequest2(bytes32 requestId, uint256 payment, address callbackAddress, bytes4 callbackFunctionId, uint256 expiration, bytes calldata data)"
                  data="{\\"requestId\\": $(decode_log.requestId), \\"payment\\": $(decode_log.payment), \\"callbackAddress\\": $(decode_log.callbackAddr), \\"callbackFunctionId\\": $(decode_log.callbackFunctionId), \\"expiration\\": $(decode_log.cancelExpiration), \\"data\\": $(encode_data)}"
                 ]
    submit_tx    [type="ethtx" to="0x4e07bDC58A5441cfE3FdEa2f293b4bc721f413D0" data="$(encode_tx)"]

    decode_log -> decode_cbor -> fetch -> parse1 -> encode_data -> encode_tx -> submit_tx
fetch -> parse2 -> encode_data
"""
```
### More resources
More information/help regarding chainlink nodes and external adapters can be found:
- [External Adapters](https://docs.chain.link/chainlink-nodes/external-adapters/external-adapters)
- [Running a Chainlink node](https://docs.chain.link/chainlink-nodes/running-a-chainlink-node)
- [Chainlink node jobs](https://docs.chain.link/chainlink-nodes/fulfilling-requests)
- [Chainlink Any API](https://docs.chain.link/any-api/introduction)
