# docker-whosonfirst-data-distributions

WORK IN PROGRESS.

## AWS

### Roles

You will need to make sure you have a role with the following (default) AWS policies:

* `AmazonECSTaskExecutionRolePolicy`

In addition you will need the following custom policies:

* TBD...

### Security groups

Create a new `whosonfirst-data-indexing` security and disallow _all_ inbound ports.

## Lambda

### webhookd-lambda-task

#### Environment variables

| Key | Value |
| --- | --- |
| WEBHOOKD_MODE | `lambda` |
| WEBHOOKD_COMMAND | `/usr/local/bin/wof-test-distributions %s` |
| WEBHOOKD_ECS_CLUSTER | `whosonfirst` |
| WEBHOOKD_ECS_CONTAINER | `whosonfirst-data-distributions` |
| WEBHOOKD_ECS_DSN | `credentials=iam: region={AWS_REGION}` |
| WEBHOOKD_ECS_SECURITY_GROUP | `{EC2_SECURITY_GROUP}` |
| WEBHOOKD_ECS_SUBNET | `{AWS_SUBNET1},{AWS_SUBNET2}...` |
| WEBHOOKD_ECS_TASK | `whosonfirst-data-indexing:{N}` |

## See also

* https://github.com/whosonfirst/go-whosonfirst-github
* https://github.com/whosonfirst/go-whosonfirst-dist
* https://github.com/whosonfirst/go-whosonfirst-dist-publish