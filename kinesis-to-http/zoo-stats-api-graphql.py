import os
import json
import base64
import requests
from requests.auth import HTTPBasicAuth

HEADERS  = {"Content-Type": "application/json", "Accept": "application/json"}
ENDPOINT = os.environ["GRAPHQL_ENDPOINT"]  # "https://stats.zooniverse.org/graphql"
USERNAME = os.environ["GRAPHQL_MUTATION_USERNAME"]
PASSWORD = os.environ["GRAPHQL_MUTATION_PASSWORD"]
MUTATION = "mutation ($graphql_payload: String!){ createEvent(eventPayload: $graphql_payload){ errors } }"

def lambda_handler(event, context):
  payloads = [json.loads(base64.b64decode(record["kinesis"]["data"])) for record in event["Records"]]
  dicts    = [payload for payload in payloads if should_send(payload)]

  if dicts:
    mutation_request = { "query": MUTATION, "variables": {"graphql_payload": json.dumps(dicts)} }
    r = requests.post(ENDPOINT, auth=HTTPBasicAuth(USERNAME, PASSWORD), headers=HEADERS, json=mutation_request)
    r.raise_for_status()

def should_send(payload):
  return payload["source"] == "panoptes" and payload["type"] == "classification"
