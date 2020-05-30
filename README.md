# About the updated registrar contract

Here is the updated version of the LUXE domain registrar contract.

## Target

1. Maintain the original basic framework and authorization mechanism of LUXE domain system, and complete the support for multiple chains of LUXE domain in ENS system.
2. After the contract is deployed, the migration of LUXE top-level domain to the new ENS registry can be completed.

## Other

1. To migrate the LUXE top-level domain to the new ENS registry, the latest address of the ENS registry, i.e. `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e`, must be used at the deployment of this contract.
2. The param _resolver in the constrctor can be the PublicResolver.
3. The param _oldENS in the constructor should be `0x314159265dd8dbb310642f98f50c066173c1259b`.
4. The param _baseNode in the constructor should be the node of the domain name.
5. The compiler version I used is 0.5.16+commit.9c3226ce
