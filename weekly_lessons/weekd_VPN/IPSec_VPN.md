IPSec VPN — Practical Engineer Explanation (Cloud / Enterprise Context)

What is IPSec?

Computer Networking
IPSec (Internet Protocol Security) is a suite of protocols used to:

    authenticate traffic
    encrypt traffic
    securely connect networks over untrusted infrastructure like the Internet

Most commonly used for:

    Site-to-Site VPNs
    Hybrid Cloud connectivity
    Branch office tunnels
    Secure datacenter interconnects
    Cloud ↔ On-Prem connectivity

Example:

GCP ↔ AWS
GCP ↔ Azure
Branch Office ↔ HQ
Corporate Datacenter ↔ Cloud VPC

Why Companies Use IPSec
Main Business Reasons


| Reason                     | Explanation                           |
| -------------------------- | ------------------------------------- |
| Cost Reduction             | Avoid expensive MPLS/private circuits |
| Secure Remote Connectivity | Encrypt traffic over public Internet  |
| Hybrid Cloud               | Connect on-prem to cloud securely     |
| Compliance                 | Meet encryption/security requirements |
| Mergers & Acquisitions     | Quickly connect environments          |
| Disaster Recovery          | Secure backup datacenter replication  |
| Multi-Cloud                | Connect AWS/Azure/GCP together        |



Benefits of IPSec
1. Encryption

Traffic crossing the Internet becomes unreadable to attackers.

Common encryption:

    AES-128
    AES-256

2. Authentication

Both VPN peers verify identity before tunnel creation.

Prevents:

    rogue devices
    spoofed peers

3. Integrity

Ensures packets were not modified in transit.

Uses hashing algorithms like:

    SHA-256
    SHA-384

4. Confidentiality

Sensitive traffic stays protected:

    HR systems
    finance traffic
    internal APIs
    database replication

5. Site Transparency

Applications behave as if remote networks are local.

You will LOVE this moment:

“Wait… my VM in GCP can ping on-prem?”

Yes. Welcome to routed networking.

Relevant RFCs

Here are the important RFCs students should recognize.

  | RFC      | Purpose                              |
| -------- | ------------------------------------ |
| RFC 4301 | IPSec Architecture                   |
| RFC 4302 | Authentication Header (AH)           |
| RFC 4303 | Encapsulating Security Payload (ESP) |
| RFC 7296 | IKEv2                                |
| RFC 2409 | IKEv1                                |
| RFC 3947 | NAT Traversal Negotiation            |
| RFC 3948 | UDP Encapsulation for ESP            |
| RFC 4271 | BGP (commonly used over VPNs)        |



Core IPSec Components

| Component                 | Purpose                           |
| ------------------------- | --------------------------------- |
| IKE                       | Negotiates tunnel parameters      |
| ESP                       | Encrypts payload traffic          |
| AH                        | Authentication only (rare today)  |
| SA (Security Association) | Defines encryption/auth settings  |
| Phase 1                   | Creates secure management channel |
| Phase 2                   | Creates encrypted data tunnel     |



Important Ports & Protocols

This is where people usually break things.

| Protocol | Port           | Purpose                 |
| -------- | -------------- | ----------------------- |
| UDP      | 500            | IKE / ISAKMP            |
| UDP      | 4500           | NAT Traversal (NAT-T)   |
| ESP      | IP Protocol 50 | Encrypted IPSec traffic |
| AH       | IP Protocol 51 | Authentication Header   |



Important Clarification

ESP and AH are:

NOT TCP
NOT UDP

They are IP protocols directly.

Students often do this:

“I opened TCP 50.”

No. 😄

It is:

IP Protocol 50
IPSec Tunnel Phases
Phase 1 — IKE SA Establishment

Goal:

establish secure control channel

This creates trust between VPN peers.

Phase 1 Negotiates

| Parameter      | Example        |
| -------------- | -------------- |
| Encryption     | AES-256        |
| Hashing        | SHA-256        |
| DH Group       | Group 14       |
| Authentication | Pre-Shared Key |
| Lifetime       | 28,800 sec     |



Phase 2 — IPSec SA Establishment

Goal: Establish encrypted data tunnel

Negotiates: Actual encrypted traffic parameters
Phase 2 Negotiates

| Parameter      | Example  |
| -------------- | -------- |
| ESP Encryption | AES-256  |
| Integrity      | SHA-256  |
| PFS            | Enabled  |
| Lifetime       | 3600 sec |



IPSec Handshake (High-Level)

Here’s the simplified flow students can remember.

Step 1 — Peer Discovery

VPN gateways identify each other.

Example:

    GCP VPN Gateway
    Cisco ISR
    Palo Alto
    Fortinet


Step 2 — IKE Phase 1 Begins

Using: UDP 500

Peers negotiate:

    crypto algorithms
    hashing
    DH group
    authentication method


Step 3 — Authentication

Usually:

Pre-Shared Key (PSK)

Peers verify: “Do we both know the same secret?”

If not: Tunnel fails immediately

Step 4 — Secure Management Tunnel Established

IKE SA created.

Now peers can securely negotiate actual data tunnel.

Step 5 — Phase 2 Negotiation

Peers negotiate:

    ESP settings
    encryption
    integrity
    PFS

Step 6 — IPSec Tunnel Established

Encrypted traffic now flows.

Where BGP Fits---> This is the “fun” part tonight 😄

Static Routing VPN

Old style: manually define routes

Painful at scale.

Dynamic Routing VPN (BGP)

Modern cloud VPNs commonly use:
Computer Networking BGP

BGP dynamically exchanges:

prefixes
route changes
failover paths


Why BGP Over VPN?

| Benefit                  | Explanation                  |
| ------------------------ | ---------------------------- |
| Automatic route learning | No static routes everywhere  |
| Failover                 | Dynamic rerouting            |
| Scalability              | Easier multi-site management |
| HA VPN                   | Active/Active tunnels        |
| Multi-cloud              | Better route propagation     |



In GCP Specifically

Google Cloud Cloud VPN often uses:

    Cloud Router
    BGP ASN
    dynamic route advertisement

Typical lab:

    Tunnel A
    Tunnel B
    BGP peers
    ASN exchange
    learned prefixes
    
Pre-Shared Key (PSK)

The PSK is:

a shared secret string
configured identically on both VPN peers

Example:

LizzosSuperSecretVPNKey2026!

If mismatched:--> Phase 1 fails

PSK Best Practices

| Good Practice             | Why                    |
| ------------------------- | ---------------------- |
| Long random strings       | Prevent brute force    |
| Rotate periodically       | Reduce exposure        |
| Avoid dictionary words    | Prevent guessing       |
| Store securely            | Treat like credentials |
| Different keys per tunnel | Limit blast radius     |


Common  Failure Points 😄

| Problem                | Result                     |
| ---------------------- | -------------------------- |
| Wrong PSK              | Phase 1 failure            |
| Wrong IKE version      | Tunnel won’t establish     |
| Mismatched proposals   | Negotiation failure        |
| UDP 500 blocked        | No IKE                     |
| UDP 4500 blocked       | NAT-T failure              |
| MTU issues             | Intermittent traffic       |
| BGP ASN mismatch       | Tunnel up, no routes       |
| Firewall rules missing | Tunnel up, no connectivity |
| Wrong CIDRs            | Black hole routing         |



NAT Traversal (NAT-T)

When VPN peers are behind NAT:

IPSec struggles because ESP is not port-based

Solution: encapsulate ESP inside UDP 4500

This is:

NAT-T

Simple Model

| Concept     | Analogy                                       |
| ----------- | --------------------------------------------- |
| IKE Phase 1 | Two spies agree on secure communication rules |
| Phase 2     | They build armored transport tunnel           |
| ESP         | Encrypted armored truck                       |
| PSK         | Secret password                               |
| BGP         | GPS system telling traffic where to go        |


Mutants often think:

“Tunnel UP = network works.”

Nope.

VPN success has layers:

| Layer       | Status                 |
| ----------- | ---------------------- |
| Phase 1     | Secure control channel |
| Phase 2     | Encrypted tunnel       |
| Routing     | Prefix exchange        |
| Firewall    | Traffic permitted      |
| Application | Actual service works   |


You can have:

Phase 1 UP
Phase 2 UP
BGP UP

…and still have:

zero application connectivity.

That realization is when they begin thinking like real network engineers.
