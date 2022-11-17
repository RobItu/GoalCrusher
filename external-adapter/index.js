const { Requester, Validator } = require("@chainlink/external-adapter");
require("dotenv").config();

// Define custom error scenarios for the API.
// Return true for the adapter to retry.
const customError = (data) => {
  if (data.Response === "Error") return true;
  return false;
};

//custom parameters to be used by the adapter.

const customParams = {
  date: ["date"],
  endpoint: false,
};

const createRequest = (input, callback) => {
  // The Validator helps you validate the Chainlink request data
  const validator = new Validator(callback, input, customParams);
  const jobRunID = validator.validated.id;

  const access_token = process.env.ACCESS_TOKEN;
  const date_parameter = validator.validated.data.date;

  const url = `https://api.fitbit.com/1/user/-/activities/date/${date_parameter}.json`;

  const params = {
    date_parameter,
  };

  // Method and headers
  const config = {
    url,
    params,
    method: "GET",
    headers: { Authorization: "Bearer " + access_token },
  };

  // The Requester allows API calls be retry in case of timeout
  // or connection failure
  Requester.request(config, customError)
    .then((response) => {
      callback(response.status, Requester.success(jobRunID, response));
    })
    .catch((error) => {
      callback(500, Requester.errored(jobRunID, error));
    });
};

// This is a wrapper to allow the function to work with
// GCP Functions
exports.gcpservice = (req, res) => {
  createRequest(req.body, (statusCode, data) => {
    res.status(statusCode).send(data);
  });
};

// This is a wrapper to allow the function to work with
// AWS Lambda
exports.handler = (event, context, callback) => {
  createRequest(event, (statusCode, data) => {
    callback(null, data);
  });
};

// This is a wrapper to allow the function to work with
// newer AWS Lambda implementations
exports.handlerv2 = (event, context, callback) => {
  createRequest(JSON.parse(event.body), (statusCode, data) => {
    callback(null, {
      statusCode: statusCode,
      body: JSON.stringify(data),
      isBase64Encoded: false,
    });
  });
};

module.exports.createRequest = createRequest;
