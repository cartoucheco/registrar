# About the updated registrar contract

Updated Registrar for Cartouche-managed ENS TLDs.

## Attentions

1. The param _ens in the constructor should be `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e`.
2. The param _resolver in the constructor can be the PublicResolver.
3. The param _oldENS in the constructor should be `0x314159265dd8dbb310642f98f50c066173c1259b`.
4. The param _baseNode in the constructor should be the node of the domain name.
5. The compiler version I used is 0.5.16+commit.9c3226ce
