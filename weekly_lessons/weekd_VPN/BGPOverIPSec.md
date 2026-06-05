BGP Over IPSec

What is BGP?

Computer Networking
BGP (Border Gateway Protocol) is a dynamic routing protocol used to exchange routing information between networks.

Think of it as:

  “A conversation between routers about reachable networks.”

Routers tell each other:

    what networks they know
    how to reach them
    which paths are preferred

Why Use BGP Over VPN?

Without BGP:

all routes must be manually configured

This becomes awful at scale.

Static Route Example (Pain)

Imagine:

20 branch offices
4 cloud regions
DR site
multiple VPCs

Every new subnet:

manually added everywhere

Now you quickly discover:

“This is suffering.”

BGP Solves This

Routers automatically advertise:

reachable prefixes
changes
failovers

So instead of:

Add route manually everywhere

You get:

Router says:
"I can reach 10.20.0.0/16"


In Cloud VPNs

Cloud providers LOVE BGP.

Examples:

Google Cloud Cloud Router
Amazon Web Services Transit Gateway
Microsoft Virtual WAN

Because:

cloud networks constantly change
HA failover matters
automation matters


The Famous 169.254.X.X Addresses

Ah yes…
the:

“tiny weird invisible network inside the VPN.”

You will see:

169.254.12.1
169.254.12.2

and think:

“What in the name of suffering is this?”

What Is 169.254.0.0/16?

This range is:

169.254.0.0/16

Known as:

Link-Local Addresses
APIPA (Automatic Private IP Addressing)

Normally:

non-routable
local-only

BUT…

Cloud VPNs commonly use tiny portions of this range for:

BGP peer IPs


Why Use 169.254.x.x?

Because the VPN tunnel itself needs:

    point-to-point router IPs

BGP neighbors need IP addresses.

Example Tunnel

Imagine:

| Device           | Tunnel IP    |
| ---------------- | ------------ |
| GCP Cloud Router | 169.254.12.1 |
| Cisco Router     | 169.254.12.2 |


These IPs exist ONLY:

inside the VPN tunnel

Not on LANs.
Not publicly routed.
Just inside the encrypted pipe.


This Is Essentially a Tiny Transit Network

Think of it like:

    Router A <--small transit subnet--> Router B

Except:

the transit cable is encrypted IPSec

Typical Cloud Tunnel Design

    On-Prem Router
        169.254.12.2
             |
         IPSec Tunnel
             |
        169.254.12.1
    GCP Cloud Router


Then BGP runs across this mini-network.


Why /30 Subnets?

Common setup:

169.254.12.0/30

And this gives:

| IP | Usage     |
| -- | --------- |
| .0 | Network   |
| .1 | Router A  |
| .2 | Router B  |
| .3 | Broadcast |

Perfect for:

point-to-point links

Tiny and efficient.

How BGP Actually Works Here

After IPSec comes up:

Step 1 — Tunnel Exists

Encrypted path established.

Step 2 — BGP Neighbors Connect

Example:

| Side  | ASN   | Peer         |
| ----- | ----- | ------------ |
| GCP   | 64512 | 169.254.12.2 |
| Cisco | 65001 | 169.254.12.1 |


Autonomous Systems (ASN)

Every BGP router belongs to an:

Autonomous System

Example:

GCP Cloud Router ASN: 64512
Customer ASN: 65001

BGP Session Establishment

BGP uses:

TCP 179

Inside the encrypted tunnel.

Important:

BGP itself is NOT encrypted
IPSec encrypts it underneath


BGP Neighbor States

Mutants love/hate these.

| State       | Meaning       |
| ----------- | ------------- |
| Idle        | Not started   |
| Connect     | Trying TCP    |
| Active      | Retrying      |
| OpenSent    | Sent BGP OPEN |
| OpenConfirm | Negotiating   |
| Established | SUCCESS       |


“Established” Is the Magic Word

If you see:

BGP State = Established

then:

neighbors are exchanging routes

What Routes Get Shared?

Example:

On-Prem advertises:
10.10.0.0/16
GCP advertises:
172.16.0.0/16

Now:

both sides learn routes dynamically
Why This Is Beautiful

Without BGP:

every route manually configured

With BGP:

automatic propagation
failover
route withdrawal
HA

HA VPN Architecture

Cloud providers often create:

TWO tunnels

Example:

Tunnel 1 → 169.254.12.0/30
Tunnel 2 → 169.254.13.0/30

BGP decides:

best path
failover path

If tunnel 1 dies:

routes withdraw automatically
traffic reroutes

Students’ reaction:

“Wait… it failed over automatically?”

Yes.
That’s why enterprises pay network engineers.


Common Failure Scenarios
Tunnel Up — BGP Down

Usually:

TCP 179 blocked
wrong peer IP
ASN mismatch
BGP Up — No Traffic

Usually:

firewall rules
MTU
asymmetric routing
missing advertised routes
Tunnel Flapping

Usually:

unstable Internet
DPD failures
mismatched timers


Wrong Advertisements

Classic:

0.0.0.0/0

accidentally advertised.

Now all traffic hairpins through VPN.

Everyone screams.

Great Mental Model

| Component         | Analogy                           |
| ----------------- | --------------------------------- |
| IPSec             | Armored tunnel                    |
| 169.254.x.x       | Maintenance hallway inside tunnel |
| BGP               | Routers talking inside hallway    |
| ASN               | Organization identity             |
| Advertised routes | “Roads I know how to reach”       |



Practical Cloud Engineering Insight

Students often assume:

“VPN = connectivity.”

But real connectivity requires:


| Layer        | Requirement        |
| ------------ | ------------------ |
| IPSec        | Tunnel established |
| BGP          | Routes exchanged   |
| Firewall     | Traffic permitted  |
| MTU          | Packets fit        |
| DNS          | Names resolve      |
| Applications | Services listen    |


A VPN tunnel alone is just:

“An encrypted empty pipe.”

BGP is what teaches traffic where to go.









