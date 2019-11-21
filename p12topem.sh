#!/bin/bash
P12_CERT=证书.p12 # p12证书文件
PASSWD=18838234 # p12密码
IPANAME=tg.ipa  # IPA
PROVISION=0.mobileprovision

DATE=`date +%F | sed 's/-//g'``date +%T | sed 's/://g'`
EXPORT_CERT=cert.pem # 导出pem证书
EXPORT_KEY=key.pem  # 导出的pem私钥,有密码
EXPORT_KEY_UNENCRY=key.unencrypted.pem # 导出的pem私钥，无密码
EXPORT_KEY_AND_CERT=ck.pem # 含有证书和私钥的pem

if [ ! -f ${EXPORT_CERT} ]; then
    openssl pkcs12 -clcerts -nokeys -out ${EXPORT_CERT} -in ${P12_CERT} -passin pass:${PASSWD} # 导出证书
fi

if [ ! -f ${EXPORT_KEY} ]; then
    openssl pkcs12 -nocerts -passout pass:${PASSWD} -out ${EXPORT_KEY} -in ${P12_CERT} -passin pass:${PASSWD} #导出私钥,有密码
fi

if [ ! -f ${EXPORT_KEY_UNENCRY} ]; then
    openssl rsa -in ${EXPORT_KEY} -passin pass:${PASSWD} -out ${EXPORT_KEY_UNENCRY} # 导出私钥，无密码
fi

if [ ! -f ${EXPORT_KEY_AND_CERT} ]; then
    cat ${EXPORT_CERT} ${EXPORT_KEY_UNENCRY} > ${EXPORT_KEY_AND_CERT}   # 证书和私钥合起来
fi


isign -c ${EXPORT_CERT} -k ${EXPORT_KEY_UNENCRY} -p ${PROVISION} -o ./resign_${DATE}_${IPANAME} ${IPANAME}