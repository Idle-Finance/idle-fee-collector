import { ethers, upgrades } from "hardhat";
import { FeeCollector } from "../typechain/FeeCollector"

describe("FeeCollector", function () {
  let feeCollector: FeeCollector;

  beforeEach(async function () {
    const feeCollectorFactory = await ethers.getContractFactory("FeeCollector");
    feeCollector = await upgrades.deployProxy(feeCollectorFactory, ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"]) as FeeCollector;

    await feeCollector.deployed();
  });

  it("should do something right", async function () {
    console.log(await feeCollector.distributionToken())
  });
});
