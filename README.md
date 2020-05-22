# About luxe-registrar contract

Here is the updated version of the LUXE domain registrar contract.

## Target

1. Maintain the original basic framework and authorization mechanism of LUXE domain system, and complete the support for multiple chains of LUXE domain in ENS system.
2. After the contract is deployed, the migration of LUXE top-level domain to the new ENS registry can be completed.

## Major Upgrade

1. The registrar has been upgraded to integrate a new resolver which is a implementation of the latest ENS resolver interface. And the default resolver is alterable.
2. The default resolver has been upgraded, and now the resolver has implemented the latest ENS resolver interface, which supports multi-chain address, content hash, text and other records.
3. Add "migrate" and "migrateAll" functions in the registrar. So the "owner" can migrate single or batch domain names after the contract deployed.

This version uses a alterable default resolver. It create a new resolver when the registrar contract is deployed and use them as the default resolver for users registering the LUXE domain. The default resolver is deployed separately in another contract and set in the registrar, and the default resolver can be modified by the "owner" role of the registrar. Therefore, if you are faced with the need to change the functionality of the default resolver in the future, you can not deploy the entire LUXE registrar contract, just deploy the resolver contract separately and change the default resolver used by the registrar to a new address.

## Other

1. To migrate the LUXE top-level domain to the new ENS registry, the latest address of the ENS registry, i.e. `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e`, must be used at the deployment of this contract.
2. The param _oldENS in the constructor should be `0x314159265dd8dbb310642f98f50c066173c1259b`.
3. The param _baseNode in the constructor should be the node of the domain name.
4. The compiler version I used is 0.5.16+commit.9c3226ce
