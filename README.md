# What is Ironfish_tools?
Ironfish_tools is a Perl script that automation the Phase 2 incentivized testnet of Iron Fish Network.

It automatically runs `ironfish deposit` command. See iron-fish/ironfish-api/pull/790 for details.

It is designed to be simple enough to run via a cron job.  
```
# m h  dom mon dow   command
35 * * * * ~/ironfish_tools/deposit_ironfish.shcooper@kr01h:~/ironfish_tools$
```

## REQUIREMENTS:
This script was written and tested exclusively under Ubuntu Linux 20.04.5 LTS. 

What you'll need are the following:
- Perl 5.6 or better, usually installed with common Linux distributions.

