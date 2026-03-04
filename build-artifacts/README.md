# Async gRPC franka_panda_client binaries

## Problem
libfranka < 0.18.0 only tolerates ~83us of extra latency in the 1kHz control
callback. Polymetis's synchronous gRPC round-trip takes ~100-300us, causing
`communication_constraints_violation` errors.

## Solution
Modified `franka_panda_client.cpp` to use a double-buffered async gRPC pattern:
- 1kHz callback: lock-free read of latest torques (~1us)
- Background thread: gRPC call runs outside the critical path
- Trade-off: 1 cycle (1ms) of control latency, acceptable for impedance control

## Files modified (in repo)
- `droid/fairo/polymetis/polymetis/src/clients/franka_panda_client/franka_panda_client.cpp`
- `droid/fairo/polymetis/polymetis/include/polymetis/clients/franka_panda_client.hpp`

## Pre-built binaries
- `0.15.0/franka_panda_client` - for fr3-0.15.0 Docker image
- `0.17.0/franka_panda_client` - for fr3-0.17.0 Docker image

These are volume-mounted into containers via docker-compose (see
`.docker/nuc/docker-compose-nuc-0.15.0.yaml` and `docker-compose-nuc-0.17.0.yaml`).

## Rebuilding after source changes
```bash
# Rebuild for a specific version:
./rebuild.sh 0.17.0
./rebuild.sh 0.15.0

# Or rebuild all:
./rebuild.sh 0.15.0 && ./rebuild.sh 0.17.0
```

Requires the corresponding Docker image to be already built.

## Not needed for 0.18.0
libfranka 0.18.0 has enough timing headroom for synchronous gRPC.
The 0.18.0 compose file does not mount a patched binary.
