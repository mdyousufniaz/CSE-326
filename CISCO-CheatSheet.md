**PING:**

Ping <ip\_address>



**Setting Up IP Address with every interface the Router is connected with:**

en->conf t -> int fa0/0 -> ip address 192.168.0.101 255.255.255.0-> no shutdown



**Show Routing Table( which ever ip routes are directly connected with the router)**

en->show ip route

(P.S: If network not routed the packet will not be passed along)

administrative distance(less) -> Trustworthy (More)

d

**Set up ip route:**

(Static)en -> conf t -> ip route 192.168.3.0(network only) 255.255.255.0 ?(various options:either exit interface or next hop ip address)



(Dynamic\_rip\_protocol)en->conf t->router rip->version 2->(now add all the networks that are connected with the router)network 192.168.0.0->network 192.168.1.0->....->no auto-summary





**Virtual Networking(VLAN) by configuring Switch**





**Switch:**

**Show which VLANs are connected:**

en->show vlan



vlan 1 is default



**Create VLAN in Switch:**

en->conf t->vlan 10->faculty(name of VLAN)



**Configure through which interface which vlan is allowed to pass:**

1(Access Mode-single).en->conf t->int fa1/1->switchport mode access(for only 1 VLAN passing)0->switchport access vlan 10



2(Trunc mode-mult. vlan).en->conf t->int fa0/1->switchport mode trunk->switchport trunk native vlan 1(for no tagging untagging)

3(Trunc mode-mult. vlan).en->conf t->int fa0/1->switchport mode trunk->switchport trunk allowed vlan 1,10,30



**Inter VLAN Comm:**

(for inter vlan communication we will need a router with a switch for packet switching)

**1)In router:**

en->conf t->int fa0/0.10->encapsulation dotiq 10(does tagging untagging in router)->ip address 192.168.10.1 255.255.255.0(Setting a sub ip address)->exit->int fa0/0->no shutdown



**2)In Switch:**

Create and conf the vlans first

en->conf t->int fa0/1->switchport mode trunk->switchport trunk native vlan 1->switchport trunk allowed vlan 1,10,30





**Password:(for en)**

en->conf t->enable secret (passoword)



**Password:(for user mode)**

en->conf t->line console 0->password (password)->login->exit



**Chnage name:**

en->conf t->Hostname 1



**Virtual Config:**

Router/Switch:

en->conf t->line vty 0 4(total 5 pc can virtually configure)->password (password)->login





**In PC:(from cmd prompt)**

telnet (IP\_Address)





**ACL:(Do this in Router)(Standard\_just src\_ip)**

matches one after another

**Router:**

1)en->conf t->access-list 1(? either standard or extended) deny host 192.168.1.1->*do show access-list*(use ? mark to customize various parts of this command)

(if we dont permit by default rest would be denied)

2)en->conf t->access-list 1 permit host 192.168.1.2->do show access-list

(bind the rules in an interface)

3)en-> conf t->int fa4/0->ip access-group 1 in





4\)**delete ACL**

en->conf t->no access-lists





**(Extended src\_ip,src\_port,dst\_port,dst\_ip,type of protocol,type of packet)**

1)en->conf t->access-list 100 deny icmp 192.168.1.0 0.0.0.255 host 192.168.3.1 echo (use ? mark to customize various parts of this command)

2)en->conf t->access-list 100 permit icmp 192.168.1.0 0.0.0.255 host 192.168.3.2 echo(same as before)

3)en-> conf t->int fa4/0->ip access-group 100 in





**NAT:**



**Private IP:**

Class A: 10.0.0.0 - 10.255.255.255

Class B:172.16.0.0 - 172.31.255.255

Class C:192.168.0.0 - 192.168.255.255



**Public IP:**

203.165.200.1



**NAT happens on an ACL:**

**1.Using interface:\*\*\***

en->conf t->access-list 1 permit 192.168.1.0 0.0.0.255->ip nat inside source list 1 int fa4/0 overload->

int fa0/0->ip nat inside->exit->

int fa4/0->ip nat outside->exit



**2.Show nat translations**

en->conf t->do show ip nat translations



**3.Creating Pool:\*\***

en->conft->ip nat pool pool\_1 209.165.200.1 209.165.200.4 netmask 255.255.255.0



**4.Using pool:(Access list first)\*\*\***

en->conf t->access-list 1 permit 192.168.1.0 0.0.0.255->ip nat inside source list 1 pool pool\_1 overload->

int fa0/0->ip nat inside->exit->(translate the addresses coming from here)

int fa4/0->ip nat outside->exit

P.S:The other router doesn't know the pooled ip so we have to make the routers know them

**So,in other router:**

en->conf t->ip route 209.165.200.0 255.255.255.0 fa4/0\*\*\*\*\*\*\*\*\*\*\*





**DHCP:**

**1)Server is very easy.follow the gui**

**2)Router:**

After configuration->

1)en->conf t->ip dhcp excluded-address 192.168.2.101(Exclude the ip address for router ip)

2)en->conf t->ip dhcp pool pool1\_192.168.2.0->network 192.168.2.0 255.255.255.0->default-router 192.168.2.101



**3)Router to router when another router acts as a relay**



**Relay Router:**

en->conf t->int fa0/0->ip helper-address 192.168.3.101(Address of the server we acting as relay for)



**Main Router:(Same as before)**

en->conf t->ip dhcp excluded-address 192.168.4.101(helper's interface from which dhcp requests will come)

->ip dhcp pool pool2\_192.168.4.0->network 192.168.4.0 255.255.255.0->default-router 192.168.4.101->exit

->ip route 192.168.4.0 255.255.255.0 se2/0





**Using RIP to advertise NAT Public IP Pool:**

**\*\*\*RIP only advertises the ip pools that are present in an active interface of a router\*\*\***

For this reason just NAT pool banai RIP korle onno router e oigula jabe na

**Soln:Loopback-**Creates virtual interfaces



1)Create RIP protocol for each router.

2)The router which is connecting the priv and pub network:

&nbsp;	**Create access-list:**en->conf t->access-list 1 permit 192.168.1.0 0.0.0.25

&nbsp;	**Create Pool:**en->conf t->ip nat pool pool\_1 209.165.200.126 209.165.200.140 netmask 255.255.255.0

&nbsp;	**Create the NAT:**en->conf t->ip nat inside source list 1 pool pool\_1 overload

\*But due to problem stated before the nat wont be advertised

&nbsp;	**Create a virtual int:**en->conf t->int loopback ?(any valid num)

&nbsp;	**Configure ip address of int:**ip address 209.165.200.126 255.255.255.0

&nbsp;	**Configure the pool ip in the rip protocol:**en->conf t->router rip->version 2->network (pool\_network)



















 

