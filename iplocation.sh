#! /bin/bash

iplocation_com() {
	json=`curl --silent 'https://iplocation.com/' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'X-Requested-With: XMLHttpRequest' -H 'Origin: https://iplocation.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://iplocation.com/' --data "ip=$1"`
	isp=`echo $json | jq -r ".isp"`
	city=`echo $json | jq -r ".city"`
	region=`echo $json | jq -r ".region_name"`
	country=`echo $json | jq -r ".country_name"`

	echo "1. $city / $region / $country / $isp (www.iplocation.com)"
}

db_ip() {
	ip=$1
	json=`curl --silent http://api.db-ip.com/v2/free/$ip`
	city=`echo $json | jq -r ".city"`
	region=`echo $json | jq -r ".stateProv"`
	country=`echo $json | jq -r ".countryName"`
	echo "2. $city / $region / $country (www.db-ip.com)"
}

what_is_my_ip_com() {
	ip=$1
	html=`curl --silent "https://whatismyipaddress.com/ip/$ip" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed`
	basePath="/html/body/div/div/div/div[2]/div[2]/div[2]/div[2]/table/tbody"
        city=`echo $html | xmllint --html --xpath '//div[@id="section_left_3rd"]/table/tr[4]/td/text()' - 2> /dev/null`
        region=`echo $html | xmllint --html --xpath '//div[@id="section_left_3rd"]/table/tr[4]/td/text()' - 2> /dev/null`
        country=`echo $html | xmllint --html --xpath '//div[@id="section_left_3rd"]/table/tr[2]/td/text()' - 2> /dev/null`
        echo "3. $city / $region / $country (www.whatismyipaddress.com)"

}

if [ -z $1 ]; then
  ip=`curl --silent ifconfig.me` ;else
  ip=$1
fi

echo "# Checking public ip location of $ip"
iplocation_com $ip
db_ip $ip
what_is_my_ip_com $ip
