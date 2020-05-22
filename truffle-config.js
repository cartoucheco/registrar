var HDWalletProvider = require("truffle-hdwallet-provider");  // 导入模块
var mnemonic = "bicycle throw junk unveil range material hole ribbon clarify lucky plate cruise";

module.exports = {
  // Uncommenting the defaults below 
  // provides for an easier quick-start with Ganache.
  // You can also follow this format for other networks;
  // see <http://truffleframework.com/docs/advanced/configuration>
  // for more details on how to specify configuration options!
  //
networks: {
  //  development: {
  //    host: "127.0.0.1",
  //    port: 7545,
  //    network_id: "*"
  //  },
  //  test: {
  //    host: "127.0.0.1",
  //    port: 7545,
  //    network_id: "*"
  //  },

  //主网
  advanced: {
    provider: () => new HDWalletProvider(mnemonic, `https://mainnet.infura.io`),
    network_id: 1,       // Custom network
    gas: 8500000,           // Gas sent with each transaction (default: ~6700000)
    gasPrice: 20000000000,  // 20 gwei (in wei) (default: 100 gwei)
    from: 000000000000000000000000000000000000,        // Account to send txs from (default: accounts[0])
    websockets: true        // Enable EventEmitter interface for web3 (default: false)
  },

  // ropsten测试网络，mnemonic为账户的助记词或者私钥
  ropsten: {
    provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/b7be6502c24c40c3aa2782eb5bac2de3`),
    network_id: 3,       // Ropsten's id
    gas: 5500000,        // Ropsten has a lower block limit than mainnet
    confirmations: 2,    // # of confs to wait between deployments. (default: 0)
    timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    skipDryRun: true,     // Skip dry run before migrations? (default: false for public nets )
    networkCheckTimeout: 15000
  }
}
  //
};