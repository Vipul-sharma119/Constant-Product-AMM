# Constant Product AMM – in Solidity

This project is a simple version of how **Uniswap** works. It's a smart contract written in **Solidity** that lets you:

- Swap between two tokens  
- Add your tokens to a shared pool  
- Remove your tokens from the pool  

It uses the famous **x * y = k** formula to keep the trading fair and automatic.

---

## 📌 What is an AMM?

An **Automated Market Maker (AMM)** is a way to trade tokens on the blockchain **without using an order book** (like centralized exchanges do). Instead, prices are set using a math formula.

This contract uses a **Constant Product Formula**, which means:

tokenA_balance * tokenB_balance = constant (k)

When you trade, this balance changes, but the product stays the same.

---

## ✨ What Can This Contract Do?

### 1. Swap Tokens
- You can send in one token (e.g., tokenA) and get another back (e.g., tokenB).
- The more you trade at once, the worse the rate gets — this is called **slippage**.
- A **0.3% fee** is taken on each swap (like Uniswap).

### 2. Add Liquidity
- You provide both tokens (tokenA and tokenB) in a **balanced ratio**.
- In return, you get **LP shares** that represent your part of the pool.

### 3. Remove Liquidity
- You can give back your LP shares and withdraw your part of the pool.

---

## 🧠 How It Works (In Simple Terms)

- The pool starts empty.
- The first person to add liquidity sets the starting price.
- When someone swaps, the reserves change, but the formula `x * y = k` still holds.
- Liquidity Providers (LPs) earn fees when people trade.

---

## 🚀 How To Use It

1. **Deploy** two ERC-20 tokens (or use test tokens on testnet).
2. **Deploy this AMM contract**, passing in the token addresses.
3. **Approve** the AMM contract to use your tokens using `approve(...)`.
4. Call `add_liquidity(...)` to provide tokens to the pool.
5. Call `swap(...)` to trade one token for another.
6. Call `remove_liquidity(...)` to get your tokens back.

---

## 🧪 Function Breakdown

### `add_liquidity(uint _amtA, uint _amtB)`
Add both tokens to the pool. You’ll get LP shares in return.

### `remove_liquidity(uint _shares)`
Burn your LP shares and get your tokens back in proportion to your share.

### `swap(address _token, uint _amt)`
Swap one token for another. The formula will automatically calculate how much you get.

---

## 🛠️ Behind the Scenes

Here are a few helper functions used internally:

- `_mint()` – Gives you LP shares.
- `_burn()` – Removes your LP shares.
- `_update()` – Updates token reserves after any action.
- `_sqrt()` – Calculates square root when the first liquidity is added.
- `_min()` – Returns the smaller of two values.

---

## ⚠️ Warning – This is a Simple Demo

This project is meant for **learning and testing only**. It doesn’t have the safety features real DeFi apps have.

- No protection against reentrancy attacks  
- No flash loan resistance  
- Doesn't use `SafeERC20` from OpenZeppelin (which is safer)

**Do not use this with real money.**

---

## 📚 Requirements

- Solidity ^0.8.24  
- Two ERC-20 token contracts (tokenA and tokenB)  
- Some basic understanding of smart contracts  

---

## 📝 License

This project is open source under the **MIT License**. You’re free to use, modify, and share it.

---

## 🙌 Want to Learn More?

- [Uniswap Docs](https://docs.uniswap.org/)  
- [Solidity Docs](https://docs.soliditylang.org/)  
- [Etherscan - How to interact with contracts](https://docs.etherscan.io/)  

---

Built for fun and learning. Let’s keep building the future of DeFi!
