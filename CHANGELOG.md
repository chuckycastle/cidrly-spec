# Changelog

All notable changes to the cidrly specification. Fixture changes are described in words here so
that implementers can tell a behavior change from a regeneration.

## [v0.1.0] - 2026-09-24

Initial extraction from cidrly CLI v0.5.1. Behavior differs from that release in the following
ways, all of which are corrections:

- **Gateway** (`engine/gateway.json`, all vendor goldens): the default gateway is the network
  address plus one. v0.5.1 always used `.1` of the enclosing /24, which is wrong for any subnet
  that does not start on a `.0` boundary.
- **Supernet** (`engine/allocation.json`, `engine/containing-block.json`): the supernet is the
  smallest CIDR-aligned block that contains every allocated subnet. v0.5.1 sized it from the sum
  of subnet sizes and anchored it at the base IP, which could exclude subnets.
- **Blocks above 128.0.0.0** (`engine/ipam.json`): block bounds are unsigned. v0.5.1 produced
  negative bounds for 172.16/12 and 192.168/16, so allocations were never attributed to their
  block.
- **/0 masks** (`engine/masks.json`): netmask `0.0.0.0`, wildcard `255.255.255.255`.
- **CSV import** (`format/import-round-trip.json`): the header row is the first non-comment
  line, so cidrly's own CSV export (which starts with `# Plan Metadata`) imports.

Plan file schema version 2 (`schema/plan-v2.schema.json`): adds `schemaVersion`; unknown fields
are preserved; `spaceReport` is no longer written.

Unspecified in this version: `/31` and `/32` host semantics, IPv6, FLSM allocation.
