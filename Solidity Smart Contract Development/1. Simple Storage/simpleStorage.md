# Solidity Smart Contract Development

- Solidity is the programming language primarily used for EVM-based smart contract development

## Setting up your first contract

- The basics of Remix and how to create and compile your first contract.

## Remix IDE

- Remix IDE is used to build and develop smart contracts in solidity. It helps to easily visualize and interact with our smart contracts. It contains a file explorer that hosts all the files, a solidity compiler and a tab where you can deploy your contracts.

## Compiler Directive
- Compiling a contract means to convert the Solidity code into bytecode and ABI that can be understood and executed by the Ethereum Virtual Machine (EVM).
- The pragma directive specifies the version of the solidity compiler that you want to use to build your source file. When the compiler encounters this line, it will check its version against the one you specified here. If the compiler version is different, Remix will automatically adjust accordingly to your specifications.
- You can specify the compiler version(s) in the following ways:

1. Use exactly one version

>> pragma solidity 0.8.19; // use only version 0.8.19

2. Use versions that fall within a lower and upper range

>> pragma solidity >=0.8.19 < 0.9.0; // use versions between 0.8.19 and 0.9.0 (excluded) 

3. Use versions that are above a certain version

>> pragma solidity ^0.8.19

## SPDX License Identifier

- It's good practice to start your smart contract with an SPDX License Identifier. It helps in making licensing and sharing code easier from a legal perspective.

>>//SPDX-License-Identifier: MIT

>>pragma solidity ^0.8.19;

- MIT is known as one of the most permissive licenses which means anybody can use this code and pretty much do whatever they want with it.

# Writing the Smart Contract

- Start by writing your contract using the keyword contract. Give it a name, e.g., SimpleStorage. All the code inside the curly brackets will be considered part of this contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    //here we'll place the content of the contract
}
```

***

# Quiz: Simple Storage Intro
**1. What programming language is primarily used for EVM-based smart contract development?**
* *a) Solidity*
* *b) Remix*
* *c) JavaScript*
* *d) TypeScript*

<details>
  <summary>Click to reveal answer</summary>
  <p>Solidity</p>
</details>

**2. What's the keyword pragma used for?**
* *a) It defines custom data types in Solidity.*
* *b) It is used to create external libraries for Solidity functions.*
* *c) It specifies the version of the Solidity compiler that should be used.*
* *d) It is used to handle low-level assembly code in Solidity.*

<details>
  <summary>Click to reveal answer</summary>
  <p>It specifies the version of the Solidity compiler that should be used.</p>
</details>

**3. What does compiling a contract mean?**
* *a) It optimizes the Solidity code to minimize gas usage and directly generates a deployable smart contract without bytecode.*
* *b)It creates a stateful binary representation of the contract that includes gas pricing predictions and ensures compatibility with all Ethereum forks.*
* *c) It converts the Solidity code into bytecode and ABI that can be understood and executed by the Ethereum Virtual Machine (EVM).*
* *d) It converts high-level Solidity functions into machine code that runs natively on any blockchain, eliminating the need for the EVM.*

<details>
  <summary>Click to reveal answer</summary>
  <p>It converts the Solidity code into bytecode and ABI that can be understood and executed by the Ethereum Virtual Machine (EVM).</p>
</details>

# Basic Data Types

- boolean, uint, int, address, bytes 

```solidity
bool hasFavoriteNumber = true; 
uint256 favoriteNumber = 88; 
int256 favoriteNumber = -88; 
string favoriteNumber = "eighty-eight" 
address myAddress = 0x6F60af1cd77433f84DFbFD1C0017A66A24f17e10 
bytes32 favBytes32 = "cat"

uint256 favNumber; //not initializing is equal to initializing to zero
```

- uint: unsigned integer i.e positive whole number, no decimals or fractions. 

```solidity
uint64 favNum = 88 
```

- 64 value represents the bits, the largest assigned bit number is 256. **uint** or **uint256** are the same, so without assigning bits to uint the default is 256.

# Function Visibility Specifiers 

## public 
- Accessible from both inside the contract and from external contracts (Creates a getter function for storage/state variables) 
## private 
- Accessible only within the current contract. It does not hide a value but only restricts its access. 
## external 
- Used only for functions. Visible only from outside the contract. 
## internal 
- Accessible by the current contract and any contracts derived from it.

>> If a visibility specifier is not given, it defaults to internal.

# Pure and View keywords 

```solidity
function retrieve() public view returns(uint256) {
    return favoriteNumber;
}

function retrieve() public pure returns(uint256) {
    return 7;
}
```

- The terms view and pure are used when a function reads values from the blockchain without altering its state. Such functions will not initiate transactions but rather make calls, represented as blue buttons in the Remix interface. A pure function will prohibit any reading from the state or storage.

- Calling a pure or view function does cost gas only when a gas cost transaction or function is calling it

# Array of struct

- This combines two concepts: arrays and structs

```solidity
Person[] public list_of_people; // this is a dynamic array. We can add as many Person objects as we like, as the size of the array is not static but can grow and shrink. We can access each Person object in our array by its index. 

Person[3] public list_of_three_people; // this is a static array. This can only have a maximum of 3
```

# Data Locations 

- Solidity can store data in **six** different locations.
1. Calldata    
2. Memory
3. Storage
4. Stack
5. Code
6. Logs

# Calldata and Memory Variables 

- In Solidity, `calldata` and `memory` are temporary storage locations for variables during function execution. `calldata` is temporary read-only, used for function inputs that can't be modified. `memory` allows for read-write access, letting variables be changed within the function. To modify `calldata` variables, they must first be loaded into `memory`.

- Calldata and Memory both mean temporary variables. Memory data can be changed while Calldata cannot.

> Warning... Most Variable types default to memory automatically. However, for strings , you must specify either 'memory' or 'calldata'

## Storage variables
- These are Permanent variables that can be modified.
***If you create a variable outside a function inside of a contract it automatically becomes a storage variable***

***

# Deploying your first Smart Contract

## Deploying on a testnet

 Go into the deployment tab and switch from the local virtual environment (Remix VM) to the Injected Provider - MetaMask. This action will allow Remix to send requests and interact with your MetaMask account.

![deploymentImage1](../Images/deploying1.png)

You will be then prompted to select an account from your MetaMask wallet. Once you've connected that account to Remix, you should see a confirmation that the account is properly linked and that you are using the Sepolia testnet.

![deploymentImage2](../Images/deploying2.png)

Ensure you have enough Sepolia ETH in your account, which you can obtain from a [faucet](https://www.alchemy.com/faucets/ethereum-sepolia). Once your balance is sufficient, you can proceed by clicking the "Deploy" button.

After that, MetaMask will ask to sign and send the transaction on the testnet.

![deploymentImage3](../Images/deploying3.png)

Once the transaction is executed, the contract address will be listed under deployed contracts, along with the transaction details. This is how the deployment transaction is displayed on Etherscan.

![deploymentImage4](../Images/deploying4.png)

## Contract interaction

Since the contract has been deployed, we can now interact with it and **update the blockchain**. For example, if you want to store a number, you can do so by clicking the button 'store': MetaMask will ask for another transaction confirmation, that will update the favorite number. We can check the details on etherscan at the deployed address:

![deploymentImage5](../Images/deploying5.png)

> 👀❗**IMPORTANT** 
> View and pure functions will not send transactions

- It's possible to deploy a contract to different testnets or a real mainnet, just by switching the MetaMask network. Be sure to have enough net-compatible ETHs to deploy your contract.

## Conclusion

Deploying a Solidity contract to a testnet is a crucial step in the development process, allowing you to test its functionality in a live blockchain environment without the risk of using real Ether. Always remember to perform necessary audits and tests to confirm the contract's safety and correctness before deployment.

***

# Quiz: Simple Storage Mid Section Recap

**1. Which of these is NOT a valid Solidity type?**
* *a) float*
* *b) uint256*
* *c) bytes32*
* *d) bool*

<details>
  <summary>Click to reveal answer</summary>
  <p>float</p>
</details>

**2. What is the struct keyword used for?**
To declare a variable to be in storage.
To define an array.
To establish a new data type that groups multiple variables.
To create code that runs before or after a function.

<details>
  <summary>Click to reveal answer</summary>
  <p>To establish a new data type that groups multiple variables.</p>
</details>

**3. Which of the following is a location for storage that is NOT temporary?**
* *a) Storage*
* *b) Memory*
* *c) Calldata*
* *d) Public*

<details>
  <summary>Click to reveal answer</summary>
  <p>Storage</p>
</details>

**4. In Solidity, which of the following function visibility specifiers allows a function to be called internally within the contract and externally by users or other contracts?**
* *a)external*
* *b)private*
* *c)internal*
* *d)public*

<details>
  <summary>Click to reveal answer</summary>
  <p>Public</p>
</details>

**5. Why can't the storage location be used for new variables inside a function in Solidity?**
* *a) Because storage variables are meant to persist between function calls and are only declared at the contract level.*
* *b) Because storage variables can only be used for external function parameters.*
* *c) Because storage variables are reserved for constants only.*
* *d) Because storage variables are automatically initialized to zero.*

<details>
  <summary>Click to reveal answer</summary>
  <p>Public</p>
</details>

**6. Given the following mapping mapping(address->uint256), what is the default value returned when accessing a key that does not exist?**
* *a) Null*
* *b) Zero*
* *c) Empty string*
* *d) Error*
<details>
  <summary>Click to reveal answer</summary>
  <p>Zero</p>
</details>

**7. What is the purpose of the 'view' keyword when declaring a function in Solidity?**
* *a)To restrict function access to the current contract only.*
* *b)To declare a function that can be accessed from both inside and outside the contract.*
* *c)To enable the function to receive Ether along with a call.*
* *d)To indicate that the function only reads state data and does not modify it.*
<details>
  <summary>Click to reveal answer</summary>
  <p>To indicate that the function only reads state data and does not modify it.</p>
</details>

**8. Which of the following code snippets is a valid way to declare a public function that accepts a uint256 parameter and sets a state variable to its value?**
* *a)function store public(uint256 _favoriteNumber) { favoriteNumber = _favoriteNumber; }*
* *b)function store(uint256 _favoriteNumber) public { favoriteNumber = _favoriteNumber; }*
* *c)function store(uint256 _favoriteNumber) { favoriteNumber = _favoriteNumber; }*
* *d)function store(uint256 _favoriteNumber) public { _favoriteNumber = favoriteNumber; }*
<details>
  <summary>Click to reveal answer</summary>
  <p>function store(uint256 _favoriteNumber) public { favoriteNumber = _favoriteNumber; }</p>
</details>

**9. What keyword can be used in a function declaration to specify that the function can only be accessed from within the same contract?**
* *a) internal*
* *b) public*
* *c) external*
* *d) private*
<details>
  <summary>Click to reveal answer</summary>
  <p>private</p>
</details>

***

# Zksync Bridging
A guide to bridging from the Ethereum Sepolia testnet to the zkSync Sepolia testnet. This is a step-by-step guide to acquire zkSync ETH on the testnet using the _bridging method_.

## Wallet Connection
- Begin by navigating to the [zkSync Bridge](https://portal.zksync.io/bridge) app and clicking on the "Connect Wallet" button. Select MetaMask, and when prompted, enter your password. After connecting, ensure you are on the **Sepolia Test Network**. If you lack Sepolia ETH, use the [GCP faucet](https://cloud.google.com/application/web3/faucet/ethereum/sepolia) or any other [recommended testnet faucets](https://github.com/Cyfrin/foundry-full-course-cu?tab=readme-ov-file#testnet-faucets).

## Bridging Sepolia
- To bridge Sepolia ETH to zkSync, select the "zkSync" button at the top right of the zkSync bridge page and switch to the ["zkSync Sepolia Testnet"](https://portal.zksync.io/bridge/?network=sepolia). The interface will display the option to bridge from the Ethereum Sepolia Testnet.

## Transferring Funds
- Next, return to MetaMask and make a small transfer of Sepolia ETH to zkSync Sepolia (even 0.001 ETH is sufficient to deploy a smart contract).

> 👀❗ **IMPORTANT**\
> Be sure to use a testnet wallet, where no real money is present.

- Select "Continue," and proceed to bridge your funds. Confirm the transaction on MetaMask, and your funds will be transferred within 15 minutes.

- While waiting, you can add the zkSync Sepolia Testnet to MetaMask. Go to [Chainlist](https://chainlist.org/), search for "zkSync Sepolia" while including testnets, and connect your wallet. Approve the network addition and switch to the zkSync Sepolia Testnet.

- Once the transaction completes, you will see the funds appear in your MetaMask wallet under the zkSync Sepolia Testnet. With the correct funds in your wallet, you can now proceed to deploy contracts in Remix.

# Zksync Plugin
- This is the same type of layer 2 or rollup deployment that professional developers are using.
 
- On Remix, start by activating the **zkSync plugin** in our environment. In the _plugin manager_, search for "zkSync" and activate the zkSync module. You'll notice that a new zkSync tab on the left side will appear.

![zksync-module](../deploymentImages/zksync-module.png)

- This module is made of sections for compiling, deploying, and interacting with contracts on zkSync.

## Compiling
Compile the `SimpleStorage.sol` file by hitting the "Compile" button.

> 👀❗**IMPORTANT**\
> Ensure that the **Solidity Compiler Version** in the contract matches the _[zkSync compiler requirements](https://github.com/Cyfrin/foundry-full-course-cu?tab=readme-ov-file#zksync-l2-deploy)_. As of this recording, the required version is `0.8.24`.

## Deploying
- After compilation, you can go to the `environment tab` to connect your MetaMask wallet, ensuring it is set to the _zkSync Sepolia testnet_. Once connected, you can **deploy and verify** the `SimpleStorage` contract.

![wallet](../deploymentImages/wallet.png)

## Verifying Deployment
- After hitting the deploy button, MetaMask will request a **signature**. Approve it, and after a short delay, a detailed output will appear indicating the deployment status. If the terminal output shows a green "verification successful" message, it means that your contract has been both deployed and verified correctly.

## Checking the Deployment
- To check our deployment, you can copy the contract address and paste it into the [zksync Sepolia explorer](https://sepolia.explorer.zksync.io/). Here, you can view the contract details.

# Zksync Remix Plugin Minor Bug
> Ensure that your `SimpleStorage.sol` smart contract is on Remix. Then, you can enter the zkSync plugin and compile the file. However, even after a successful compilation, the deploy tab will still display the message _`no smart contracts ready for deployment`_.

> This issue arises due to a small bug in the plugin, which requires your smart contracts to be inside a **`contracts`** **folder**. To resolve this, you can create a new folder named 'contracts' and move your smart contract into it. You can then proceed to compile the contract again, and you should be able to deploy it without any issues.

# Zksync Interactions
> In the zkSync module section `transactions`, you'll find buttons for calling `SimpleStorage` functions like `addPerson`, `listOfPeople`, `nameToFavoriteNumber`, `retrieve`, and `store`. Clicking the blue buttons will display the output in the terminal, while the orange buttons are used for storing values.

***

# Section Recap

## EVM (Ethereum Virtual Machine)
- It is a decentralized computational engine that executes smart contracts. It is a standard for how to compile and deploy smart contracts to blockchain. Any contract that it's written in Solidity, can be deployed to any EVM-compatible blockchain. Examples of such blockchains and Layer 2 solutions include **Ethereum**, **Polygon**, **Arbitrum**, **Optimism**, and **ZKsync**.

> 🚧 **WARNING**\
> Although a blockchain like ZKsync may be EVM-compatible, it is essential to verify that all Solidity keywords are supported.

## Contract Setup
- Before writing any smart contract, always specify the Solidity version you intend to work with. Additionally, include the SPDX license identifier at the top of your file.

```solidity
// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
```

- Next, create a contract object. In Solidity, a `contract` is similar to a class in other programming languages. Everything within the curly brackets `{}` is part of the contract's scope.

## Types and Structures
- Solidity supports various primitive types such as `uint256` and `bool`, allows the creation of custom types with `struct`, and supports arrays and mappings.

## Functions and Behavior
- Functions in Solidity can modify the state of the blockchain and execute transactions. Functions that do not modify the blockchain’s state are declared with `view` or `pure` keywords.

## Data Locations and Memory
- Solidity lets you specify different data locations for strings, structs, and array variables. The terms `calldata` and `memory` denote temporary variables that exist only for the duration of a function call. Conversely, `storage` variables are permanent and remain in the contract indefinitely. Function parameters cannot be `storage` variables, as they exist only for the duration of the function call.

- When you compile your smart contract, the Solidity code is converted into EVM-compatible bytecode, which is machine-readable code.

## Conclusion
- Mastering the fundamentals of Solidity, including contract setup, data management, and function behaviors, provides a robust foundation for developing powerful decentralized applications. This foundational knowledge is essential for navigating the complexities of blockchain technology and leveraging its full potential.