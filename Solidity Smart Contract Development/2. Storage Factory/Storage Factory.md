# Storage Factory

## Introduction
You can find the code for this section in the [Remix Storage Factory Github repository](https://github.com/cyfrin/remix-storage-factory-f23). In these nine lessons, we'll work with three new contracts:

1. `SimpleStorage.sol` - the contract we build in the previous section (simpleStorage), with some modifications
2. `AddFiveStorage.sol` - a child contract of `SimpleStorage` that leverages _inheritance_
3. `StorageFactory.sol` - a contract that will _deploy_ a `SimpleStorage` contract and _interact_ with it


## Section Overview
```
contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {};
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {};
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {}
}
```

- After deploying `StorageFactory` and executing its function `createSimpleStorageContract`, we can observe a new transaction appear in the Remix terminal. It's a **deployment transaction** of the `SimpleStorage` contract, executed by the `StorageFactory` contract.

- It's possible to interact with this newly deployed `SimpleStorage` via the `store` function. We'll do this by using the **`sfStore`** function from the `StorageFactory` contract. This function accepts two parameters: the index of a deployed `SimpleStorage` contract, which will be '0' since we just deployed one contract, and the value of a `favoriteNumber`.

- The **`sfGet`** function, when given the input '0', will indeed return the number provided by the previous function. The **address** of the `SimpleStorage` contract can then be retrieved by clicking on the get function `listOfSimpleStorageContracts`.

## Conclusion
- The `StorageFactory` contract manages numerous instances of an external contract `SimpleStorage`. It provides functionality to deploy new contract instances dynamically and allows for the storage and retrieval of values from each instance. These instances are maintained and organized within an array, enabling efficient tracking and interaction.

***

# Setting the Project
- In this `StorageFactory` setup, we'll explore what _composability_ means, showing its ability to deploy and interact with external `SimpleStorage` contracts.

- Compossability: The ability for contracts to interact with each other seamlessly

> 👀❗**IMPORTANT**\
> One of the fundamental aspects of blockchain development is the seamless and permissionless interaction between contracts, known as **composability**. This is particularly crucial in decentralized finance (DeFi), where complex financial products interact effortlessly through common smart contract interfaces.

Let's set up the backbone of the code, that contains the function `createSimplestorageContract`. This function will deploy a `SimpleStorage` contract and save the result into a _storage variable_:

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract StorageFactory {

    function createSimplestorageContract() public {
        // How does StorageFactory know what SimpleStorage looks like?
    }
}
```

We need to establish a connection between the two contracts, since `StorageFactory` needs to have a complete knowledge of `SimpleStorage`. One first approach could be copying the `SimpleStorage` contract above `StorageFactory`.

> 🗒️ **NOTE**\
> It's allowed to have multiple contracts in the same file. As best practice, however, it's recommended to use only one file for each contract
