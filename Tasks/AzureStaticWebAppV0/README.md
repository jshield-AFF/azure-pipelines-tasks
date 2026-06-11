# Azure Static Web App task — overrides and advanced configuration

This task supports two runtime overrides to control which container image is used for the deployment client and how Docker will fetch that image.

## Image override

- AZURE_STATIC_WEB_APPS_CLIENT_IMAGE (environment variable)
  - If set, this environment variable is used as the container image for the deployment client (for example: `myregistry/myimage:tag`).
  - Priority order for image selection:
    1. `AZURE_STATIC_WEB_APPS_CLIENT_IMAGE`
    2. `SWA_DEPLOYMENT_CLIENT` (if already set in the environment)
    3. Default: `mcr.microsoft.com/appsvc/staticappsclient:stable`

## Docker pull policy

- `docker_pull_policy` (task input) / `SWA_DOCKER_PULL` (env var written by the task)
  - Controls docker `--pull` behavior. Allowed values (case-insensitive):
    - `always` → `--pull=always` (default)
    - `missing` → `--pull=missing`
    - `never`  → omit the `--pull` flag
  - The task normalizes and validates the input; invalid values will cause the task to fail early with a descriptive message.

### Examples

- YAML pipeline (set the task input):

```yaml
- task: AzureStaticWebApp@0
  inputs:
    cwd: '$(System.DefaultWorkingDirectory)'
    docker_pull_policy: 'missing'
```

- Or set environment variable for image override:

```bash
export AZURE_STATIC_WEB_APPS_CLIENT_IMAGE="myregistry/myimage:tag"
```

### Testing notes

- Verify `env.list` produced by the task contains `SWA_DEPLOYMENT_CLIENT` and `SWA_DOCKER_PULL` entries.
- Run the task with each `docker_pull_policy` to confirm `launch-docker.sh` invokes Docker with the expected pull behavior.

