
Create Docker Image
```
docker build -t eks-deployer -f Dockerfile .
Refresh image on 04/06/2024
```

## CHANGE LOG
- Add `dsbulk` binary
- Use `cqlsh` binary from Datastax
- Update `helm-secrets` plugin url
- Consolidated the installation steps into a single RUN command to reduce layers and improve build efficiency.
- Defined all necessary environment variables in one place.
