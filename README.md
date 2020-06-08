# eks-training
EKS Training Cluster, with CI/CD

Pre-requisite:
  * awscli
  * gnu make

Assume you have configured you AWS default profile or setup your credential with environment variables e.g.,
```bash
$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
$ export AWS_DEFAULT_REGION=us-west-2
```

This script is meant to create ephemeral test cluster. There is no provision to make the cluster upgradable / patchable.