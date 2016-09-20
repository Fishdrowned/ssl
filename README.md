# 自签泛域名证书
此工具用于颁发泛域名证书，方便开发环境调试。

请勿用于生产环境，生产环境还是购买正式的证书。  
或者到 [Let's Encrypt](https://letsencrypt.org/) 可以申请到免费证书  
（没有泛域名，但是可以指定多域名）。

## 系统要求
Linux，openssl

## 使用
### 1. 用 gen.root.sh 生成根证书
根证书只需要生成一次，如果已经运行过，则跳过这一步。

```bash
./gen.root.sh
```
生成的根证书私钥位于：  
`ssl/out/root.key.pem`
生成的根证书位于：  
`ssl/out/root.cert.pem`

成功之后，把根证书导入到操作系统里面，信任这个证书。

### 2. 然后用 gen.cert.sh 生成网站证书
```bash
./gen.cert.sh <domain>
```
把 `<domain>` 替换成你的域名，例如 `example.dev`

生成的证书位于：
```text
ssl/out/<domain>-<date>-<time>/<domain>.cert.pem
ssl/out/<domain>-<date>-<time>/<domain>.bundle.cert.pem
```

私钥就是第一步生成的那个根证书私钥，即：  
`ssl/out/root.key.pem`

其中 `bundle.cert.pem` 是已经拼接好的证书，可以添加到 `nginx` 配置里面。  
然后你就可以愉快地用 `https` 来访问你本地的开发网站了。

## 清空
你可以运行 `flush.sh` 来清空所有历史，包括根证书和网站证书。

## 配置
你可以修改 `ca.cnf`

## 参考
[Vault and self signed SSL certificates](http://dunne.io/vault-and-self-signed-ssl-certificates)

[利用OpenSSL创建自签名的SSL证书备忘](http://wangye.org/blog/archives/732/)

[Provide subjectAltName to openssl directly on command line](http://security.stackexchange.com/questions/74345/provide-subjectaltname-to-openssl-directly-on-command-line)
