# API Documentation

## GraphQL end point

### POST /graphql (application/json)

There is only one endpoint path for this API `/graphql` and it only supports the `POST` HTTP method for the `application/json` content type.

#### Introspect the available operations

``` sh
curl -d '{"query": "{__schema {queryType {name fields {name}}mutationType {name fields {name}}}}"}' -H "Content-Type: application/json" -X POST https://graphql-stats.zooniverse.org/graphql
```

#### Event type counts per interval

Retrieve the number of classifications for a specified event type for a known interval. Non-required attributes are `projectID` and `userId` to filter the results.

Note: If you supply the the userId attribute you **must** provide a bearer token in the Authorization header, e.g.
`Authorization: Bearer <TOKEN>`

You must supply and `eventType`, `interval` and `window`. Valid intervals are postgres intervals, e.g. `2 Days`, `24 Hours`, `60 Seconds`
Valid windows are postgres intervals, e.g. `7 Days`, `2 Weeks`, `1 Month`, `1 Year`.

``` JSON
{
  statsCount(
    eventType: "classification",
    interval: "1 Day",
    window: "1 week",
    projectId: "${project.id}",
    userId: "${user.id}"
  ){
    period,
    count
  }
}
```

Note: `classification` events are currently the only supported event types in this API end point.

## RESTful end points

### GET /counts/day/groups (application/json)

Retrieve a groups daily event count, this end point accepts query params that:

1. limit the number of results e.g. `/counts/day/groups?limit=10`
2. order of the events in time e.g. `/counts/day/groups?order=asc`

Below is an example of the returned JSON data

``` JSON
{
  "events_over_time": {
    "buckets": [
      {
        "period": "2021-06-18T00:00:00.000Z",
        "group_id": 489,
        "count": 1
      },
      {
        "period": "2021-06-18T00:00:00.000Z",
        "group_id": 932,
        "count": 1
      }
    ]
  }
}
```

### GET /counts/day/groups/:group_id (application/json)

Retrieve a specific group's daily event count, e.g. `/counts/day/groups/489`

Below is an example of the returned JSON data

``` JSON
{
  "events_over_time": {
    "buckets": [
      {
        "period": "2021-06-18T00:00:00.000Z",
        "group_id": 489,
        "count": 1
      },
      {
        "period": "2021-06-19T00:00:00.000Z",
        "group_id": 489,
        "count": 1
      }
    ]
  }
}
```
