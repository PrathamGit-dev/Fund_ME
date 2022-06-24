from traceback import format_exception_only
from brownie import FundMe, MockV3Aggregator, network, config
from scripts.helpful_scripts import get_account, deploy_mocks, LOCAL_BLOCKCHAIN_ENVIRONMENTS
import os


if(network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS):
    eth_usd_price_address = config["networks"][network.show_active()]["eth_usd_price_address"]
    print("eth usd price interface address is ", eth_usd_price_address)

else:
    deploy_mocks()
    eth_usd_price_address = MockV3Aggregator[-1].address


def deploy_fund_me():
    account=get_account()
    fund_me= FundMe.deploy(eth_usd_price_address,{"from": account}, publish_source=config["networks"][network.show_active()].get("verify"))
    print("Contract deployed at", fund_me.address)
    return fund_me

def main():
    deploy_fund_me()