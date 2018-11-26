This uses a tool called [`lambda-uploader`](https://github.com/rackerlabs/lambda-uploader)
to maintain the Lambda script.

## Install

```
pip install -r requirements.txt
```

## Deployment

```
lambda-uploader --config zoo-stats-api-graphql_staging.json
```

## Useful settings in that config file

* The name is just a unique identifier for this specific lambda function
* The role specified in it must have access to the Kinesis stream
* The handler consists of two parts. The first is basically just the filename
  of the python script (without extension). The second is the name of the
  function inside that Python file that should be called.  Here it's called
  `zoo-stats-api-graphql.py` with a function `lambda_handler`, therefore the handler
  field is set to `zoo-stats-api-graphql.lambda_handler`
