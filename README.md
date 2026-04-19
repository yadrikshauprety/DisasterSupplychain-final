# DisasterChain: Web3 Relief Supply Chain

DisasterChain is a decentralized application (dApp) built to bring complete transparency to disaster relief efforts. It uses blockchain technology to track donations, shipments, and package deliveries in real-time on an immutable public ledger.

## 🛠️ Tech Stack

- **Smart Contracts:** Solidity
- **Blockchain Network:** Hardhat Local Node (Ethereum)
- **Frontend Framework:** React 18 (via unpkg)
- **Web3 Integration:** Ethers.js (v6)
- **Styling:** Vanilla CSS (Glassmorphism & Modern UI)
- **Wallet Connection:** MetaMask

## ⚙️ How It Works

DisasterChain features a role-based supply chain system with 4 distinct user types:

1. **Donors:** Can send ETH directly to the smart contract, specifying a disaster type (e.g., "Flood Relief"). Their donations are permanently recorded on the Global Donations Ledger.
2. **NGOs:** Can view total pooled funds and create "Shipments". Each shipment is recorded on-chain with details like destination area, priority, and the assigned logistics agent.
3. **Logistics Agents:** Are responsible for scanning packages in transit. Every scan updates the shipment's location on the blockchain in real-time.
4. **Recipients:** End users whose cryptographic wallet addresses are verified (KYC registry). They can track their shipments and cryptographically "Claim" their aid once it arrives, finalizing the shipment lifecycle.

### The Smart Contract
The core logic is handled by `DisasterChain.sol`, which maintains:
- `donations`: An array of all financial contributions.
- `shipments`: A mapping of tracking IDs to shipment structures, complete with a state-machine (Pending → In Transit → Claimed).
- `scans`: A real-time audit log of where a package has been.

Everything is completely transparent and viewable in the **Raw Blockchain Explorer** panel on the frontend, which fetches block headers directly from the local Ethereum node.

---

## 🚀 Quick Start Guide

To run the project from scratch, you will need to open **two terminal windows**.

### 1. Start the Blockchain Network
In your first terminal, start the local Hardhat Ethereum node. This acts as your local blockchain.
```bash
npm run start:node
```
*(Leave this terminal running in the background)*

### 2. Start the Web Server
Open a **second terminal** in this folder and run:
```bash
npm run start:web
```
This will serve the frontend at `http://localhost:3000/disasterchain-hardhat-FINAL%20(2).html`. *(Leave this terminal running as well)*

---

## 🔗 Smart Contract Deployment

> **Note:** The smart contract is currently deployed and the address is hardcoded into your HTML file. You only need to run this step if you restart `npm run start:node` (which wipes the local blockchain memory) or if you modify the `.sol` contract.

If you need to redeploy the contract to the local node, open a third terminal and run:
```bash
npm run deploy:local
```
This will output a new contract address (e.g., `0x5FbDB...`). You must copy this address, open `disasterchain-hardhat-FINAL (2).html`, and paste it near the top of the file:
```javascript
const CONTRACT_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
```

---

## 🦊 Testing with MetaMask

To interact with the local blockchain, you need to configure your MetaMask wallet.

### 1. Add the Local Network
When you click a login button, the app will try to auto-add the network. If it fails, add it manually:
- **Network Name:** Hardhat Local
- **RPC URL:** `http://127.0.0.1:8545`
- **Chain ID:** `31337`
- **Currency:** `ETH`

### 2. Import a Test Account
The local Hardhat node provides 20 fake accounts loaded with 10,000 test ETH. Import one into MetaMask:
1. Open MetaMask > Click the Account Dropdown (top center).
2. Click **Add account or hardware wallet** > **Import account**.
3. Paste one of the Hardhat private keys, for example:
   ```text
   0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
   ```
4. You will instantly receive 10,000 ETH on the Hardhat Local network. You can now use the app!

> **WARNING:** Never use these test private keys on a live network (like Mainnet). They are publicly known and any real funds sent to them will be lost.
