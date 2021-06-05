const { ethers, upgrades } = require("hardhat");

async function main() {
  const FeeCollector = await ethers.getContractFactory("FeeCollector");

  const feeCollector = await upgrades.deployProxy(FeeCollector, ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"]);
  await feeCollector.deployed();
  console.log("FeeCollector deployed to:", feeCollector.address);
}

main();