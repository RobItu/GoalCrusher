# Chainlink NodeJS External Adapter

This folder contains the external adapter built to receive user daily health data from fitbit. Once the API-specific values (headers and API key authentication) have been added to the adapter, data will be formatted when returned to the Chainlink node. There is no need to use any additional frameworks or to run a Chainlink node in order to test the adapter.
## Create adapter
I used [this](https://github.com/thodges-gh/CL-EA-NodeJS-Template "CL-EA-NodeJS-Template") to create my adapter. Or you can just copy the files above.

## FitBit API
- Create a developer account and register an app.

   Make sure all Redirect URI fields point to http://localhost
   Allow Read and Write access
   [OAuth 2.0 tutorial page is very helpful](https://dev.fitbit.com/apps/oauthinteractivetutorial?clientEncodedId=238VNJ&clientSecret=707495e811e6a3e100516d5eb53d224c&redirectUri=http://localhost&applicationType=PERSONAL) is very helpful too


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

