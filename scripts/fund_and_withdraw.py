from re import A
from brownie import FundMe
from scripts.helpful_scripts import get_account

def fund():
    fund_me = FundMe[-1]
    account = get_account()
    # print("Output from get_price",fund_me.getPrice())
    entrance_fee = fund_me.getEntranceFee()
    print("Entrance Fee is ------->>",entrance_fee)
    print("Funding contract...")
    fund_me.fund({"from":account,"value":entrance_fee})

def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    print("Withdrawing - ")
    fund_me.withdraw({"from":account})
    print("All fundings withdrawn")

def main():
    fund()
    withdraw()