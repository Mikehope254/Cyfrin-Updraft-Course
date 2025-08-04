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
