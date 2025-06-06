# Setting up your first contract

- The basics of Remix and how to create and compile your first contract.

## Remix IDE

- Remix IDE is used to build and develop smart contracts in solidity. It helps to easily visualize and interact with our smart contracts. It contains a file explorer that hosts all the files, a solidity compiler and a tab where you can deploy your contracts.

## Compiler Directive

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

## Writing the Smart Contract

- Start by writing your contract using the keyword contract. Give it a name, e.g., SimpleStorage. All the code inside the curly brackets will be considered part of this contract.

```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    //here we'll place the content of the contract
}

```

***
Basic Data Types: boolean, uint, int, address, bytes uint - unsigned integer i.e positive whole number, no decimals or fractions

uint64 favNum = 88 //64 value represents the bits, the bigger the assigned number can be uint && uint256 are the same so without assigning bits the default is 256

Function Visibility Specifiers public -accessible from both inside the contract and from external contracts (Creates a getter function for storage/state variables) private -accessible only within the current contract. It does not hide a value but only restricts its access. external -used only for functions. Visible only from outside the contract. internal -accessible by the current contract and any contracts derived from it.

If a visibility specifier is not given, it defaults to internal.

Pure and View keywords function retrieve() public view returns(uint256) { return favoriteNumber; }

function retrieve() public pure returns(uint256) { return 7; }

The terms view and pure are used when a function reads values from the blockchain without altering its state. Such functions will not initiate transactions but rather make calls, represented as blue buttons in the Remix interface. A pure function will prohibit any reading from the state or storage.

Calling a pure or view function does cost gas only when a gas cost transaction or function is calling it

Array of struct This combines two concepts: arrays and structs

Person[] public list_of_people; // this is a dynamic array. We can add as many Person objects as we like, as the size of the array is not static but can grow and shrink. We can access each Person object in our array by its index. Person[3] public another_list_of_three_people; // this is a static array. This can only have a maximum of 3

Data Locations Solidity can store data in six different locations.

    Calldata
    Memory
    Storage
    Stack
    Code
    Logs

Calldata and Memory Variables In Solidity, calldata and memory are temporary storage locations for variables during function execution. calldata is temporary read-only, used for function inputs that can't be modified. memory allows for read-write access, letting variables be changed within the function. To modify calldata variables, they must first be loaded into memory.

//Calldata and Memory both mean temporary variables. Memory data can be changed while Calldata cannot.

Warning... Most Variable types default to memory automatically. However, for strings , you must specify either 'memory' or 'calldata'

Storage variables Permanent variables that can be modified If you create a variable outside a function inside of a contract it automatically becomes a storage variable