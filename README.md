# Etherflow

![Alt text](assets/static/images/screenshot.png?raw=true "Etherflow")

## Background

The origin of the problem is one curiosity: If transaction in blockchain are transparent, it supposed to be easy to track stolen fund, right? Imagine if case of major crypto theft case, the address of the hacker is made public, all cryptoexchange aware and freeze it the momment they receive such fund, then it will be harder for him to move the fund and cash out. We got safer crypto ecosystem and move one step away from its wild-wald west nature.

Aside from the fact that such behavior might not exactly what Satoshi has envision or how many cryptoexchange might not care about that, we try to find hout how to achieve it technically.

Naive approach will be to record the hacker's address. In reality, its very trivial for a hacker to bounce the fund into multiple address, and if we try to track each movement and add new address into the "watch list" then it become larger and larger. Plus, he can just send some fund to major cryptoexchange's hot storage and then all address belong to its user suddenly will be on watch list too. 

Clearly its getting more and more impractical.

Here we try another approach by dump all transaction into a graph db. We scan all block and record each transaction. Each address become a node, and each transaction data become relationship data between the node.

We can tag some know address, whether it's belong to CryptoExchange or a known "bad address". Lastly, if we cutious whether an address in 'contaminated' by bad fund, we can query into the graph db.


This is the example query:
```
    MATCH (n {tag: 'BAD ADDRESS'}),(m {address: '0x-your-target-eth-address'}),
    p = shortestPath((n)-[x:TransferETHTo*..15]-(m)) 
    RETURN p
```

## Etherflow

Etherflow is a proof of concept for said approach. It's a web application made with Elixir, Phoenix, and Neo4J as a database. When it first started, it will start scanning Ethereum block from the beginning and record into Neo4j. When you stop and start it again, it will pick up the last block from db and continue until the last block (which might take around 2 weeks to catch up, optimisation required).

You can experiment with your neo4j browser to have more flexible query and analyse the transaction relationship in detail.

![Alt text](assets/static/images/neo4j.png?raw=true "Etherflow")


The endgoal of Etherflow to provide simple web service API and interface where you can inquiry an ethereum address to get information whether its a clean address or contaminated with bad money.

Currently you can query by calling the API and giving 2 address to see the relationship (if any) such as :

```
http://localhost:4000/api/match?from=0x4f4a9be10cd5d3fb5de48c17be296f895690645b&to=0x32be343b94f860124dc4fee278fdcbd38c102d88

```

You can also use the GUI (see the first image above)



To install in your machine:

  * Ensure you have elixir and erlang installed in your machine
  * Ensure you have neo4j installed somewhere.
  * Clone this repo and change the config to match your neo4j credential. The Ethereum server pointed to Infura. You can change it if you like.
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.



- VirKill -