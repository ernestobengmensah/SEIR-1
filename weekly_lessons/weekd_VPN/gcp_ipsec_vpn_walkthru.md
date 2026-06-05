Real-World IPSec Deployment Process (GCP HA VPN)
Step 0 — Engineers Coordinate FIRST

Before anyone clicks anything:

Teams MUST Agree On

| Item                  | Example                   |
| --------------------- | ------------------------- |
| PSK                   | `VeryStrongKey2026!`      |
| IKE Version           | IKEv2                     |
| ASN Values            | GCP 64514 / On-Prem 65001 |
| BGP Tunnel IPs        | 169.254.x.x               |
| Encryption Algorithms | AES256/SHA256             |
| Number of Tunnels     | Usually 2                 |
| Peer Ownership        | Who builds first          |



CRITICAL TEACHING POINT
If the BGP IPs are not agreed first:

nothing works.

You might think:

“We’ll just figure it out later.”

    No. Only if you are batshit crazy

The tunnel interfaces themselves depend on:

    peer BGP IPs
    ASN configuration
    Cloud Router setup

Recommended Student Workflow
Step 1 — Generate and Share PSK FIRST

You already teach this correctly.

Before anything else:

Team agrees on: Pre-Shared Key

Example:: BBLK7f!92x#CloudVPN2026$

Why First?

Because BOTH sides require:

    identical PSK
    identical IKE parameters

If mismatched: Phase 1 fails instantly


Step 2 — Agree on BGP ASN Values

Example:

| Side    | ASN   |
| ------- | ----- |
| GCP     | 64514 |
| On-Prem | 65001 |


Why Important?

BGP neighbors require:

    local ASN
    peer ASN

Without this: BGP never establishes

Step 3 — Agree on BGP Tunnel IPs

This is the famous: 169.254.x.x

Example:

| Tunnel   | GCP          | Peer         |
| -------- | ------------ | ------------ |
| Tunnel 1 | 169.254.12.1 | 169.254.12.2 |
| Tunnel 2 | 169.254.13.1 | 169.254.13.2 |


CRITICAL ENGINEERING LESSON

These values MUST be coordinated BEFORE deployment.

Because:

    both routers must reference each other
    Cloud Router requires peer IPs
    peer router requires GCP IPs


Step 4 — ONE SIDE Creates VPN Gateway FIRST

This is where reality hits Terraform enthusiasts 😄

Why One Side Must Go First

The first side creates: public VPN gateway IPs

Example:

| Tunnel   | Public IP |
| -------- | --------- |
| Tunnel A | 34.x.x.x  |
| Tunnel B | 35.x.x.x  |


These become: peer IPs---> for the OTHER engineer.

This Creates a Dependency Chain
Engineer A builds:
HA VPN Gateway
Cloud Router
External IPs generated

Then shares:

    Public IP A
    Public IP B

Engineer B THEN Configures

Using:

    GCP peer public IPs
    agreed PSK
    agreed BGP IPs

This Is Why Terraform Gets Awkward

You might assume:

    “Terraform can magically build both sides simultaneously.”

Usually not easily.

Because:

    peer IPs do not exist yet
    resources are interdependent
    BGP peers require known addresses
    VPN gateways require peer definitions

Why TF Pipelines Fail Here

Classic issue:

    GCP Tunnel requires peer public IP
    Peer tunnel requires GCP public IP


Circular dependency.

Real Enterprise Workflow

Usually:

| Team         | Action                |
| ------------ | --------------------- |
| Cloud Team   | Creates gateway first |
| Network Team | Receives public IPs   |
| Network Team | Builds peer           |
| Both Teams   | Validate BGP          |


Recommended Build Order
PHASE 1 — Planning
Agree On:

    PSK
    ASN
    BGP IPs
    Encryption settings

PHASE 2 — GCP Side Builds First
GCP Engineer Creates:
    HA VPN Gateway
    External VPN IPs
    Cloud Router
    Tunnel skeletons

Then shares:---> tunnel public IPs









