# Docker TLS Router

Containerized TLS routing.

## Getting Started

### Docker

A pre-built Docker image is available for immediate use. The following
environment variables are required:

 * `BUCKET`, the AWS bucket in which the TLS router configuration is stored.
 * `AWS_ACCESS_KEY_ID`, this key must have access to the S3 bucket in which
   backups will be stored.
 * `AWS_SECRET_ACCESS_KEY`.

The following optional variables are also available:

 * `STORAGE_PREFIX`, an arbitrary prefix from which to retrieve the TLS router
   configuration.
 
An example:
 
```bash
docker run \
  -e BUCKET=my-bucket \
  -e AWS_ACCESS_KEY_ID=myawsaccesskey \
  -e AWS_SECRET_ACCESS_KEY=mysecretaccesskey \
  furiousluke/tlsrouter
```

Specifying secret keys directly on the command line is not generally
recommended. Typically, secrets will make their way into containers as files
located somewhere like `/run/secrets`. These may be specified as follows:

```bash
docker run \
  -e BUCKET=my-bucket \
  -e AWS_ACCESS_KEY_ID_FILE=/run/secrets/aws_access_key_id \
  -e AWS_SECRET_ACCESS_KEY_FILE=/run/secrets/aws_secret_access_key \
  furiousluke/tlsrouter
```

## Acknowledgements

The heavy lifting of performing TLS routing is handled by `tlsrouter`, which
[can be found
here](https://github.com/inetaf/tcpproxy/blob/master/cmd/tlsrouter/README.md).
