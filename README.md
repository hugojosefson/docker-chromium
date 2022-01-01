# Docker image hugojosefson/chromium

Runs the Chromium browser, inside Docker.

## Usage

This docker image must be started as `root`, so don't use `docker
run --user=...`. Instead, pass environment variables `USER_NAME`,
`USER_ID`, `GROUP_NAME`, `GROUP_ID` (and optionally `HOME`) for the
user you want to become.

Example which gives Chromium access to the current directory, but
not your actual `HOME` on your host.

```bash
# Create a new temp directory to hold the user HOME inside the container
CHROMIUM_HOME=$(mktemp -d) # (or use another specific directory)

# Run Chromium using in the current directory, as yourself, with config
# saved in the new HOME

docker run --rm -it \
  --env USER_ID="$(id -u)" \
  --env USER_NAME="$(id -un)" \
  --env GROUP_ID="$(id -g)" \
  --env GROUP_NAME="$(id -gn)" \
  --env HOME="${HOME}" \
  --volume "${CHROMIUM_HOME}":"${HOME}" \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --env DISPLAY="unix${DISPLAY}" \
  --volume "$(pwd)":"$(pwd)" \
  --workdir "$(pwd)" \
  hugojosefson/chromium
```

## License

MIT
