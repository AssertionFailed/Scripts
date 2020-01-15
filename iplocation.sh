#! /bin/bash

iplocation_com() {
	html=`curl https://iplocation.com/\
	 --silent\
	 -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0'\
	 --compressed`

	city=`echo $html | xmllint --html --xpath '//table/tr/td[@class="city"]/text()' - 2> /dev/null`
	region=`echo $html | xmllint --html --xpath '//table/tr/td/span[@class="region_name"]/text()' - 2> /dev/null`
	country=`echo $html | xmllint --html --xpath '//table/tr/td/span[@class="country_name"]/text()' - 2> /dev/null`

	echo "1. $city / $region / $country (www.iplocation.com)"
}

db_ip() {
	ip=`curl --silent ifconfig.me`
	city=`curl --silent http://api.db-ip.com/v2/free/$ip/city`
	region=`curl --silent http://api.db-ip.com/v2/free/$ip/stateProv`
	country=`curl --silent http://api.db-ip.com/v2/free/$ip/countryName`
	echo "2. $city / $region / $country (www.db-ip.com)"
}

what_is_my_ip_com() {
	ip=`curl --silent ifconfig.me`
	html=`curl --silent "https://whatismyipaddress.com/ip/$ip" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed`
	basePath="/html/body/div/div/div/div[2]/div[2]/div[2]/div[2]/table/tbody"
        city=`echo $html | xmllint --html --xpath '//div[@id="section_left_3rd"]/table/tr[4]/td/text()' - 2> /dev/null`
        region=`echo $html | xmllint --html --xpath '//div[@id="section_left_3rd"]/table/tr[4]/td/text()' - 2> /dev/null`
        country=`echo $html | xmllint --html --xpath '//div[@id="section_left_3rd"]/table/tr[2]/td/text()' - 2> /dev/null`
        echo "3. $city / $region / $country (www.whatismyipaddress.com)"

}

echo "# Checking public ip location ..."
iplocation_com
db_ip
what_is_my_ip_com
