{
  lib,
  addDriverRunpath,
  writeShellScriptBin,
  pkgs,
  vtk-egl-docker,
}:

writeShellScriptBin "repro" ''
  set -e

  GLVND_STORE_PATH="$(readlink -f ${addDriverRunpath.driverLink}/share/glvnd/egl_vendor.d/10_nvidia.json | xargs dirname | xargs dirname)"

  declare -a reproFlags reproFlagsPost
  reproFlags+=("--device=nvidia.com/gpu=all")
  reproFlagsPost+=("vtk-demo-egl")

  case "$1" in
  "fail")
    ;;
  "fix")
    reproFlags+=("-v" "$GLVND_STORE_PATH":"$GLVND_STORE_PATH")
    ;;
  "enter-container")
    reproFlagsPost=("bash")
    ;;
  *)
    echo "Usage: repro (fail|fix|enter-container)" >&2
    exit 1
    ;;
  esac

  mode="$1"
  shift 1

  export PATH="$PATH:${pkgs.podman}/bin"
  podman load < ${vtk-egl-docker}
  podman run --rm -it \
    "''${reproFlags[@]}" \
    localhost/vtk-demo:latest \
    "''${reproFlagsPost[@]}"
''
