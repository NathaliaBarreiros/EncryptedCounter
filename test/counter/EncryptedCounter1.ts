import { ethers } from "hardhat";

import { createInstance } from "../instance";
import { getSigners, initSigners } from "../signers";

describe("EncryptedCounter1", function () {
  // Setup hooks

  //before: Initializes test signers (users) that will interact with the contract
  before(async function () {
    await initSigners(); //Initialize signers
    this.signers = await getSigners();
  });

  //beforeEach: Deploys a fresh instance of the contract before each test

  //Creates FHE instances for each signer to handle encryption/decryption

  beforeEach(async function () {
    const CounterFactory = await ethers.getContractFactory("EncryptedCounter1");
    this.counterContract = await CounterFactory.connect(this.signers.alice).deploy();
    this.contractAddress = await this.counterContract.getAddress();
    this.instaces = await createInstance();
  });

  // Individual test cases
  it("should increment the counter", async function () {
    // Perform the increment action
    const tx = await this.counterContract.increment();
    await tx.wait();
  });
});
