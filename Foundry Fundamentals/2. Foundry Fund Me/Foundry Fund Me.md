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
