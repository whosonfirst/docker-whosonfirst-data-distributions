# docker-whosonfirst-data-distributions

WORK IN PROGRESS.

* https://github.com/whosonfirst/whosonfirst-cookbook/blob/master/how_to/building_a_single_repo_distribution.md
* https://github.com/whosonfirst/whosonfirst-cookbook/blob/master/how_to/building_a_combined_distribution.md

## wof-build-distributions

```
./bin/wof-build-distributions -h
usage: build-distributions.sh
options:
-b The name of the S3 bucket to publish distributions to. THIS FLAG WILL BE DEPRECATED SOON.
-c The S3 credentials to use for publishing distributions. THIS FLAG WILL BE DEPRECATED SOON.
-d A valid go-whosonfirst-dist-publish publisher DSN string. THIS FLAG WILL BE DEPRECATED SOON.
-h Print this message.
-o A valid GitHub organization name.
-p A valid prefix for the -b (S3 bucket) flag. THIS FLAG WILL BE DEPRECATED SOON.
-P A prefix to filter GitHub repositories with.
-r The region of the S3 bucket for publishing distributions. THIS FLAG WILL BE DEPRECATED SOON.
-C Build a 'combined' distribution containing two or more repositories.
-D Assume local development (as in not a Docker container) and look for WOF related code in /usr/local/whosonfirst.
-N The name of a 'combined' distribution.
-R Fetch the list of repositories to build using the wof-list-repos tool.
-S A Unix timestamp or ISO8601 duration string to filter GitHub repositories with (include only repositories update since).
```

Soon (no ETA yet) all of the S3 and publisher related flags above will be replace by a single `-B` (or "bucket") flag that will contain any valid [Go Cloud blob/bucket](https://gocloud.dev/howto/blob/) URI.

## Examples

Note that all these examples assume the `-n` (or "dryrun") flag which builds the distribution(s) but does not try to publish them anywhere.

### Single repo

```
$> docker run whosonfirst-data-distributions /usr/local/bin/wof-build-distributions -n whosonfirst-data-admin-xy
Building distributions for: whosonfirst-data-admin-xy
--
/usr/local/bin/wof-dist-build -verbose -timings -custom-repo -workdir /usr/local/data/dist -git-organization whosonfirst-data whosonfirst-data-admin-xy
18:10:49.584253 [wof-dist-build] STATUS time to clone whosonfirst-data-admin-xy 39.7077675s

18:10:49.584740 [wof-dist-build] STATUS local_checkouts are [/usr/local/data/dist/whosonfirst-data-admin-xy]
18:10:49.594570 [wof-dist-build] STATUS commit hashes are map[whosonfirst-data-admin-xy:3c13c846ac8952038b825a2e4a049fcaa63051fe] ([/usr/local/data/dist/whosonfirst-data-admin-xy])
18:11:34.830259 [wof-dist-build] STATUS Built  without any reported errors
18:11:34.830307 [wof-dist-build] STATUS local sqlite is /usr/local/data/dist/whosonfirst-data-admin-xy-latest.db
18:11:36.529379 [wof-dist-build] STATUS time to build UNCOMPRESSED distributions for whosonfirst-data-admin-xy 1m26.6873853s
18:11:36.543247 [wof-dist-build] STATUS register function to compress /usr/local/data/dist/whosonfirst-data-admin-xy-latest.db
18:11:36.548303 [wof-dist-build] STATUS time to wait to start compressing /usr/local/data/dist/whosonfirst-data-admin-xy-latest.db 8.1µs
18:12:01.846138 [wof-dist-build] STATUS All done compressing /usr/local/data/dist/whosonfirst-data-admin-xy-latest.db (throttle)
18:12:01.846262 [wof-dist-build] STATUS time to compress /usr/local/data/dist/whosonfirst-data-admin-xy-latest.db 25.3324694s
18:12:01.846400 [wof-dist-build] STATUS All done compressing /usr/local/data/dist/whosonfirst-data-admin-xy-latest.db
18:12:01.846559 [wof-dist-build] STATUS remove uncompressed file /usr/local/data/dist/whosonfirst-data-admin-xy-latest.db
18:12:01.881334 [wof-dist-build] STATUS time to remove uncompressed files for whosonfirst-data-admin-xy 34.7761ms
18:12:01.881607 [wof-dist-build] STATUS time to build COMPRESSED distributions for whosonfirst-data-admin-xy 1m52.0743262s
18:12:01.882411 [wof-dist-build] STATUS time to build distributions for 1 repos 1m52.0753041s
18:12:01.882488 [wof-dist-build] STATUS ITEMS map[whosonfirst-data-admin-xy:[whosonfirst-data-admin-xy-latest.db]]
18:12:01.883343 [wof-dist-build] STATUS Wrote inventory /usr/local/data/dist/whosonfirst-data-admin-xy-inventory.json
total 40724
drwxr-xr-x    1 root     root          4096 Oct 28 18:12 .
drwxr-xr-x    1 root     root          4096 Aug 10 22:00 ..
-rw-r--r--    1 root     root           541 Oct 28 18:12 whosonfirst-data-admin-xy-inventory.json
-rw-r--r--    1 root     root      41688729 Oct 28 18:12 whosonfirst-data-admin-xy-latest.db.bz2
```

### Multiple repos, combined

```
$> docker run whosonfirst-data-distributions /usr/local/bin/wof-build-distributions -n -C -N xy-xx-combined whosonfirst-data-admin-xy whosonfirst-data-admin-xx
Building distributions for whosonfirst-data-admin-xy whosonfirst-data-admin-xx
--
/usr/local/bin/wof-dist-build -verbose -timings -custom-repo -workdir /usr/local/data/dist -github-organization whosonfirst-data -combined -combined-name xy-xx-combined whosonfirst-data-admin-xy whosonfirst-data-admin-xx
18:15:21.948163 [wof-dist-build] STATUS time to clone xy-xx-combined 51.9917031s

18:15:21.948611 [wof-dist-build] STATUS local_checkouts are [/usr/local/data/dist/whosonfirst-data-admin-xy /usr/local/data/dist/whosonfirst-data-admin-xx]
18:15:21.953106 [wof-dist-build] STATUS commit hashes are map[whosonfirst-data-admin-xx:99181b3dcb5f6675a1e19fdbcdf89784d02df07b whosonfirst-data-admin-xy:3c13c846ac8952038b825a2e4a049fcaa63051fe] ([/usr/local/data/dist/whosonfirst-data-admin-xy /usr/local/data/dist/whosonfirst-data-admin-xx])
18:16:21.912296 [wof-dist-build] STATUS time to index spr (29099) : 16.0643346s
18:16:21.912880 [wof-dist-build] STATUS time to index names (29099) : 13.4859639s
18:16:21.912996 [wof-dist-build] STATUS time to index ancestors (29099) : 5.2488176s
18:16:21.913257 [wof-dist-build] STATUS time to index concordances (29099) : 3.5593885s
18:16:21.913911 [wof-dist-build] STATUS time to index geojson (29099) : 4.3857808s
18:16:21.914177 [wof-dist-build] STATUS time to index all (29099) : 1m0.0246046s
18:16:27.222106 [wof-dist-build] STATUS Built  without any reported errors
18:16:27.222153 [wof-dist-build] STATUS local sqlite is /usr/local/data/dist/xy-xx-combined-latest.db
18:16:30.986459 [wof-dist-build] STATUS time to build UNCOMPRESSED distributions for xy-xx-combined 2m1.0991666s
18:16:31.003923 [wof-dist-build] STATUS register function to compress /usr/local/data/dist/xy-xx-combined-latest.db
18:16:31.004342 [wof-dist-build] STATUS time to wait to start compressing /usr/local/data/dist/xy-xx-combined-latest.db 6.9µs
18:17:06.383629 [wof-dist-build] STATUS All done compressing /usr/local/data/dist/xy-xx-combined-latest.db (throttle)
18:17:06.383684 [wof-dist-build] STATUS time to compress /usr/local/data/dist/xy-xx-combined-latest.db 35.4138754s
18:17:06.383702 [wof-dist-build] STATUS All done compressing /usr/local/data/dist/xy-xx-combined-latest.db
18:17:06.384283 [wof-dist-build] STATUS remove uncompressed file /usr/local/data/dist/xy-xx-combined-latest.db
18:17:06.450661 [wof-dist-build] STATUS time to remove uncompressed files for xy-xx-combined 66.9087ms
18:17:06.450719 [wof-dist-build] STATUS time to build COMPRESSED distributions for xy-xx-combined 2m36.5980054s
18:17:06.451379 [wof-dist-build] STATUS time to build distributions for 2 repos 2m36.5989252s
18:17:06.451503 [wof-dist-build] STATUS ITEMS map[xy-xx-combined:[xy-xx-combined-latest.db]]
18:17:06.451952 [wof-dist-build] STATUS Wrote inventory /usr/local/data/dist/xy-xx-combined-inventory.json
total 53832
drwxr-xr-x    1 root     root          4096 Oct 28 18:17 .
drwxr-xr-x    1 root     root          4096 Aug 10 22:00 ..
-rw-r--r--    1 root     root           586 Oct 28 18:17 xy-xx-combined-inventory.json
-rw-r--r--    1 root     root      55110928 Oct 28 18:17 xy-xx-combined-latest.db.bz2
```

### Multiple repos, wildcard and combined

```
$> docker run whosonfirst-data-distributions /usr/local/bin/wof-build-distributions -n -C -N y-combined -R -P whosonfirst-data-admin-y
/usr/local/bin/wof-list-repos -org whosonfirst-data -prefix whosonfirst-data-admin-y
building distributions for whosonfirst-data-admin-ye whosonfirst-data-admin-yt
--
/usr/local/bin/wof-dist-build -verbose -timings -custom-repo -workdir /usr/local/data/dist -github-organization whosonfirst-data -combined -combined-name y-combined whosonfirst-data-admin-ye whosonfirst-data-admin-yt
18:21:32.414101 [wof-dist-build] STATUS time to clone y-combined 28.7625782s

18:21:32.415307 [wof-dist-build] STATUS local_checkouts are [/usr/local/data/dist/whosonfirst-data-admin-ye /usr/local/data/dist/whosonfirst-data-admin-yt]
18:21:32.434747 [wof-dist-build] STATUS commit hashes are map[whosonfirst-data-admin-ye:4d8015e0916f5f6b818783ebabcb337d972391a6 whosonfirst-data-admin-yt:439ccee82ba7e5a29468c6ba9d8affeb917ef890] ([/usr/local/data/dist/whosonfirst-data-admin-ye /usr/local/data/dist/whosonfirst-data-admin-yt])
18:22:23.887864 [wof-dist-build] STATUS Built  without any reported errors
18:22:23.888272 [wof-dist-build] STATUS local sqlite is /usr/local/data/dist/y-combined-latest.db
18:22:27.807667 [wof-dist-build] STATUS time to build UNCOMPRESSED distributions for y-combined 1m24.2241014s
18:22:27.818706 [wof-dist-build] STATUS register function to compress /usr/local/data/dist/y-combined-latest.db
18:22:27.818787 [wof-dist-build] STATUS time to wait to start compressing /usr/local/data/dist/y-combined-latest.db 6.8µs
18:22:52.452031 [wof-dist-build] STATUS All done compressing /usr/local/data/dist/y-combined-latest.db (throttle)
18:22:52.452790 [wof-dist-build] STATUS time to compress /usr/local/data/dist/y-combined-latest.db 24.6677242s
18:22:52.454240 [wof-dist-build] STATUS All done compressing /usr/local/data/dist/y-combined-latest.db
18:22:52.454434 [wof-dist-build] STATUS remove uncompressed file /usr/local/data/dist/y-combined-latest.db
18:22:52.503676 [wof-dist-build] STATUS time to remove uncompressed files for y-combined 49.2496ms
18:22:52.503939 [wof-dist-build] STATUS time to build COMPRESSED distributions for y-combined 1m48.954401s
18:22:52.504485 [wof-dist-build] STATUS time to build distributions for 2 repos 1m48.9591434s
18:22:52.504527 [wof-dist-build] STATUS ITEMS map[y-combined:[y-combined-latest.db]]
18:22:52.505125 [wof-dist-build] STATUS Wrote inventory /usr/local/data/dist/y-combined-inventory.json
total 30896
drwxr-xr-x    1 root     root          4096 Oct 28 18:22 .
drwxr-xr-x    1 root     root          4096 Aug 10 22:00 ..
-rw-r--r--    1 root     root           578 Oct 28 18:22 y-combined-inventory.json
-rw-r--r--    1 root     root      31622053 Oct 28 18:22 y-combined-latest.db.bz2
```

### Multiple repos, wildcard and combined with a time (repo updated since) filter

```
$> docker run whosonfirst-data-distributions /usr/local/bin/wof-build-distributions -n -C -N foo -R -P whosonfirst-data-postalcode -S P14D
/usr/local/bin/wof-list-repos -org whosonfirst-data -prefix whosonfirst-data-postalcode -updated-since P14D
Nothing to build a distribution from.
```

## AWS

### Roles

You will need to make sure you have a role with the following (default) AWS policies:

* `AmazonECSTaskExecutionRolePolicy`

In addition you will need the following custom policies:

In addition you will need the following custom policies:

Something that allows you to read/write to S3, for example:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::dist.whosonfirst.org"
            ]
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:DeleteObject",
                "s3:GetObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::dist.whosonfirst.org/*"
            ]
        }
    ]
}
```

### Security groups

Create a new `whosonfirst-data-distributions` security group and disallow _all_ inbound ports. Do we really need all inbound ports? No, so this should be locked down.

## Lambda

### webhookd-lambda-task

#### Environment variables

| Key | Value |
| --- | --- |
| WEBHOOKD_MODE | `lambda` |
| WEBHOOKD_COMMAND | `/usr/local/bin/wof-build-distributions -n %s` |
| WEBHOOKD_ECS_CLUSTER | `whosonfirst` |
| WEBHOOKD_ECS_CONTAINER | `whosonfirst-data-distributions` |
| WEBHOOKD_ECS_DSN | `credentials=iam: region={AWS_REGION}` |
| WEBHOOKD_ECS_SECURITY_GROUP | `{EC2_SECURITY_GROUP}` |
| WEBHOOKD_ECS_SUBNET | `{AWS_SUBNET1},{AWS_SUBNET2}...` |
| WEBHOOKD_ECS_TASK | `whosonfirst-data-distributions:{N}` |

_Important: See the way I am passing the `-n` (or "dryrun") flag above? That's because I am still testing things..._

## See also

* https://github.com/whosonfirst/go-whosonfirst-github
* https://github.com/whosonfirst/go-whosonfirst-dist
* https://github.com/whosonfirst/go-whosonfirst-dist-publish