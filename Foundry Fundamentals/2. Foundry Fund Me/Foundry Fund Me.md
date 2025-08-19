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

# How to Refactor Magic Number

## Magic numbers or What was this exactly?

Magic numbers refer to literal values directly included in the code without any explanation or context. These numbers can appear anywhere in the code, but they're particularly problematic when used in calculations or comparisons. By using magic numbers you ensure your smart contract suffers from **Reduced Readability**, **Increased Maintenance Difficulty** and **Debugging Challenges**. You also make your work extremely prone to error, imagine you used the same magic number in 10 places and you want to change it. Will you remember all the 9 places or will you change it only in 8?

### Don't be like that.

Write clean, maintainable, and less error-prone code. You make your own life easier, you make your auditor(s) life easier. Use constants and configuration variables.

## Let's apply this.

Open `HelperConfig.s.sol`, go to the `getAnvilEthConfig` function and delete the `8` corresponding to the decimals and 2000e8 corresponding to the `_initialAnswer` that are used inside the `MockV3Aggregator`'s constructor.

At the top of the `HelperConfig` contract create two new variables:

```solidity
uint8 public constant DECIMALS = 8;
int256 public constant INITIAL_PRICE = 2000e8;
```

**Note: Constants are always declared in ALL CAPS!**

Now replace the deleted magic numbers with the newly created variables.

```solidity
function getAnvilEthConfig() public returns (NetworkConfig memory) {
    vm.startBroadcast();
    mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
    vm.stopBroadcast();
​
    NetworkConfig memory anvilConfig = NetworkConfig({
        priceFeed: address(mockPriceFeed)
    });
​
    return anvilConfig;
}
```

Awesome! Let's keep refactoring!

# Refactoring the Mock Smart Contract pt.2

## More refactoring

One thing that we should do that would make our `getAnvilEthConfig` more efficient is to check if we already deployed the `mockPriceFeed` before deploying it once more.

Remember how addresses that were declared in state, but weren't attributed a value default to address zero? We can use this to create our check.

Right below the `function getAnvilEthConfig() public returns ...` line add the following:

```solidity
if (activeNetworkConfig.priceFeed != address(0)) {
    return activeNetworkConfig;
}
```

`getAnvilEthConfig` is not necessarily the best name. We are deploying something inside it, which means we are creating a new `mockPriceFeed`. Let's rename the function to `getOrCreateAnvilEthConfig`. Replace the name in the constructor.

Remember how `testPriceFeedVersionIsAccurate` was always failing when we didn't provide the option `--fork-url $SEPOLIA_RPC_URL`? Try running `forge test`. Try running `forge test --fork-url $SEPOLIA_RPC_URL`.

Everything passes! Amazing! Our test just became network agnostic. Next-level stuff!

Take a break, come back in 15 minutes and let's go on!

# Foundry Tests Cheatcodes

Now that we fixed our deployment script, and our tests have become blockchain agnostic, let's get back to increasing that coverage we were talking about some lessons ago.

Reminder: Call forge coverage in your terminal. We need to bring that total coverage percentage as close to 100% as we can! Not all things require 100% coverage, or maybe achieving 100% coverage is too time expensive, but ... 12-13%? That is a joke, we can do way better than that.

Let's take a moment and look at the `fund` function from `FundMe.sol`. What should it do?

   1. `require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD` this means that `fund` should revert if our `msg.value` converted in USDC is lower than the `MINIMUM_USD`;

   2. `addressToAmountFunded[msg.sender] += msg.value;` The `addressToAmountFunded` mapping should be updated appropriately to show the funded value;

   3. The `funders` array should be updated with `msg.sender`;

To test all these we will employ some of Foundry's main features ... it's `Cheatcodes`. As Foundry states in the Foundry Book: "Cheatcodes give you powerful assertions, the ability to alter the state of the EVM, mock data, and more.". Read more about them [here](https://book.getfoundry.sh/cheatcodes/).

To test point 1 we will use one of the most important cheatcodes: `expectRevert` (read more about it [here](https://book.getfoundry.sh/cheatcodes/expect-revert)).

Open `FundMe.t.sol` and add the following function:

```solidity
function testFundFailsWIthoutEnoughETH() public {
    vm.expectRevert(); // <- The next line after this one should revert! If not test fails.
    fundMe.fund();     // <- We send 0 value
}
```

We are attempting to fund the contract with `0` value, it reverts and our test passes.

Before jumping on points 2 and 3, let's refactor our code a little bit.
As we've discussed before storage variables should start with `s_`. Change all the `addressToAmountFunded` mentions to `s_addressToAmountFunded` and all the `funders` to `s_funders`. Another quick refactoring we need to do is to change the visibility of `s_addressToAmountFunded` and `s_funders` to `private`. Private variables are more gas-efficient than public ones.

Call a quick `forge test` to make sure nothing broke anywhere.

Now that we made those two variables private, we need to write some getters for them, i.e. view functions that we will use to query the state of our smart contract.

Please add the following at the end of `FundMe.sol`:

```solidity
/** Getter Functions */
​
function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
    return s_addressToAmountFunded[fundingAddress];
}
​
function getFunder(uint256 index) public view returns (address) {
    return s_funders[index];
}
```

Pfeww! Great now we can test points 2 and 3 indicated above:

Add the following test in `FundMe.t.sol`:

```solidity
function testFundUpdatesFundDataStructure() public {
    fundMe.fund{value: 10 ether}();
    uint256 amountFunded = fundMe.getAddressToAmountFunded(msg.sender);
    assertEq(amountFunded, 10 ether);
}
```

Run `forge test --mt testFundUpdatesFundDataStructure` in your terminal.

Aaaand it fails! Why does it fail? Let's try it again, but this time put `address(this)` instead of `msg.sender`. Now it passed, but we still don't quite get why.

User management is a very important aspect you need to take care of when writing tests. Imagine you are writing a more complex contract, where you have different user roles, maybe the `owner` has some privileges, different from an `admin` who has different privileges from a `minter`, who, as you've guessed, has different privileges from the `end user`. How can we differentiate all of them in our testing? We need to make sure we can write tests about who can do what.

As always, Foundry can help us with that. Please remember the cheatcodes below, you are going to use them thousands of times.

   1. [prank](https://book.getfoundry.sh/cheatcodes/prank)
    "Sets `msg.sender` to the specified address for the next call. “The next call” includes static calls as well, but not calls to the cheat code address."

   2. [startPrank](https://book.getfoundry.sh/cheatcodes/start-prank) and [stopPrank](https://book.getfoundry.sh/cheatcodes/stop-prank)
    `startPrank` Sets `msg.sender` for all subsequent calls until `stopPrank` is called. It works a bit like `vm.startBroadcast` and `vm.stopBroadcast` we used to write our deployment script. Everything between the `vm.startPrank` and `vm.stopPrank` is signed by the address you provide inside the ().

Ok, cool, but who is the actual user that we are going to use in one of the cheatcodes above? We have another cheatcode for this. To create a new user address we can use the `makeAddr` cheatcode. Read more about it [here](https://book.getfoundry.sh/reference/forge-std/make-addr?highlight=mak#makeaddr).

Add the following line at the start of your `FundMeTest` contract:

```solidity
address alice = makeAddr("alice");
```

Now whenever we need a user to call a function we can use `prank` and `alice` to run our tests.

To further increase the readability of our contract, let's avoid using a magic number for the funded amount. Create a constant variable called `SEND_VALUE` and give it the value of `0.1 ether` (don't be scared by the floating number which technically doesn't work with Solidity - `0.1 ether` means `10 ** 17 ether`).

Back to our test, add the following test in `FundMe.t.sol`:

```solidity
function testFundUpdatesFundDataStructure() public {
    vm.prank(alice);
    fundMe.fund{value: SEND_VALUE}();
    uint256 amountFunded = fundMe.getAddressToAmountFunded(alice);
    assertEq(amountFunded, SEND_VALUE);
}
```

Finally, now let's run `forge test --mt testFundUpdatesFundDataStructure` again.

It fails ... again!

But why? Let's call `forge test --mt testFundUpdatesFundDataStructure -vvv` to get more information about where and why it fails.

```solidity
Ran 1 test for test/FundMe.t.sol:FundMeTest
[FAIL. Reason: EvmError: Revert] testFundUpdatesFundDataStructure() (gas: 16879)
Traces:
  [16879] FundMeTest::testFundUpdatesFundDataStructure()
    ├─ [0] VM::prank(alice: [0x328809Bc894f92807417D2dAD6b7C998c1aFdac6])
    │   └─ ← [Return] 
    ├─ [0] FundMe::fund{value: 100000000000000000}()
    │   └─ ← [OutOfFunds] EvmError: OutOfFunds
    └─ ← [Revert] EvmError: Revert
​
Suite result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 696.30µs (25.10µs CPU time)
```

How can someone fund our `FundMe` contract when they have 0 balance? They can't.

We need a way to give alice some ether to be able to use her address for testing purposes.

Foundry to the rescue! There's always a cheatcode to help you overcome your hurdles.

`deal` allows us to set the ETH balance of a user. Read more about it [here](https://book.getfoundry.sh/cheatcodes/deal).

Add the following line at the end of the setup.

```solidity
vm.deal(alice, STARTING_BALANCE);
```

Declare the `STARTING_BALANCE` as a constant variable up top:

```solidity
uint256 constant STARTING_BALANCE = 10 ether;
```

Let's run `forge test --mt testFundUpdatesFundDataStructure` again.

And now it passes. Congratulations!

I know a lot of new cheatcodes were introduced in this lesson. Keep in mind that these are the most important cheatcodes there are, and you are going to use them over and over again. Regardless if you are developing or auditing a project, that project will always have at least an `owner` and a `user`. These two would always have different access to different functionalities. Most of the time the user needs some kind of balance, be it ETH or some other tokens. So, making a new address, giving it some balance, and pranking it to act as a caller for a tx will 100% be part of your every test file.

# Adding More Coverage to the Tests

In the previous lesson, we tested if the `s_addressToAmountFunded` is updated correctly. Continuing from there we need to test that `funders` array is updated with `msg.sender`.

Add the following test to your `FundMe.t.sol`:

```solidity
function testAddsFunderToArrayOfFunders() public {
    vm.startPrank(alice);
    fundMe.fund{value: SEND_VALUE}();
    vm.stopPrank();
​
    address funder = fundMe.getFunder(0);
    assertEq(funder, alice);
}
```

What's happening here? We start with our user `alice` who calls `fundMe.fund` in order to fund the contract. Then we use the `getter` function we created in the previous lesson to query what is registered inside the `funders` array at index `0`. We then use the `assertEq` cheatcode to compare the address we queried against `alice`.

Run the test using `forge test --mt testAddsFunderToArrayOfFunders`. It passed, perfect!

Each of our tests uses a fresh `setUp`, so if we run all of them and `testFundUpdatesFundDataStructure` calls `fund`, that won't be persistent for `testAddsFunderToArrayOfFunders`.

Moving on, we should test the `withdraw` function. Let's check that only the owner can `withdraw`.

Add the following test to your `FundMe.t.sol`:

```solidity
function testOnlyOwnerCanWithdraw() public {
    vm.prank(alice);
    fundMe.fund{value: SEND_VALUE}();
​
    vm.expectRevert();
    vm.prank(alice);
    fundMe.withdraw();
}
```

What's happening here? We start with our user `alice` who calls `fundMe.fund` in order to fund the contract. We then use Alice's address to try and withdraw. Given that Alice is not the owner of the contract, it should fail. That's why we are using the `vm.expectRevert` cheatcode.

**REMEMBER**: Whenever you have a situation where two or more `vm` cheatcodes come one after the other keep in mind that these would ignore one another. In other words, when we call `vm.expectRevert();` that won't apply to `vm.prank(alice);`, it will apply to the `withdraw` call instead. The same would have worked if these had been reversed. Cheatcodes affect transactions, not other cheatcodes.

Run the test using `forge test --mt testOnlyOwnerCanWithdraw`. It passed, amazing!

As you can see, in both `testAddsFunderToArrayOfFunders` and `testOnlyOwnerCanWithdraw` we used `alice` to fund the contract. Copy-pasting the same snippet of code over and over again, if we end up writing hundreds of tests, is not necessarily the best approach. We can see each line of code/block of lines of code as a building block. Multiple tests will share some of these building blocks. We can define these building blocks using modifiers to dramatically increase our efficiency in writing tests.

Add the following modifier to your `FundMe.t.sol`:

```solidity
modifier funded() {
    vm.prank(alice);
    fundMe.fund{value: SEND_VALUE}();
    assert(address(fundMe).balance > 0);
    _;
}
```

We first use the `vm.prank` cheatcode to signal the fact that the next transaction will be called by `alice`. We call `fund` and then we assert that the balance of the `fundMe` contract is higher than 0, if true, it means that Alice's transaction was successful. Every single time we need our contract funded we can use this modifier to do it.

Refactor the previous test as follows:

```solidity
function testOnlyOwnerCanWithdraw() public funded {
    vm.expectRevert();
    fundMe.withdraw();
}
```

Slim and efficient!

Ok, we've tested that a non-owner cannot withdraw. But can the owner withdraw?

To test this we will need a new getter function. Add the following to the `FundMe.sol` file next to the other getter functions:

```solidity
function getOwner() public view returns (address) {
    return i_owner;
}
```

Make sure to make `i_owner` private.

Cool!

Let's discuss more about structuring our tests.

The arrange-act-assert (AAA) methodology is one of the simplest and most universally accepted ways to write tests. As the name suggests, it comprises three parts:

   - **Arrange**: Set up the test by initializing variables, and objects and prepping preconditions.

   - **Act**: Perform the action to be tested like a function invocation.

   - **Assert**: Compare the received output with the expected output.

We will start our test as usual:

```solidity
function testWithdrawFromASingleFunder() public funded {
}
```

Now we are in the first stage of the `AAA` methodology: `Arrange`

We first need to check the initial balance of the owner and the initial balance of the contract.

```solidity
uint256 startingFundMeBalance = address(fundMe).balance;
uint256 startingOwnerBalance = fundMe.getOwner().balance;
```

We have what we need to continue with the `Act` stage.

```solidity
vm.startPrank(fundMe.getOwner());
fundMe.withdraw();
vm.stopPrank();
```

Our action stage is comprised of pranking the owner and then calling `withdraw`.

We have reached our final testing part, the `Assert` stage.

We need to find out the new balances, both for the contract and the owner. We need to check if these match the expected numbers:

```solidity
uint256 endingFundMeBalance = address(fundMe).balance;
uint256 endingOwnerBalance = fundMe.getOwner().balance;
assertEq(endingFundMeBalance, 0);
assertEq(
    startingFundMeBalance + startingOwnerBalance,
    endingOwnerBalance
);
```

The `endingFundMeBalance` should be `0`, because we just withdrew everything from it. The `owner's` balance should be the `startingFundMeBalance + startingOwnerBalance` because we withdrew the `fundMe` starting balance.

Let's run the test using the following command: `forge test --mt testWithdrawFromASingleFunder`

It passed, amazing!

**Remember to call `forge test` from time to time to ensure that any changes to the main contract or to testing modifiers or setup didn't break any existing tests. If it did, go back and see how the changes affected the test and modify them to accustom it.**

Ok, we've tested that the owner can indeed `withdraw` when the `fundMe` contract is funded by a single user. Can they `withdraw` when the contract is funded by multiple users?

Put the following test in your `FundMe.t.sol`:

```solidity
function testWithdrawFromMultipleFunders() public funded {
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;
    for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
        // we get hoax from stdcheats
        // prank + deal
        hoax(address(i), SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();
    }
​
    uint256 startingFundMeBalance = address(fundMe).balance;
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
​
    vm.startPrank(fundMe.getOwner());
    fundMe.withdraw();
    vm.stopPrank();
​
    assert(address(fundMe).balance == 0);
    assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
}
```

That seems like a lot! Let's go through it.

We start by declaring the total number of funders. Then we declare that the `startingFunderIndex` is 1. You see that both these variables are defined as `uint160` and not our usual `uint256`. Down the road, we will use the `startingFunderIndex` as an address. If we look at the definition of an address we see that it holds a `20 byte` value and that explicit conversions to and from address are allowed for `uint160, integer literals, bytes20 and contract types`. Having the index already in `uint160` will save us from casting it when we need to convert it into an address.

We start a `loop`. Inside this loop we need to `deal` and `prank` an address and then call `fundMe.fund`. Foundry has a better way: [hoax](https://book.getfoundry.sh/reference/forge-std/hoax?highlight=hoax#hoax). This works like `deal` + `prank`. It pranks the indicated address while providing some specified ether.

`hoax(address(i), SEND_VALUE);`

As we've talked about above, we use the `uint160` index to obtain an address. We start our index from `1` because it's not advised to user `address(0)` in this way. `address(0)` has a special regime and should not be pranked.

The `SEND_VALUE` specified in hoax represents the ether value that will be provided to `address(i)`.

Good, now that we have pranked an address and it has some balance we call `fundMe.fund`.

After the loop ends we repeat what we did in the `testWithdrawFromASingleFunder`. We record the contract and owner's starting balances. This concludes our `Arrange` stage.

The next logical step is pranking the `owner` and withdrawing. This starts the `Act` stage.

In the `Assert` part of our test, we compare the final situation against what we expected.

```solidity
assert(address(fundMe).balance == 0);
```

After withdrawal, `fundMe`'s balance should be 0.

```solidity
assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
```

The `owner`'s balance should be equal to the sum of `startingOwnerBalance` and the amount the owner withdrew (which is the startingFundMeBalance).

```solidity
assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
```

We compare the product between the total number of funders and `SEND_VALUE` to the total shift in the `owner`'s balance.
We added `1` to the `numberOfFunders` because we used the `funded` modifier which also adds `alice` as one of the funders.

Run the test using `forge test --mt testWithdrawFromMultipleFunders`. Run all tests using `forge test`.

Let's run `forge coverage` and see if our coverage table got better.

Congratulations, everything works way better!

# Introduction to Foundry Chisel

`Chisel` is one of the 4 components of Foundry alongside `forge`, `cast` and `anvil`. It's a tool that allows users to quickly test the behavior of Solidity code on a local (anvil) or forked network.

Usually, when you want to test a small Solidity code snippet you go to Remix. But why do that when you have what you need right in the terminal of your Foundry project.

Type `chisel` in your terminal and press Enter.

This opens up a shell that awaits your next command. Call `!help` to find out more about what commands are available.

Basically, you can simply write solidity in the shell then play around and see how it behaves.

For example:

   1. Type `uint256 cat = 1;`

   2. Type `cat;`

```solidity
➜ cat
Type: uint256
├ Hex: 0x0000000000000000000000000000000000000000000000000000000000000001
├ Hex (full word): 0x0000000000000000000000000000000000000000000000000000000000000001
└ Decimal: 1
➜ 
```

   3. Type `uint256 dog = 2;`

   4. Type `cat + dog`

```solidity
Type: uint256
├ Hex: 0x0000000000000000000000000000000000000000000000000000000000000003
├ Hex (full word): 0x0000000000000000000000000000000000000000000000000000000000000003
└ Decimal: 3
➜ 
```
   
  5. Type `uint256 frog = 10;`

  6. Type `require(frog > cat);` - If nothing happens it means it passed, now try it the other way

  7. Type `require(cat > frog);`

```solidity
➜ require(frog > cat);
➜ require(cat > frog);
Traces:
  [197] 0xBd770416a3345F91E4B34576cb804a576fa48EB1::run()
    └─ ← [Revert] EvmError: Revert
​
⚒️ Chisel Error: Failed to execute REPL contract!
➜ 
```

It reverts!

Press `Ctrl + C` twice to exit and return to your normal terminal.

To find more about other Chisel functionality, please click [here](https://book.getfoundry.sh/reference/chisel/).
