import '@typechain/hardhat'
import '@nomiclabs/hardhat-ethers'
import '@nomiclabs/hardhat-waffle'
import '@openzeppelin/hardhat-upgrades';

import { HardhatUserConfig } from "hardhat/config";

const config : HardhatUserConfig = {
  networks: {
    hardhat: {
    }
  },
  solidity: "0.8.4"
};

export default config;