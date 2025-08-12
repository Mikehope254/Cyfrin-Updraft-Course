# Introduction

In this section, we'll refer to the `FundMe` contract we built in the previous section. Additionally, we will explore storage using the [FunWithStorage](https://github.com/Cyfrin/foundry-fund-me-cu/blob/main/src/exampleContracts/FunWithStorage.sol) contract and interact with it using `cast`.

We'll also learn professional deployment techniques on different chains with Foundry [scripts](https://github.com/Cyfrin/foundry-fund-me-cu/blob/main/script/DeployFundMe.s.sol). They will enable us to interact with contracts through **reproducible actions** instead of typing commands manually each time.

Furthermore, we'll cover making contracts more gas-efficient, some debugging techniques, and setting up a professional development environment.
Lastly, we'll implement a lot of tests to ensure the reliability and security of our smart contracts.

# FundMe Project Setup

Here we'll cover Fund Me, a simple funding contract.

You will learn:

   - How to push your project to GitHub

   - Write and run amazing tests

   - Advanced deploy scripts, used to deploy on different chains that require different addresses

   - How to use scripts to interact with contracts, so we can easily reproduce our actions

   - How to use a price feed

   - How to use Chisel

   - Smart contract automation

   - How to make our contracts more gas efficient

   - And many more interesting things!

Until now, we talked a lot about storage and state, but we didn't delve into what they really mean. We will learn what all these means!

We used this project before when we used Remix.

## Fund Me

Going through the [repo](https://github.com/Cyfrin/foundry-fund-me-f23) we can see that our contract is in the src folder. Let's open `FundMe.sol`.

As you can see we are employing some advanced tools/standard naming conventions:

   - We use a named error `FundMe__NotOwner()`;

   - We use all caps for constants

   - `i_` for immutable variables

   - `s_` for private variables

Let's clone this project locally. Open your VS Code, and make sure you are in the `foundry-f23` folder, if not use `cd` to navigate to it.

If we run the `ls` command in the terminal, we'll see that the only thing present in the `foundry-f23` folder is the `foundry-simple-storage-f23` folder that we used in the previous section.

Run the following command in your terminal:

```bash
mkdir foundry-fund-me-f23
cd foundry-fund-me-f23
code .
```

The first line creates a new folder called `foundry-fund-me-f23`. The second line changed the directory into the newly created folder. The last line opens up a new VS Code instance using the newly created folder.

Now we can apply the knowledge we acquired in the previous section to create a fresh Foundry project.

### Do you remember how?

If you do, please proceed in creating a Foundry project on your own. If not peek down below.

No worries, we all forget stuff, please run the following command:

```bash
forge init
```

or

```bash
forge init --force
```

Foundry will populate the project with the `Counter` files, the script, the main contract and the test.

Before deleting it, let's look a bit through these.

# Introduction to Smart Contract Testing

### Counter.sol

It's a simple smart contract that stores a number. You have a function to `setNumber` where you specify a `newNumber` which is a `uint256`, and store it, and you have a function to `increment` the number.

Note: `number++` is equivalent to `number = number + 1`.

### Counter.s.sol

Just a placeholder, it doesn't do anything

### Counter.t.sol

This is the interesting part. We haven't talked that much about carrying tests using Foundry. This is an essential step for any project. The `test` folder will become our new home throughout this course.

Please run the following command in your terminal:

```bash
forge test
```

After the contracts are compiled you will see an output related to tests:

   - How many tests were found;

   - In which file;

   - Did they pass or not?;

   - Summary;

## How does `forge test` work?

`forge test` has a lot of options that allow you to configure what is tested, how the results are displayed, where is the test conducted and many more!

Run `forge test --help` to explore the options. I suggest reading [this page](https://book.getfoundry.sh/forge/tests) and navigating deeper into the Foundry Book to discover how tests work.

But in short, in our specific case:

   1. Forge identified all the files in the test folder, went into the only file available and ran the `setUp` function.

   2. After the setup is performed it goes from top to bottom in search of public/external functions that start with `test`.

   3. All of them will be called and the conclusion of their execution will be displayed. By that we mean it will run all the `assert` statements it can find and if all evaluate to `true` then the test will pass. If one of the `assert` statements evaluates to `false` the test will fail.

# Finishing the Setup

Please delete the `Counter` files that Foundry prepopulated in our new project.

In `src` create two files, `FundMe.sol` and `PriceConverter.sol`.

Go on the [Remix Fund Me repo](https://github.com/Cyfrin/remix-fund-me-f23) and copy the contents of both contracts.

Try running `forge compile` or `forge build`. A few errors will pop up. What's the problem?

If you open both the copied smart contracts you will see that up top we `import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";`. This wasn't a problem in Remix because Remix automatically takes care of this problem for you. In Foundry you have to manually install all your dependencies.

`forge install` is the command we are using to install one or multiple dependencies. [Go here](https://getfoundry.sh/forge/reference/install#forge-install) to read more about this command.

Call the following:

```bash
forge install smartcontractkit/chainlink-brownie-contracts@ 
```

Wait for it to finish.

We used `forge install` to ask Forge to install something in our project. What? We specified the path to a GitHub repository, this also could have been a raw URL. What version? Following the path to a GitHub repository you can add an `@` and then you can specify:

   - A branch: master

   - A tag: v1.2.3.4 or 0.6.1 in our case

   - A commit: 8e8128

> Newer Foundry versions don’t auto-commit hence do not require "--no-commit"

If we open the `lib` folder, we can see the `forge-std` which is installed automatically within the `forge init` setup and `chainlink-brownie-contracts` which we just installed. Look through the former, you'll see a folder called contracts then a folder called `src`. Here you can find different versions, and inside them, you can find a plethora of contracts, some of which we are going to use in this course. Here we can find the `AggregatorV3Interface` that we are importing in `FundMe.sol`.

But if you open the `FundMe.sol` you'll see that we are importing `{AggregatorV3Interface}` from `"@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";` not from `/foundry-fund-me-f23/lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol`. How does Foundry know `@chainlink` to half of the path?

Open `foundry.toml`. Below the last line of `[profile.default]` paste the following:

```toml
remappings = ['@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/']
```

Now Forge knows to equivalate these. Let's try to compile now by calling `forge compile` or `forge build`.

Awesome! Everything complies.

Fixing dependencies in projects is one of the most undesirable things in smart contracts development/audit. Take it slow, make sure you select the proper GitHub repository path, make sure your remappings are solid and they match your imports and everything will be fine!

# Writing tests for your Solidity smart contract

Testing is a crucial step in your smart contract development journey, as the lack of tests can be a roadblock in the deployment stage or during a smart contract audit.

So, buckle up as we unveil what separates the best developers from the rest: comprehensive, effective tests!

Inside the `test` folder create a file called `FundMeTest.t.sol`. `.t.` is a naming convention of Foundry, please use it.

The writing of a test contract shares the initial steps with the writing of a normal smart contract. We state the `SPDX-License-Identifier`, solidity version and a contract name:

```solidity
// SPDX-License-Identifier: MIT
​
pragma solidity ^0.8.18;
​
contract FundMeTest {
​
}
```

To be able to run tests using Foundry we need to import the set of smart contracts Foundry comes with that contains a lot of prebuilt functions that make our lives 10x easier.

```solidity
import {Test} from "forge-std/Test.sol";
```

We also make sure our test contract inherits what we just imported.

```solidity
contract FundMeTest is Test{
```

The next logical step in our testing process is deploying the `FundMe` contract. In the future, we will learn how to import our deployment scripts, but for now, let's do the deployments right in our test file.

We do this inside the `setUp` function. This function is always the first to execute whenever we run our tests. Here we will perform all the prerequisite actions that are required before doing the actual testing, things like:

   - Deployments;

   - User addresses;

   - Balances;

   - Approvals;

   - And various other operations depending on what's required to initiate the tested contracts.

But before that, please create another function, called `testDemo`.

Your test contract should look like this:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
​
import {Test} from "forge-std/Test.sol";
​
contract FundMeTest is Test {
​
    function setUp() external { }
​
    function testDemo() public { }
​
 }
```

Now run `forge test` in your terminal. This command has a lot of options, you can find more about those [here]().

Our (empty) test passed! Great!

Ok, but how does it work? What's the order of things?

Please update the contract to the following:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
​
import {Test} from "forge-std/Test.sol";
​
contract FundMeTest is Test {
​
    uint256 favNumber = 0;
    bool greatCourse = false;
​
    function setUp() external { 
        favNumber = 1337;
        greatCourse = true;
    }
​
    function testDemo() public { 
        assertEq(favNumber, 1337);
        assertEq(greatCourse, true);
    }
​
 }
```

Call forge test again.

As you can see our test passed. What do we learn from this?

   1. We declare some state variables.

   2. Next up `setUp()` is called.

   3. After that forge runs all the test functions.

Another nice way of testing this and also an important tool for debugging is `console.log`. The `console` library comes packed in the Test.sol that we imported, we just need to update the things we import to this:

```solidity
import {Test, console} from "forge-std/Test.sol";
```

Let's insert some `console.log` calls inside our contract:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
​
import {Test, console} from "forge-std/Test.sol";
​
contract FundMeTest is Test {
​
    uint256 favNumber = 0;
    bool greatCourse = false;
​
    function setUp() external { 
        favNumber = 1337;
        greatCourse = true;
        console.log("This will get printed first!");
    }
​
    function testDemo() public { 
        assertEq(favNumber, 1337);
        assertEq(greatCourse, true);
        console.log("This will get printed second!");
        console.log("Updraft is changing lives!");
        console.log("You can print multiple things, for example this is a uint256, followed by a bool:", favNumber, greatCourse);
    }
 }
```

`forge test` has an option called verbosity. By controlling this option we decide how verbose should the output of the `forge test` be. The default `forge test` has a verbosity of 1. Here are the verbosity levels, choose according to your needs:

```solidity
    Verbosity levels:
    - 2: Print logs for all tests
    - 3: Print execution traces for failing tests
    - 4: Print execution traces for all tests, and setup traces for failing tests
    - 5: Print execution and setup traces for all tests
```

Given that we want to see the printed logs, we will call `forge test -vv` (the number of v's indicates the level).

```solidity
Ran 1 test for test/FundMe.t.sol:FundMeTest
[PASS] testDemo() (gas: 9482)
Logs:
  This will get printed first!
  This will get printed second!
  Updraft is changing lives!
  You can print multiple things, for example this is a uint256, followed by a bool: 1337 true
​
Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 422.20µs (63.30µs CPU time)
```

Let's delete the logs for now, but keep the console import. We could use it later for debugging.

Let's deploy the `FundMe` contract.

For that, we will first need to import it into our test file, then declare it as a state variable and deploy it in the `setUp` function.

## Testing FundMe

Delete `testDemo.` Make a new function called `testMinimumDollarIsFive`. As the name states, we will test if the `MINIMUM_USD` is equal to `5e18`.

```solidity
    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
```

Run it with `forge test`.

```solidity
[⠰] Compiling...
[⠆] Compiling 1 files with 0.8.25
[⠰] Solc 0.8.25 finished in 827.51ms
Compiler run successful!
​
Ran 1 test for test/FundMe.t.sol:FundMeTest
[PASS] testMinimumDollarIsFive() (gas: 5453)
Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 487.20µs (43.20µs CPU time)
​
```

Great job! Let's delete the `favNumber` and `greatCourse` to keep our test file nice and clean.

Try to change the right side of the `assertEq` line to check what a failed test looks like.

Awesome! You just completed your first Forge test, get used to writing those because whether you are going to be a developer or an auditor you will write _A LOT_ of them.

# Quiz 6

**1. What is a common naming convention used in Solidity for constant variables, enhancing code readability and adherence to style guides?**
* *a) ALL_CAPS_SNAKE_CASE (e.g., `MAXIMUM_VALUE`)*
* *b) PascalCase (e.g., `MaximumValue`)*
* *c) kebab-case (e.g., `maximum-value`)*
* *d) camelCase (e.g., `maximumValue`)*

<details>
  <summary>Click to reveal answer</summary>
  <p>a) ALL_CAPS_SNAKE_CASE (e.g., `MAXIMUM_VALUE`)</p>
</details>

**2. When testing smart contracts, what is the typical purpose of using functions or directives like `vm.expectRevert()` or similar constructs?**
* *a) To assert that a specific function call fails under defined conditions, ensuring proper error handling.*
* *b) To automatically deploy mock contracts required for the test setup.*
* *c) To simulate network latency during function execution.*
* *d) To measure the exact gas cost of a successful transaction.*

<details>
  <summary>Click to reveal answer</summary>
  <p>a) To assert that a specific function call fails under defined conditions, ensuring proper error handling.</p>
</details>

**3. Which Foundry command-line tool is specifically mentioned for interacting with contracts, including inspecting storage?**
* *a) anvil*
* *b) forge*
* *c) cast*
* *d) deploy*

<details>
  <summary>Click to reveal answer</summary>
  <p>c) cast</p>
</details>

**4. In programming languages like Solidity, what operation is typically performed by the postfix increment operator (`++`) on a numerical variable?**
* *a) It increases the value of the variable by 1.*
* *b) It doubles the value of the variable*
* *c) It decreases the value of the variable by 1.*
* *d) It sets the value of the variable to 0.*

<details>
  <summary>Click to reveal answer</summary>
  <p>a) It increases the value of the variable by 1.</p>
</details>

**5. Which command is typically used to initialize a new project using the Foundry development toolkit?**
* *a) foundry start*
* *b) foundry build*
* *c) forge new project*
* *d) forge init*

<details>
  <summary>Click to reveal answer</summary>
  <p>d) forge init</p>
</details>

**6. In Solidity development, what is a common naming convention prefix for immutable variables?**
* *a) i_*
* *b) p_*
* *c) c_*
* *d) s_*

<details>
  <summary>Click to reveal answer</summary>
  <p>a) i_</p>
</details>

**7. In software development, particularly for systems where errors can be costly, what is the primary goal of executing automated tests before deployment?**
* *a) To generate user documentation based on code comments.*
* *b) To verify that the system's logic behaves as expected and identify potential errors.*
* *c) To reduce the time spent writing the initial code.*
* *d) To automatically optimize the code for performance.*

<details>
  <summary>Click to reveal answer</summary>
  <p>b) To verify that the system's logic behaves as expected and identify potential errors.</p>
</details>

**8. What command is typically used to execute the test suite in a Foundry project?**
* *a) forge test*
* *b) solidity test*
* *c) forge compile*
* *d) foundry run tests*

<details>
  <summary>Click to reveal answer</summary>
  <p>a) forge test</p>
</details>

**9. After initializing a new Foundry project or installing dependencies, where are external libraries typically stored?**
* *a) In the `src` directory.*
* *b) In the `test` directory.*
* *c) In the `lib` directory.*
* *d) In the `script` directory.*

<details>
  <summary>Click to reveal answer</summary>
  <p>c) In the `lib` directory.</p>
</details>

**10. If source code fails to compile in a local development setup due to an error stating an imported file (e.g., '@some-library/contracts/SomeInterface.sol') was 'not found', what is the most probable cause?**
* *a) The development framework fundamentally lacks the capability to handle import statements*
* *b) The version of the compiler being used does not support the features used in the imported file.*
* *c) There is a critical syntax error within the source code file that is attempting the import.*
* *d) The required external library that contains the specified file has not been downloaded and installed into the project's dependencies.*

<details>
  <summary>Click to reveal answer</summary>
  <p>d) The required external library that contains the specified file has not been downloaded and installed into the project's dependencies.</p>
</details>

**11. When writing tests in certain Solidity testing environments, how are functions usually designated to be recognized and executed as individual test cases?**
* *a) By marking the function with a specific `//@test` comment.*
* *b) By declaring the function with `external` visibility only.*
* *c) By ensuring the function returns a boolean value indicating success or failure.*
* *d) By prefixing the function name with `test`.*

<details>
  <summary>Click to reveal answer</summary>
  <p>d) By prefixing the function name with `test`.</p>
</details>

**12. What file naming convention is often used by testing frameworks like Foundry to automatically discover Solidity files containing tests?**
* *a) Starting the filename with the prefix `Test_`.*
* *b) Ensuring the file contains at least one contract inheriting from a base `Testable` contract.*
* *c) Placing all test files within a directory named `__tests__`.*
* *d) Appending a specific suffix, such as `.t.sol`, to the filename.*

<details>
  <summary>Click to reveal answer</summary>
  <p>d) Appending a specific suffix, such as `.t.sol`, to the filename.</p>
</details>

# Debug your Solidity tests

Let's continue writing tests for our FundMe contract. Let's test if the owner (which should be us) is recorded properly.

Add the following function to your testing file:

```solidity
function testOwnerIsMsgSender() public {
    assertEq(fundMe.i_owner(), msg.sender);
}
​```

Run it via `forge test`.

Output:

```
Ran 2 tests for test/FundMe.t.sol:FundMeTest
[PASS] testMinimumDollarIsFive() (gas: 5453)
[FAIL. Reason: assertion failed] testOwnerIsMsgSender() (gas: 22521)
Suite result: FAILED. 1 passed; 1 failed; 0 skipped; finished in 3.85ms (623.00µs CPU time)
​
Ran 1 test suite in 367.24ms (3.85ms CPU time): 1 tests passed, 1 failed, 0 skipped (2 total tests)
​
Failing tests:
Encountered 1 failing test in test/FundMe.t.sol:FundMeTest
[FAIL. Reason: assertion failed] testOwnerIsMsgSender() (gas: 22521)
```

So ... why did it fail? Didn't we call the `new FundMe();` to deploy, making us the owner?

We can find the answer to these questions in various ways, in the last lesson we learned about `console.log`, let's add some `console.log`s to see more information about the two elements of the assertion.

```solidity
    function testOwnerIsMsgSender() public {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }
```

Let's run `forge test -vv`:

```solidity
Ran 2 tests for test/FundMe.t.sol:FundMeTest
[PASS] testMinimumDollarIsFive() (gas: 5453)
[FAIL. Reason: assertion failed] testOwnerIsMsgSender() (gas: 26680)
Logs:
  0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
  0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
  Error: a == b not satisfied [address]
        Left: 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
       Right: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
​
Suite result: FAILED. 1 passed; 1 failed; 0 skipped; finished in 975.40µs (449.20µs CPU time)
​
Ran 1 test suite in 301.60ms (975.40µs CPU time): 1 tests passed, 1 failed, 0 skipped (2 total tests)
​
Failing tests:
Encountered 1 failing test in test/FundMe.t.sol:FundMeTest
[FAIL. Reason: assertion failed] testOwnerIsMsgSender() (gas: 26680)
```

Ok, so the addresses are different, but why?

Technically we are not the ones that deployed the `FundMe` contract. The `FundMe` contract was deployed by the `setUp` function, which is part of the `FundMeTest` contract. So, even though we are the ones who called `setUp` via `forge test`, the actual testing contract is the deployer of the `FundMe` contract.

To test the above let's tweak the `testOwnerIsMsgSender` function:

```solidity
    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), address(this));
    }
```

Run `forge test`. It passes! Congratulations!

Feel free to try and write other tests!

# Advanced deploy scripts

When we went straight to testing, we left behind a very important element: deploy scripts. Why is this important you ask? Because we need a certain degree of flexibility that we can't obtain in any other way, let's look through the two files `FundMe.sol` and `PriceConverter.sol`, we can see that both have an address (`0x694AA1769357215DE4FAC081bf1f309aDC325306`) hardcoded for the AggregatorV3Interface. This address is valid, it matches the AggregatorV3 on Sepolia but what if we want to test on Anvil? What if we deploy on mainnet or Arbitrum? What then?

The deploy script is the key to overcome this problem!

Create a new file called `DeployFundMe.s.sol` in script folder. Please use the `.s.sol` naming convention.

We start with stating the SPDX and pragma:

```solidity
//SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
```

After that, we need the imports. We are working on a Foundry Script, thus the next logical step is to import `Script.sol`

```solidity
import {Script} from "forge-std/Script.sol";
```

Another thing that we need for our deploy script to work is to import the contract we want to deploy.

```solidity
import {FundMe} from "../src/FundMe.sol";
```

We are ready to define the contract. Remember how we did scripts a couple of lessons ago? Try to do it yourself.

```solidity
// SPDX-License_identifier: MIT
​
pragma solidity ^0.8.18;
​
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
​
contract DeployFundMe is Script {
    function run() external{
        vm.startBroadcast();
        new FundMe();
        vm.stopBroadcast();
    }  
}
```

Now let's try it with `forge script DeployFundMe`.

Everything was ok! Congrats!

# Running tests on chains forks

This course will cover 4 different types of tests:

   - **Unit tests**: Focus on isolating and testing individual smart contract functions or functionalities.

   - **Integration tests**: Verify how a smart contract interacts with other contracts or external systems.

   - **Forking tests**: Forking refers to creating a copy of a blockchain state at a specific point in time. This copy, called a fork, is then used to run tests in a simulated environment.

   - **Staging tests**: Execute tests against a deployed smart contract on a staging environment before mainnet deployment.

Coming back to our contracts, the central functionality of our protocol is the `fund` function.

For that to work, we need to be sure that Aggregator V3 runs the current version. We know from previous courses that the version returned needs to be `4`. Let's put it to the test!

Add the following code to your test file:

```javascript
function testPriceFeedVersionIsAccurate() public {
    uint256 version = fundMe.getVersion();
    assertEq(version, 4);
}
```

It ... fails. But why? Looking through the code we see this AggregatorV3 address `0x694AA1769357215DE4FAC081bf1f309aDC325306` over and over again. The address is correct, is the Sepolia deployment of the AggregatorV3 contract. But our tests use Anvil for testing purposes, so that doesn't exist.

Note: Calling forge test over and over again when you are testing is not always efficient, imagine you have tens or hundreds of tests, some of them taking seconds to finish. From now on, when we test specific things let's use the following:

```solidity
forge test --mt testPriceFeedVersionIsAccurate or
forge test --match-test testPriceFeedVersionIsAccurate
```

Back to our problem, how can we fix this?

Forking is the solution we need. If we run the test on an anvil instance that copies the current Sepolia state, where AggregatorV3 exists at that address, then our test function will not revert anymore. For that, we need a Sepolia RPC URL.

Remember how in a [previous lesson we deployed a smart contract on Sepolia](https://updraft.cyfrin.io/courses/foundry/foundry-simple-storage/deploying-smart-contract-testnet-sepolia)? It's similar, we can use the same RPC we used back then.

Thus:

   1. Create a .env file. (Also make sure that your `.gitignore` file contains the `.env` entry)

   2. In the `.env` file create a new entry as follows:
    
```solidity
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOURAPIKEYWILLGOHERE
```

   3. Run `source .env` or `echo $SEPOLIA_RPC_URL` in your terminal;

   4. Run `forge test --mt testPriceFeedVersionIsAccurate --fork-url $SEPOLIA_RPC_URL`

```solidity
Ran 1 test for test/FundMe.t.sol:FundMeTest
[PASS] testPriceFeedVersionIsAccurate() (gas: 14118)
Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 2.29s (536.03ms CPU time)
```

Nice!

Please keep in mind that forking uses the Alchemy API, it's not a good idea to run all your tests on a fork every single time. But, sometimes as in this case, you can't test without. It's very important that our test have a high coverage, to ensure all our code is battle tested.

## Coverage

Foundry provides a way to calculate the coverage. You can do that by calling `forge coverage`. This command displays which parts of your code are covered by tests. Read more about its options [here](https://book.getfoundry.sh/reference/forge/forge-coverage?highlight=coverage#forge-coverage).

```solidity
forge coverage --fork-url $SEPOLIA_RPC_URL
```

```solidity
Ran 3 tests for test/FundMe.t.sol:FundMeTest
[PASS] testMinimumDollarIsFive() (gas: 5759)
[PASS] testOwnerIsMsgSender() (gas: 8069)
[PASS] testPriceFeedVersionIsAccurate() (gas: 14539)
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 1.91s (551.69ms CPU time)
​
Ran 1 test suite in 2.89s (1.91s CPU time): 3 tests passed, 0 failed, 0 skipped (3 total tests)
| File                      | % Lines       | % Statements  | % Branches    | % Funcs      |
| ------------------------- | ------------- | ------------- | ------------- | ------------ |
| script/DeployFundMe.s.sol | 0.00% (0/3)   | 0.00% (0/3)   | 100.00% (0/0) | 0.00% (0/1)  |
| src/FundMe.sol            | 21.43% (3/14) | 25.00% (5/20) | 0.00% (0/6)   | 33.33% (2/6) |
| src/PriceConverter.sol    | 0.00% (0/6)   | 0.00% (0/11)  | 100.00% (0/0) | 0.00% (0/2)  |
| Total                     | 13.04% (3/23) | 14.71% (5/34) | 0.00% (0/6)   | 22.22% (2/9) |

```

These are rookie numbers! Maybe 100% is not feasible, but 13% is as good as nothing. In the next lessons, we will up our game and increase these numbers!

# Refactoring your tests

The way our code is currently structured is not that flexible. Given the hardcoded Sepolia address we cannot deploy to other chains, and if we wish to do so we would have to come and copy-paste another address everywhere throughout the code. In bigger codebases, with multiple addresses / other items to copy-paste for each deployment (in case we deploy on multiple chains) this update activity is extremely prone to error. We can do better.

To fix this we can make our project more modular, which would help improve the maintainability, testing and deployment. This is done by moving the hardcoded changing variables to the constructor, thus regardless of the chain we deploy our contracts to, we provide the chain-specific elements once, in the constructor, and then we are good to go.

Changing code without changing its functionality bears the name of refactoring.

Do the following modifications in `FundMe.sol`.

  1. In the storage variables section create a new variable:

```solidity
AggregatorV3Interface private s_priceFeed;
```

  2. We need to add this as an input in our constructor and assign it to the state variable. This is done as follows:

```solidity
constructor(address priceFeed){
    i_owner = msg.sender;
    s_priceFeed = AggregatorV3Interface(priceFeed);
}
```

  3. Inside the `getVersion` function, where AggregatorV3Interface is invoked, replace the hardcoded address with the state variable s_priceFeed:

```solidity
function getVersion() public view returns (uint256){
    AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeed);
    return priceFeed.version();
}
```

  4. In `PriceConverter.sol` modify the `getPrice` function to take an input function `getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {` and delete the` AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);` line;

   5. In the same library update `getConversionRate` to take a `priceFeed` input and update the first line to pass the required AggregatorV3Interface to the `getPrice` function:
    
```solidity
function getConversionRate(
    uint256 ethAmount,
    AggregatorV3Interface priceFeed
) internal view returns (uint256) {
    uint256 ethPrice = getPrice(priceFeed);
    uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
    // the actual ETH/USD conversion rate, after adjusting the extra 0s.
    return ethAmountInUsd;
}
```

   6. Back in `FundMe.sol` pass the s_priceFeed as input for `getConversionRate` in the `fund` function.

Take a moment and think if we missed updating anything in our project.

Ready? The deploy script is not providing the `priceFeed` as an input when calling `new FundMe();`, also, the `setUp` function in `FundMe.t.sol` is not providing the `priceFeed` as an input when calling `fundMe = new FundMe();`.

For now, let's hardcode the address `0x694AA1769357215DE4FAC081bf1f309aDC325306` in both places.

As you've figured out this isn't ideal either. Every time we want to do something from now on do we have to update in both places? Not good.

Update the `run` function from the `DeployFundMe` script:

```solidity
function run() external returns (FundMe) {
    vm.startBroadcast();
    FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    vm.stopBroadcast();
    return fundMe
}
```
Now when we call run it returns the `FundMe` contract we deployed.

In `FundMe.t.sol`:

   1. Let's import the deployment script into the `FundMe.t.sol`.
   
```solidity
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
```

   2. Create a new state variable `DeployFundMe deployFundMe;`;

   3. Update the `setUp` function as follows:

```solidity
function setUp() external {
    deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
}
```

Let's call a `forge test --fork-url $SEPOLIA_RPC_URL` to make sure everything compiles.

Looks like the `testOwnerIsMsgSender` fails again. Take a moment and think about why.

When we changed the method of deployment and made it go through the run command of the deployFundMe contract we also changed the owner.

Note: `vm.startBroadcast` is special, it uses the address that calls the test contract or the address / private key provided as the sender. You can read more about it here.

To account for the way `vm.startBroadcast` works please perform the following modification in `FundMe.t.sol`:

```solidity
function testOwnerIsMsgSender() public {
    assertEq(fundMe.i_owner(), msg.sender);
}
```

Run `forge test --fork-url $SEPOLIA_RPC_URL` again.

Congrats!

# Deploy a mock priceFeed

## Testing locally

In the previous lesson, we refactored our contracts to avoid being forced to use Sepolia every single time when we ran tests. The problem is we didn't quite fix this aspect. We made our contracts more flexible by changing everything for us to input the `priceFeed` address only once. We can do better!

It is very important to be able to run our all tests locally. We will do this using a mock contract.

Before we dive into the code, let's emphasize why this practice is so beneficial. By creating a local testing environment, you reduce your chances of breaking anything in the refactoring process, as you can test all changes before they go live. No more hardcoding of addresses and no more failures when you try to run a test without a forked chain. As a powerful yet simple tool, a mock contract allows you to simulate the behavior of a real contract without the need to interact with a live blockchain.

Thus, on our local Anvil blockchain we will deploy a contract that mimics the behavior of the Sepolia priceFeed.

## Where the magic happens

Please create a new file in your script folder called HelperConfig.s.sol. Here we'll write the logic necessary for our script to deploy mocks when it detects we are performing tests on our local anvil chain. Also, here we will keep track of all the contract addresses we will use across all the different chains we will interact with.

The start:

```solidity
// SPDX-License-Identifier: MIT
​
pragma solidity 0.8.19;
​
import {Script} from "forge-std/Script.sol";
​
contract HelperConfig {
    // If we are on a local Anvil, we deploy the mocks
    // Else, grab the existing address from the live network
}
```

Copy the following functions inside the contract:

```solidity
struct NetworkConfig {
    address priceFeed; // ETH/USD price feed address
}
​
function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory sepoliaConfig = NetworkConfig({
        priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    });
    return sepoliaConfig;
}
​
function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
​
}
```

We decided to structure the information we need depending on the chain we are testing on. We use a `struct` to hold this information for every chain. You might think that we could have gotten away with a simple `address variable` but that changes if we need to store multiple addresses or even more blockchain-specific information.

For now, we created a `getSepoliaEthConfig` that returns the `NetworkConfig` struct, which contains the `priceFeed` address.

What do we need to do to integrate this inside the deployment script?

First of all, we need to be aware of the chain we are using. We can do this in the constructor of the HelperConfig contract.

Update the `HelperConfig` as follows:

```solidity
NetworkConfig public activeNetworkConfig;
​
struct NetworkConfig {
    address priceFeed; // ETH/USD price feed address
}
​
constructor(){
    if (block.chainid == 11155111) {
        activeNetworkConfig = getSepoliaEthConfig();
    } else if  (block.chainid == 1) {
        activeNetworkConfig = getMainnetEthConfig();
    } 
    else {
        activeNetworkConfig = getAnvilEthConfig();
    } 
}
```

As you can see, we've defined a new state variable, called activeNetworkConfig which will be the struct that gets queried for blockchain-specific information. We will check the `block.chainId` at the constructor level, and depending on that value we select the appropriate config.

The `block.chainId` in Ethereum refers to the unique identifier of the blockchain network in which the current block is being processed. This value is determined by the Ethereum network itself and is typically used by smart contracts to ensure that they are interacting with the intended network. Go on (chainlist.org)[htps://chainlist.org] to find out the `ChainID's` of different blockchains.

Let's update the `DeployFundMe.s.sol` to use our newly created `HelperConfig`.

`import {HelperConfig} from "./HelperConfig.s.sol";`

```solidity
Add the following before the vm.startBroadcast line inside the run function:
// The next line runs before the vm.startBroadcast() is called
// This will not be deployed because the `real` signed txs are happening
// between the start and stop Broadcast lines.
HelperConfig helperConfig = new HelperConfig();
address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
```
Run the `forge test --fork-url $SEPOLIA_RPC_URL` command to check everything is fine. All tests should pass.

Great, let's keep going.

Now that we've configured it for one chain, Sepolia, we can do the same with any other chain that has a `priceFeed` address available on (Chainlink Price Feed Contract Addresses)[https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#overview]. Simply copy the `getSepoliaEthConfig` function, rename it and provide the address inside it. Then add a new `block.chainId` check in the constructor that checks the current `block.chainId` against the chainId you find on (chainlist.org)[htps://chainlist.org]. You would also need a new RPC_URL for the new blockchain you chose, which can be easily obtained from Alchemy.

This type of flexibility elevates your development game to the next level. Being able to easily test your project on different chains just by changing your RPC_URL is an ability that differentiates you from a lot of solidity devs who fumble around with hardcoded addresses.

In the next lessons, we will learn how to use Anvil in our current setup. Stay tuned.

# Refactoring the Mock Smart Contract

## Solving the Anvil problem

When we needed the Sepolia `priceFeed` we made sure that our deployments script pointed to it. How can we solve this in Anvil, because the contract that we need doesn't exist there. Simple, we deploy mocks.

Our `getAnvilEthConfig` function in `HelperConfig` must deploy a mock contract. After it deploys it we need it to return the mock address, so our contracts would know where to send their calls.

First of all, we need to make sure we import `Script.sol` in the `HelperConfig.s.sol` contract. Also, HelperConfig needs to inherit from `Script`. This will give us access to the `vm.startBroadcast/vm.stopBroadcast` functionality. We will use this to deploy our mocks. But ... what is a mock contract?

**A mock contract is a special type of contract designed to simulate the behavior of another contract during testing.**

Update your start of the `HelperConfig.s.sol` file as follows:

```solidity
import {Script} from "forge-std/Script.sol";
​
contract HelperConfig is Script {
}
```

In order to be able to deploy a mock contract we need ... a mock contract. So, in `test` folder please create a new folder called `mocks`. Inside `mocks` create a new file `MockV3Aggregator.sol`. Rewriting the AggregatorV3 as a mock is not the easiest task out there. Please copy the contents of [this contract](https://github.com/Cyfrin/foundry-fund-me-f23/blob/main/test/mock/MockV3Aggregator.sol) into your newly created file.

What next?

We need to import this in our `HelperConfig.s.sol` file and deploy it in the `getAnvilEthConfig` then return the address.

Perform the following changes in `HelperConfig`:

```solidity
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
​
[...]
​
// In state variables section
MockV3Aggregator mockPriceFeed;
​
[...]
​
function getAnvilEthConfig() public returns (NetworkConfig memory) {
    vm.startBroadcast();
    mockPriceFeed = new MockV3Aggregator(8, 2000e8);
    vm.stopBroadcast();
​
    NetworkConfig memory anvilConfig = NetworkConfig({
        priceFeed: address(mockPriceFeed)
    });
​
    return anvilConfig;
}
```

More testing and refactorings in the next lessons!

# Quiz 13

**1. Within any function of a smart contract instance, what does the expression `address(this)` evaluate to?**
* *a) The unique address of that specific contract instance.*
* *b) The address of the contract's designated owner.*
* *c) A generic placeholder for contract addresses.*
* *d) The address of the account or contract that called the current function.*

<details>
  <summary>Click to reveal answer</summary>
  <p>a) The unique address of that specific contract instance.</p>
</details>

**2. Which Foundry cheatcode commands are used to wrap the transaction(s) intended to be broadcast to the network during a script execution?**
* *a) vm.startBroadcast() and vm.stopBroadcast()*
* *b) vm.record() and vm.stopRecord()*
* *c) vm.startPrank() and vm.stopPrank()*
* *d) vm.beginDeploy() and vm.endDeploy()*

<details>
  <summary>Click to reveal answer</summary>
  <p>a) vm.startBroadcast() and vm.stopBroadcast()</p>
</details>

**3. Within the main execution function of a Foundry deploy script (like `run()`), how is a new instance of a contract typically deployed?**
* *a) Calling `vm.deployContract("FundMe");`.*
* *b) Executing `forge create FundMe`.*
* *c) Using the `new` keyword followed by the contract's name (e.g., `new FundMe();`).*
* *d) Importing and calling a special `deploy()` function from the contract.*

<details>
  <summary>Click to reveal answer</summary>
  <p>c) Using the `new` keyword followed by the contract's name (e.g., `new FundMe();`).</p>
</details>

**4. What is a widely recommended security practice for managing configuration details like RPC URLs, especially if they contain sensitive API keys?**
* *a) Encrypt the specific test files that utilize these sensitive URLs.*
* *b) Store them in environment variables, often loaded from a configuration file (e.g., `.env`) that is excluded from version control (e.g., via `.gitignore`).*
* *c) Commit them to a private version control repository accessible only to the development team.*
* *d) Embed them directly as string literals within the test code for easy access.*

<details>
  <summary>Click to reveal answer</summary>
  <p>b) Store them in environment variables, often loaded from a configuration file (e.g., `.env`) that is excluded from version control (e.g., via `.gitignore`).</p>
</details>

**5. What type of testing involves creating a copy of a blockchain's state at a specific point in time to run simulations?**
* *a) Integration tests*
* *b) Staging tests*
* *c) Unit tests*
* *d) Forking tests*

<details>
  <summary>Click to reveal answer</summary>
  <p>d) Forking tests</p>
</details>

**6. What metric does the `forge coverage` command primarily help developers measure?**
* *a) The total gas consumed by the test suite execution.*
* *b) The number of security vulnerabilities detected by static analysis.*
* *c) The percentage of the contract's code paths exercised by the existing tests.*
* *d) The time taken for the deployment scripts to complete.*

<details>
  <summary>Click to reveal answer</summary>
  <p>c) The percentage of the contract's code paths exercised by the existing tests.</p>
</details>

**7. When a smart contract's constructor assigns `msg.sender` to a state variable (e.g., `owner`), and this contract is deployed via a script called from a test that uses a broadcast mechanism (like Foundry's `vm.startBroadcast`), what address is typically assigned?**
* *a) A newly generated random address for each deployment.*
* *b) The address of the test contract executing the setup function.*
* *c) The default deployer/sender account configured in the testing or scripting environment.*
* *d) The address of the Chainlink oracle.*

<details>
  <summary>Click to reveal answer</summary>
  <p>c) The default deployer/sender account configured in the testing or scripting environment.</p>
</details>

**8. When developing a contract that relies on a Chainlink Price Feed, what configuration detail is essential to manage for multi-network deployment?**
* *a) The specific address of the Price Feed contract deployed on each target network.*
* *b) The API key for accessing Chainlink's off-chain services.*
* *c) The historical price data for the feed.*
* *d) The ABI (Application Binary Interface) of the Price Feed contract.*

<details>
  <summary>Click to reveal answer</summary>
  <p>a) The specific address of the Price Feed contract deployed on each target network.</p>
</details>

**9. In smart contract development, how can deployment scripts dynamically select network-specific parameters like contract addresses?**
* *a) By requiring users to manually input addresses during each transaction.*
* *b) By checking the `block.chainid` and using conditional logic or a configuration contract.*
* *c) By hardcoding addresses for every possible network within the main contract.*
* *d) By querying a centralized oracle for the correct addresses.*

<details>
  <summary>Click to reveal answer</summary>
  <p>b) By checking the `block.chainid` and using conditional logic or a configuration contract.</p>
</details>

**10. What architectural pattern helps manage varying external contract addresses (e.g., oracles, tokens) across different blockchain networks (like mainnet, testnets, and local)?**
* *a) Hardcoding all possible addresses directly into the main application contract.*
* *b) Storing addresses exclusively in off-chain configuration files read only during deployment.*
* *c) Employing a dedicated configuration contract that selects and returns the appropriate address based on the current network identifier.*
* *d) Requiring users to manually input the correct address every time they interact with the contract.*

<details>
  <summary>Click to reveal answer</summary>
  <p>c) Employing a dedicated configuration contract that selects and returns the appropriate address based on the current network identifier.</p>
</details>
