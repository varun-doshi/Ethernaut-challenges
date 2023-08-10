const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Naught Coin", function () {
  async function deployFixture() {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const myContract = await ethers.getContractFactory("NaughtCoin");
    const naughtCoin = await myContract.deploy(owner);

    return { naughtCoin, owner, addr1, addr2 };
  }

  it("Assigns total supply to the owner", async function () {
    const { naughtCoin, owner } = await loadFixture(deployFixture);
    const totalSupply = await naughtCoin.INITIAL_SUPPLY();

    expect(Number(await naughtCoin.balanceOf(owner.address))).to.equal(
      Number(totalSupply)
    );
  });

  it("should set right owner", async function () {
    const { naughtCoin, owner } = await loadFixture(deployFixture);
    const contractOwner = await naughtCoin.player();

    expect(contractOwner).to.equal(owner.address);
  });

  it("should not allow to transfer", async function () {
    const { naughtCoin, owner, addr1 } = await loadFixture(deployFixture);

    expect(naughtCoin.connect(owner).transfer(addr1, 10)).to.be.reverted;
  });

  it("approve and transferFrom flow", async function () {
    const { naughtCoin, owner, addre1 } = await loadFixture(deployFixture);
    const attacker = await ethers.getContractFactory("NaughtCoinAttack");
    const attackContract = await attacker.connect(owner).deploy();

    await naughtCoin
      .connect(owner)
      .approve(attackContract.target, await naughtCoin.balanceOf(owner));
    const allowed = await naughtCoin.allowance(owner, attackContract.target);
    console.log(allowed);

    await attackContract.attack(naughtCoin);

    expect(Number(await naughtCoin.balanceOf(owner.address))).to.equal(0);
  });
});
