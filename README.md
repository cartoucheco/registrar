# About luxe-registrar contract

Here is the updated version of the LUXE domain registrar contract.

## Target

1. Maintain the original basic framework and authorization mechanism of LUXE domain system, and complete the support for multiple chains of LUXE domain in ENS system.
2. After the contract is deployed, the migration of LUXE top-level domain to the new ENS registry can be completed.

## Major Upgrade

1. The registrar has been upgraded to integrate a new resolver which is a implementation of the latest ENS resolver interface. And in the alterable-resolver version described later, the default resolver is alterable.
2. The default resolver has been upgraded, and now the resolver has implemented the latest ENS resolver interface, which supports multi-chain address, content hash, text and other records.

## The difference between the two versions

Considering that LUXE is integrated into ENS system in a custom way, I wonder if there is any new functional requirements of the resolver in the future. Therefore, I have written two versions of the LUXE registry contract, please choose to use according to the situation. The two versions are located in the constant-resolver and alterable-resolver branches.

### constant-resolver version

This version USES a fixed default resolver. It create a new resolver when the registrar contract is deployed and use them as the default resolver for users registering the LUXE domain. This resolver will remain the default resolver for users registering the LUXE domain unless the entire LUXE registrar contract is redeployed.

### alterable-resolver version

This version USES a alterable default resolver. It create a new resolver when the registrar contract is deployed and use them as the default resolver for users registering the LUXE domain. Unlike the constant-resolver version, the default resolver is deployed separately in another contract and set in the registrar, and the default resolver can be modified by the "owner" role of the registrar. Therefore, if you are faced with the need to change the functionality of the default resolver in the future, you can not deploy the entire LUXE registrar contract, just deploy the resolver contract separately and change the default resolver used by the registrar to a new address.

## Other

1. To migrate the LUXE top-level domain to the new ENS registry, the latest address of the ENS registry, i.e. `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e`, must be used at the deployment of this contract.
2. The compiler version I used is 0.5.16+commit.9c3226ce
