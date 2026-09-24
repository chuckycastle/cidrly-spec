# Plan file format

A cidrly plan is a UTF-8 JSON document. The CLI writes it with a `.cidr` or `.json` extension; the
Apple apps register the `com.cidrly.plan` uniform type for the same bytes. Every implementation
must read every version listed here and must write the current version.

## Version 2 (current)

Written by cidrly CLI 0.6.0 and later and by the Apple apps.

```jsonc
{
  "schemaVersion": 2,
  "name": "Campus Network",            // 1..100 characters
  "baseIp": "10.100.0.0",              // dotted IPv4; starting point for plans without assigned blocks
  "growthPercentage": 100,             // integer 0..300; planned = ceil(expected * (1 + growth/100))
  "allocationMode": "vlsm",            // "vlsm" (default) | "flsm"
  "minimumSubnetMask": 24,             // optional; FLSM only
  "subnets": [
    {
      "id": "b0c9…",                   // stable, unique within the plan
      "name": "Engineering",           // 1..100 characters
      "vlanId": 10,                    // 1..4094
      "expectedDevices": 100,          // 1..16777214
      "description": "Building A",     // optional, <= 200 characters
      "networkLocked": false,          // true keeps manualNetworkAddress fixed across recalculation
      "manualNetworkAddress": "10.100.0.0/24", // optional
      "sourceBlockId": "block-1",      // optional; IPAM-lite
      "subnetInfo": {                  // derived; may be absent before calculation
        "expectedDevices": 100,
        "plannedDevices": 200,
        "requiredHosts": 100,
        "subnetSize": 256,
        "cidrPrefix": 24,
        "usableHosts": 254,
        "networkAddress": "10.100.0.0/24"
      }
    }
  ],
  "assignedBlocks": [                  // optional; IPAM-lite
    {
      "id": "block-1",
      "networkAddress": "10.100.0.0/22",
      "cidrPrefix": 22,
      "totalCapacity": 1024,
      "startInt": 174325760,           // unsigned 32-bit
      "endInt": 174326783,
      "label": "Campus core",          // optional
      "assignedAt": "2026-01-01T00:00:00.000Z"
    }
  ],
  "supernet": {                        // derived; written for compatibility, never trusted on read
    "cidrPrefix": 21,
    "totalSize": 2048,
    "usedSize": 1216,
    "utilization": 59.375,
    "rangeEfficiency": 100,
    "networkAddress": "10.100.0.0/21"
  },
  "createdAt": "2026-01-01T00:00:00.000Z",
  "updatedAt": "2026-01-01T00:00:00.000Z"
}
```

### Rules

- **Unknown fields are preserved.** A reader must keep any top-level or subnet-level field it does
  not understand and write it back unchanged. This is how newer clients and older clients share
  files without data loss.
- **Derived fields are recomputed on read.** `subnetInfo`, `supernet`, and `spaceReport` are the
  engine's output. Readers may display them before recalculating but must not use them as input to
  allocation, except that a locked subnet's `subnetInfo.networkAddress` (or
  `manualNetworkAddress`) is the locked address.
- **`spaceReport` is no longer written** by v2 writers. Readers ignore it.
- **`requiredHosts` equals `expectedDevices`** in v2, matching the CLI engine. Older example files
  that stored `plannedDevices + 2` are accepted and recomputed.
- Timestamps are ISO-8601 UTC with millisecond precision.
- The supernet is the smallest CIDR-aligned block that contains every allocated subnet. Its
  `utilization` is `usedSize / totalSize * 100`.

## Version 1

Files without `schemaVersion`. Differences from v2:

- `growthPercentage` may be absent; default 100.
- `supernet.efficiency` may appear instead of `supernet.utilization`; readers migrate it.
- `supernet.rangeEfficiency` may be absent; default 100.
- `networkLocked` may be absent; default false.
- `spaceReport` may be present; readers ignore it.

## Reserved for later versions

`reservations[]`, `history[]`, `tags[]`, `addressFamily`, and `sites[]` are reserved names. A v2
reader that sees them must preserve them.

## Semantics

See `fixtures/engine/*.json` for the executable definition of sizing, allocation, IPAM-lite, and
overlap behavior. Where this document and the fixtures disagree, the fixtures win and this
document has a bug.
