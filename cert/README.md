# Cert


## install acme.sh

```bash
curl https://get.acme.sh | sh
```


### ssl/tls

```bash
domain=abc.finance

# gd apikey
export GD_Key=dLYxCFMdp4WU_HupLvPgbQ7B3WFnJFJtLTS
export GD_Secret=8CQFE9moXXXX

acme.sh  --issue --dns dns_gd -d $domain --nginx
#acme.sh  --issue --dns dns_gd -d $domain -d *.$domain --nginx
```
