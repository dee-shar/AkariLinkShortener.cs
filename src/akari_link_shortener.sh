#!/bin/bash

first_api="https://waa.ai/api"
second_api="https://api.waa.ai/v2"
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0"

function login() {
	# 1 - username: (string): <username>
 	# 2 - password: (string): <password>
	response=$(curl --request POST \
		--url "$first_api/auth/login" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--data '{
			"username": "'$1'",
			"password": "'$2'"
		}')
	if [ -n $(jq -r ".api_key" <<< "$response") ]; then
		api_key=$(jq -r ".api_key" <<< "$response")
		cookie=$(curl -s -i -H "content-type: application/json" -d '{"username":"'$1'","password":"'$2'"}' -X POST "$first_api/auth/login" | grep -iE '^Set-Cookie:' | awk '{print $2}')
	fi
	echo $response

}

function login_with_api_key() {
	# 1 - api_key: (string): <api_key>
	api_key=$1
}

function generate_api_key() {
	curl --request POST \
		--url "$first_api/user/api-key" \
		--user-agent "$user_agent" \
		--header "authorization: api-key $api_key" \
		--header "cookie: $cookie"
}

function shorten_link() {
	# 1 - url: (string): <url>
	curl --request POST \
		--url "$second_api/links" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: api-key $api_key" \
		--data '{
			"url": "'$1'"
		}'
}

function get_link_info() {
	# 1 - short_code: (string): <short_code>
	curl --request GET \
		--url "$second_api/links/$1" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: api-key $api_key"
}

function get_links() {
	curl --request GET \
		--url "$second_api/links" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: api-key $api_key"
}

function delete_link() {
	# 1 - short_code: (string): <short_code>
	curl --request DELETE \
		--url "$second_api/links/$1" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: api-key $api_key"
}
