from brownie import accounts, network, config, MockV3Aggregator
from web3 import Web3

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["ganache-local" , "development"]
FORKED_LOCAL_BLOCKCHAIN = ["mainnet-fork-dev", "mainnet-fork"]

def get_account():
    if(network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS or network.show_active() in FORKED_LOCAL_BLOCKCHAIN):
        return accounts[0]

    else:
        return accounts.add(config["wallets"]["from_key"])

 

# these variables needed in constructor while deploying mocks
DECIMALS = 8
STARTING_PRICE = 200000000000

# this function returns the address for eth usd price by deploying mocks
def deploy_mocks():
    print("Deploying mocks")
    if(len(MockV3Aggregator)<=0):
        MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {"from": get_account()})
    #this MockV3Aggregator is available in the deploy.py after being called from there
    print("Mocks deployed")
