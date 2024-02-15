import { ethers } from "hardhat";

async function main() {
  const owner = "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4";
  const name = "DRGP Token";
  const symbol = "DGT";
  const decimals = 18;
  const initialSupply = 1000;

  const erc20 = await ethers.deployContract("ERC20", [owner, name, symbol, decimals, initialSupply]);

  await erc20.waitForDeployment();

  console.log(
    `Successfuly deployed to ${erc20.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
