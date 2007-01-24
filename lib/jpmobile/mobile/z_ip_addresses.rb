# = IPアドレス帯域テーブル
# == DoCoMo
# http://www.nttdocomo.co.jp/service/imode/make/content/ip/about/
# 2006/09現在
# == au
# http://www.au.kddi.com/ezfactory/tec/spec/ezsava_ip.html
# 2006/08/14現在
# == SoftBank
# http://developers.softbankmobile.co.jp/dp/tech_svc/web/ip.php
# 2006/11/17現在
# == Willcom
# http://www.willcom-inc.com/ja/service/contents_service/club_air_edge/for_phone/ip/index.html
# 2006/08/17現在

#:enddoc:
Jpmobile::Mobile::Docomo::IP_ADDRESSES = <<EOF
210.153.84.0/24
210.136.161.0/24
210.153.86.0/24
EOF

Jpmobile::Mobile::Au::IP_ADDRESSES=<<EOF
210.169.40.0/24
210.196.3.192/26
210.196.5.192/26
210.230.128.0/24
210.230.141.192/26
210.234.105.32/29
210.234.108.64/26
210.251.1.192/26
210.251.2.0/27
211.5.1.0/24
211.5.2.128/25
211.5.7.0/24
218.222.1.0/24
61.117.0.0/24
61.117.1.0/24
61.117.2.0/26
61.202.3.0/24
219.108.158.0/26
219.125.148.0/24
222.5.63.0/24
222.7.56.0/24
222.5.62.128/25
222.7.57.0/24
59.135.38.128/25
EOF

Jpmobile::Mobile::Softbank::IP_ADDRESSES=<<EOF
202.179.204.0/24
202.253.96.248/29
210.146.7.192/26
210.146.60.192/26
210.151.9.128/26
210.169.130.112/29
210.169.130.120/29
210.169.176.0/24
210.175.1.128/25
210.228.189.0/24
211.8.159.128/25
EOF

Jpmobile::Mobile::Willcom::IP_ADDRESSES=<<EOF
61.198.142.0/24
219.108.14.0/24
61.198.161.0/24
219.108.0.0/24
61.198.249.0/24
219.108.1.0/24
61.198.250.0/24
219.108.2.0/24
61.198.253.0/24
219.108.3.0/24
61.198.254.0/24
219.108.4.0/24
61.198.255.0/24
219.108.5.0/24
61.204.3.0/25
219.108.6.0/24
61.204.4.0/24
221.119.0.0/24
61.204.6.0/25
221.119.1.0/24
125.28.4.0/24
221.119.2.0/24
125.28.5.0/24
221.119.3.0/24
125.28.6.0/24
221.119.4.0/24
125.28.7.0/24
221.119.5.0/24
125.28.8.0/24
221.119.6.0/24
211.18.235.0/24
221.119.7.0/24
211.18.238.0/24
221.119.8.0/24
211.18.239.0/24
221.119.9.0/24
125.28.11.0/24
125.28.13.0/24
125.28.12.0/24
125.28.14.0/24
125.28.2.0/24
125.28.3.0/24
211.18.232.0/24
211.18.233.0/24
211.18.236.0/24
211.18.237.0/24
125.28.0.0/24
125.28.1.0/24
61.204.0.0/24
210.168.246.0/24
210.168.247.0/24
219.108.7.0/24
61.204.2.0/24
61.204.5.0/24
61.198.129.0/24
61.198.140.0/24
61.198.141.0/24
125.28.15.0/24
61.198.165.0/24
61.198.166.0/24
61.198.168.0/24
61.198.169.0/24
61.198.170.0/24
61.198.248.0/24
125.28.16.0/24
125.28.17.0/24
211.18.234.0/24
219.108.8.0/24
219.108.9.0/24
219.108.10.0/24
EOF
