import '@openzeppelin/hardhat-upgrades';
import "@nomiclabs/hardhat-ethers";


import { HardhatUserConfig } from "hardhat/config";

const config : HardhatUserConfig = {
  networks: {
    hardhat: {
    }
  },
  solidity: "0.8.4"
};

export default config;