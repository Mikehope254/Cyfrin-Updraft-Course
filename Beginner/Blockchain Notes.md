# Blockchain Basics 
Learn Solidity Smart Contract Development | Full 2024 Cyfrin Updraft Course
https://www.youtube.com/watch?v=-1GB6m39-rM&t=6635s  (0:00:00 - 2:54:49)

# Terminologies

- Blockchain / Smart Contract Platform: A digital ledger that records transactions across many computers in a secure and decentralized manner. A blockchain maintains data integrity and security by linking each block to the previous one in a tamper-resistant chain.
Bitcoin - 1st cryptocurrency (digital gold) 
Ethereum - used blockchain infrastructure and added Decentralized Agreements (Smart Contract) and other ways to interact with each other without a centralized governing force.

- Smart Contracts: Agreement, contract, or a set of instructions deployed in a decentralized blockchain. It is a self-executing contract with the terms of the agreement directly written into code. They run on blockchains and automatically execute when predetermined conditions are met, without the need for intermediaries. Value of Smart Contract is that they create Trust Minimized Agreements / Unbreakable Promises

- Hybrid smart contracts: They combine on-chain code (running on a blockchain) with off-chain data and computations provided by oracles. This allows the contracts to interact with data and systems outside their native blockchain. (On-Chain decentralized login + Off-Chain decentralized Agreements and computations (Oracle)).

- Oracle: any device or entity that connects a deterministic blockchain with off-chain data or runs external computation. 

- Oracle Problem: The challenge of smart contracts accessing real-world data.

- Chainlink: modular decentralized Oracle network that can both bring external(off-chain) data and external computations to the smart contracts and make sure they are decentralized.

- Layer2 (L2): Layer 2 solutions in web3 are technologies built on top of a blockchain (Layer 1) to improve its scalability and efficiency. These solutions handle transactions off the main chain, reducing congestion and fees, and then settle the final state on the main chain. Example: The Lightning Network for Bitcoin. Types of True Layer 2s: *Optimistic Rollup & *Zero Knowledge Rollups 

- Dapp (Decentralized Application): A Dapp is an application that runs on a decentralized network, typically a blockchain. It is powered by smart contracts and operates without a central authority. Dapps can serve various purposes, from finance to gaming. Example: Uniswap, a decentralized finance application.

- Ethereum/EVM (Ethereum Virtual Machine): Ethereum is a blockchain platform known for its smart contract functionality. The Ethereum Virtual Machine (EVM) is its computation engine that executes smart contracts. Ethereum allows developers to build decentralized applications and is the basis for many web3 projects.

- Blockchain Trilemma: It states that a Blockchain can only have 2 out of the 3 properties.

- Testnet: Blockchain test network

- Testnet Faucet: a place to get free testnet ETH

# The Purpose Of Smart Contracts & Blockchain
- Almost every interaction or transaction in our lives involves some form of agreement or contract.
- Once deployed a smart contract is: 

>>Immutable (Cannot be altered)

>>Automatically executes

>>Everyone sees the terms of agreement.

## Ideal Blockchain Properties (Blockchain Trilemma)

>>Secure 

>>Decentralized 

>>Scalability

## The Problem with Traditional Agreements
- Consumer Trust
- Banking and Trust
- Financial Markets Access

## Benefits of Blockchain and Smart Contracts/ Features of Smart Contracts
1. Security and immutability(unchangeable)
2. Decentralization (Many node operators run Blockchain)
3. Transparency and Flexibility
4. Speed and efficiency 
5. Counterparty Risk Removal (Removes the centralized entities due to immutability)
6. Trust Minimized Agreements/ Unbreakable Promises

## Applications of Smart Contracts
1. Decentralized Finance (DeFi)
2. Decentralized Autonomous Organizations (DAOs)
3. Non-Fungible Tokens (NFTs)

***

# Introduction To Gas

## Terminologies,  Transaction Fee and Gas Price
- Gas Price: the amount it cost to interact with a blockchain / How much it costs to perform executions on-chain. The role of Gas price is to set the cost per unit of gas specified for the transaction.

- Transaction Fee: The amount rewarded to the block producer for processing the transaction. = (Gas Price * Gas Used) = (Block Base fee per Gas + Max Priority fee per Gas) * Gas Used. The more people send transactions at the same time the more expensive your gas costs are.

- Block: A list of transactions mined together.

- Hash: unique fixed length string, meant to identify a piece of data. They are created by putting a piece of data into a hash function.

- Hash Algorithm: a function that computes data into a unique hash. eg Ethereum uses Keccak256 hashing algorithm.

- Block's hash: is used to link the block to the previous one and ensure data integrity.

- Nonce: "Number Used Once" to find the "solution" to the blockchain problem. It's also used to define the transaction number for an account/address.

- Mining: The process of finding the "solution" to the blockchain "problem" e.g in example used the "problem" was to find a hash that starts with 4 zeros. Nodes get paid for mining blocks.

- Private Key: Used to "sign" transactions and its only known to the key holder.

- Public key is derived form your private key. Anyone can see it and use it to verify that a transaction came from you.

- Signing  a transaction: A "One way" process. Someone with a private key signs a transaction by their private key being hashed with their transaction data. Anyone can verify this new transaction hash with your public key.

- Secret Phrase is used to generate wallets, each wallet with their own private key. Access to the secret phrase means access to all generated wallets.

>> Secret Phrase > Private key ||| > Public Key > Address

## The Role of Nodes in Blockchain
- Node: a single instance in a decentralized network

- Blockchains are run by a group of different nodes, sometimes referred to as miners or validators, depending on the network. These miners get incentivized for running the blockchain by earning a fraction of the native blockchain currency for processing transactions. For instance, Ethereum miners get paid in Ether, while those in Polygon get rewarded in MATIC, the native token of Polygon. This remuneration encourages people to continue running these nodes.

- Blockchain nodes keep lists of the transaction that occur hence decentralized database.

## Understanding Gas in Transactions

- In the context of transactions, gas signifies a unit of computational complexity.

- The higher a transaction's complexity, the more gas it requires. For instance, common transactions like sending Ether are less complex and require relatively small amounts of gas. However, more sophisticated transactions like minting an NFT, deploying a smart contract, or depositing funds into a DeFi protocol, demand more gas due to their complexity.

- The total transaction fee can be calculated by multiplying the gas used with the gas price in Ether (not GWei). Therefore, Transaction fee = gasPrice * gasUsed.

- The more people use a chain the more expensive it is to send transactions

- Base Fee (Gwei): The minimum gas price to send your transactions = The minimum fee to be paid by a transaction in order to be included in a transaction.

- Max Fee (Gwei): the Maximum price to send your transactions

# How do blockchains work

## Understanding Hash Functions
- A hash is a unique, fixed-length string that serves to identify any piece of data. When you input any kind of data into a hash function, it produces a hash.

## Understanding Blocks
- A block takes the same data input, but instead of a singular data field, a block is divided into 'block', 'nonce', and 'data.' All three are then run through the hash algorithm, producing the hash for that block. As a result, even a minor change in the data leads to an entirely different hash, hence, invalidating the block.

- In essence, mining involves the computational trial and error process of finding an acceptable value to produce a hash which typically follows a certain pattern, such as starting with four zeros. The value found, which satisfies this criterion, is known as the 'nonce'.

- The problem or criteria a miner has to solve will vary from blockchain to blockchain, but the concept is the same.

***

# Blockchain Overview

## Traditional Networks vs Blockchain

- Traditionally, when you run an application be it a website or something that connects to a server you are interacting with a centralized entity. The server is controlled and run by a single centralized group. Blockchains run on a network of independent nodes. The term node typically refers to a single instance of a decentralized system, Peer, A would be a node. This network, this combination of these nodes interacting with each other is what creates a blockchain. What makes these networks so potent, is that anybody can join. All anyone needs is a little bit a hardware and you can participate in securing a blockchain network. You could go to GitHub and start operating a node in a few seconds!

- In the traditional world applications are run by centralized entities and if that entity goes down or is malicious or decides that they want to shut off - they just can. They're the ones that control everything.

- Blockchains, by contrast, don't have this problem. If one node or one entity that runs several nodes goes down, since there are so many other independent nodes running, it doesn't matter, the blockchain and the system will persist so long as there is at least one node always running. Luckily for us, the most popular chains like Bitcoin and Ethereum have thousands and thousands of nodes. Malicious nodes are kicked from the network, or even punished in some cases. Majority rules when it comes to the blockchain. This gives blockchains this incredibly potent immutability trait where nothing can be changed or corrupted so in essence we can think of a blockchain as a decentralized database. In the case of Ethereum it has an extra additional feature where it also can do computation in a decentralized manner now.

***

## Consensus
- It is mechanism used to agree on the state or value of a blockchain. This includes Proof of Work and Proof of Stake

- Consensus protocol in a blockchain or decentralized system can be broken down into two pieces
	1.Chain selection algorithm
	2.Sybil Resistance Mechanism

- Sybil resistance is a blockchain's ability to defend against users creating a large number of pseudo-anonymous identities to gain a disproportionately advantageous influence over said system. As mentioned, there are two primary types of sybil resistance:

>>Proof of Work

>>Proof of Stake


# Proof of Work 
- it allows us to easily protect against Sybil attacks and keep blockchains decentralized and secure. A miner needs to go through a very computationally heavy process (mining) to find the block's answer. As a result, it doesn't matter how many additional nodes you're running, each node is obligated to do this work in order to receive a reward. The playing field is kept fair.

- Proof of Work needs to be combined with a chain selection rule to create consensus.
- A chain selection rule is implemented as a means to determine which blockchain is the real blockchain. Bitcoin (and prior to the merge, Ethereum), both use something called Nakomoto Consensus. This is a combination of Proof of Work (Etherum has since switched to Proof of Stake) and the longest chain rule.

- In the longest chain rule, the decentralized network decides that whichever chain has the most number of blocks will be the valid, or real blockchain. When we saw block confirmations in Etherscan earlier, this was representing the number of blocks ahead of our transaction in the longest chain.

- Proof of Work also serves as a means to determine who receives transaction fees as we discussed earlier. These transaction fees are paid by whomever initiates the transaction. In a Proof of Work system, every node is competing against each other to solve the block problem first. The first node to solve the problem gets paid the transaction fees accumulated in the block they mine. In addition to this, miners are also paid a block reward, the block reward is given by the blockchain itself.

- Drawbacks of Proof of Work: Environmental Impact because It uses a lot of electricity / energy because every single node is working hard to get the rewards.
- With the above in mind, many protocols are choosing the shift to a different consensus mechanism that is more environmentally friendly. The most popular of which is...

# Proof of Stake
- Nodes put up collateral(stake) as a sybil resistance mechanism that they are going to behave honestly.  If a node is found to be misbehaving, it's stake is slashed. This serves as a very effective sybil resistance mechanism because for each account, the validator needs to put up more stake and misbehaving risks losing all that collateral.

- In this system the miners are referred to as validators because they are validating other nodes rather than mining.

## Pros of Proof of Stake

- Great Sybil resistance mechanism
- Uses much less energy because instead of all the nodes racing  to decide the next block ,one id randomly chosen

## Cons of Proof of Stake
- It is considered a slightly less decentralized network due to the upfront staking cost to participate 

## Blockchain Attacks

- There are two major types of attacks that exist in the blockchain space. 

1. Sybil Attack - When a user creates a number of pseudo-anonymous accounts to try to influence a network.

2. 51% attack - It is when a group of nodes have enough nodes or enough power to essentially be 51% of the network and influence the network in whichever direction that they want. This would allow the entity to fork the chain and bring the network onto the entities record of events, effectively allowing them to validate anything.
Hence the bigger the blockchain the more decentralized and the more secure it becomes. the bigger the blockchain, the more secure 	
	
- Longest Chain Rule: Whichever blockchain has the most buy-in and is the longest is the blockchain that the whole system is going to corroborate 

***

# Layer 1 and Layer 2
## Layer 1(L1)
- Any Base layer Blockchain Implementation in which transactions are executed and confirmed.

- Sharding and Rollups are solutions to scalability issues. The scalability issue is that there is not enough block space for the amount of transactions that want to get in. (Only so many transactions can fit into a block). This leads to high gas prices
	
## Layer 2(L2) 
- Any application/network built on top of a layer 1 

# Blockchain Rollup 
- It is an L2 Scaling solution that increases the number of transactions on the L1 chain without increasing the gas price.

- Rollups help scale Ethereum by processing transactions off-chain, bundling them together and submitting them back to Ethereum with some proof.

- The primary benefit of rollup solutions is that they reduce transaction fees and congestion by processing the transactions off the main chain. It aims to solve the trilemma problem by processing the transactions off of the L1 Blockchain.

## Types of Rollups (Based on how they check the validity of the transactions whether legitimate or fraudulent)

### Optimistic Rollups 
- They assume that the off-chain transactions are valid/legitimate by default. If the transactions are not challenged during the challenge period they are assumed to be valid.
### Zero Knowledge Rollups (ZK Rollups) 
- They use validity or ZK proof to verify transaction correctness.

>> zero-knowledge proof (ZK Proof)- A method for proving knowledge of something without revealing the thing itself

## Sequencers 
- The operator ordering transactions and sometimes bundling them together. It orders and bundles transactions before they are submitted to the main blockchain.

# Rollup Stages
- A categorization system used to describe the decentralization and maturity of a rollup.

## Stage 0 
    -Full Training wheels
	-Centralized Management
	-Security Council make decisions
	-Open source software for data availability for transparency and verifiability

## Stage 1 
    -Enhanced Rollup Governance
	-Governed by smart contracts
	-Security Council bug resolution
	-Decentralized fraud/validity proof system

## Stage 2 
    -No training Wheels
	-Completely decentralized
	-Smart contracts manage the rollup
	-Full decentralized and permissionless fraud/ validity proof system
	=Security council address errors adjudicated on-chain
	-User protection against governance attacks
	
### Finality 
- The time taken from sending a transaction to when the transaction can be considered settles: and therefore cant be altered, reversed or cancelled

***
