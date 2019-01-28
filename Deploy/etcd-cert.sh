cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "www": {
         "expiry": "87600h",
         "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ]
      }
    }
  }
}
EOF

cat > ca-csr.json <<EOF
{
    "CN": "etcd CA",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "HangZhou",
            "ST": "BinJiang"
        }
    ]
}
EOF

#初始化ca
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -

#-----------------------

#创建ca签名请求
cat > server-csr.json <<EOF
{
    "CN": "etcd",
    "hosts": [
    "192.168.1.115",
    "192.168.1.116",
    "192.168.1.118"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "HangZhou",
            "ST": "BinJiang"
        }
    ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www server-csr.json | cfssljson -bare server

