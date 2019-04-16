# 微信


### 获取用户个人信息（UnionID机制）


http请求方式: GET
https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENI




## 微信APP支付

商户服务器生成支付订单，先调用【统一下单API】生成预付单，获取到prepay_id后将参数再次签名传输给APP发起支付。以下是调起微信支付的关键代码。

### 统一下单

URL地址：https://api.mch.weixin.qq.com/pay/unifiedorder

https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1
