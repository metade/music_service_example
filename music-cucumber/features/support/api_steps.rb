require 'jsonpath'
require 'pp'

# TODO: is there a cleaner way of doing this?
class Capybara::Driver::Mechanize < Capybara::Driver::RackTest
  def post_body(url, body, headers = {})
    if remote?(url)
      process_remote_request(:post, url, body, headers)
    else
      register_local_request
      super
    end
  end
  
  def put_body(url, body, headers = {})
    if remote?(url)
      process_remote_request(:put, url, body, { :headers => headers })
    else
      register_local_request
      super
    end
  end
end

def expand_path(path)
  if path =~ /(:\w+)/
    field = $1
    collection_path = path[0,path.index(field)]
    response = RestClient.get "#{Capybara.app_host}#{collection_path}", :content_type => :json, :accept => :json
    objects = JSON.parse(response.body).values.detect { |o| o.kind_of? Array }
    url_key = objects.last[field.sub(':','')]
    result = path.sub(field, url_key)
  elsif path =~ /(@\w+)/
    result = path.gsub(/@\w+/) { |i| instance_variable_get(i) }
  else
    result = path
  end
  # result += ".#{@content_type}" if @content_type
  result
end

Given /^I send and accept XML$/ do
  @content_type = 'xml'
  page.driver.header 'Accept', 'text/xml'
  page.driver.header 'Content-Type', 'text/xml'
end

Given /^I send and accept JSON$/ do
  @content_type = 'json'
  page.driver.header 'Accept', 'application/json'
  page.driver.header 'Content-Type', 'application/json'
end

When /^I authenticate as the user "([^\"]*)" with the password "([^\"]*)"$/ do |user, pass|
  page.driver.authorize(user, pass)
end

When /^I send a GET request (?:for|to) "([^\"]*)"$/ do |path|
  page.driver.get(expand_path(path), {}, { 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
end

When /^I send a POST request to "([^\"]*)"$/ do |path|
  page.driver.post expand_path(path)
end

When /^I send a POST request to "([^\"]*)" with the following:$/ do |path, body|
  page.driver.post_body(expand_path(path), body, { 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
end

When /^I send a PUT request to "([^\"]*)" with the following:$/ do |path, body|
  page.driver.put_body(expand_path(path), body, { 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
end

When /^I send a DELETE request to "([^\"]*)"$/ do |path|
  page.driver.delete(expand_path(path), {}, :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
end

Then /^show me the response$/ do
  puts page.driver.response.body
end

Then /^the response status should be "([^\"]*)"$/ do |status|
  if page.respond_to? :should
    page.driver.response.status.should == status.to_i
  else
    assert_equal status.to_i, page.driver.response.status
  end
end

Then /^the response should be empty$/ do
  page.driver.response.body.should be_empty
end

Then /^the JSON response should have "([^\"]*)" with the text "([^\"]*)"$/ do |json_path, text|
  json    = JSON.parse(page.driver.response.body)
  results = JsonPath.new(json_path).on(json).to_a.map(&:to_s)
  if page.respond_to? :should
    results.should include(text)
  else
    assert results.include?(text)
  end
end

Then /^the JSON response should have "([^"]*)" as nil$/ do |json_path|
  json    = JSON.parse(page.driver.response.body)
  results = JsonPath.new(json_path).on(json).to_a
  results.should == [nil]
end

Then /^the JSON response should not have "([^\"]*)" with the text "([^\"]*)"$/ do |json_path, text|
  json    = JSON.parse(page.driver.response.body)
  results = JsonPath.new(json_path).on(json).to_a.map(&:to_s) 
  if page.respond_to? :should
    results.should_not include(text)
  else
    assert !results.include?(text)
  end
end

Then /^the JSON response should have the following:/ do |table|
  json    = JSON.parse(page.driver.response.body)
  table.rows.each do |json_path, text|
    results = JsonPath.new(json_path).on(json).to_a.map(&:to_s)
    if page.respond_to? :should
      results.should include(text)
    else
      assert results.include?(text)
    end
  end
end

Then /^the JSON response should not have the following:/ do |table|
  json    = JSON.parse(page.driver.response.body)
  table.rows.each do |json_path, text|
    results = JsonPath.new(json_path).on(json).to_a.map(&:to_s) 
    if page.respond_to? :should
      results.should_not include(text)
    else
      assert !results.include?(text)
    end
  end
end

Then /^the JSON response should have (\d+) "([^"]*)"$/ do |count, json_path|
  json    = JSON.parse(page.driver.response.body)
  results = JsonPath.new(json_path).on(json)
  results.first.size.should == count.to_i
end

Then /^the XML response should have "([^\"]*)" with the text "([^\"]*)"$/ do |xpath, text|
  parsed_response = Nokogiri::XML(response.body)
  elements = parsed_response.xpath(xpath)
  if page.respond_to? :should
    elements.should_not be_empty, "could not find #{xpath} in:\n#{response.body}"
    elements.find { |e| e.text == text }.should_not be_nil, "found elements but could not find #{text} in:\n#{elements.inspect}"
  else
    assert !elements.empty?, "could not find #{xpath} in:\n#{response.body}"
    assert elements.find { |e| e.text == text }, "found elements but could not find #{text} in:\n#{elements.inspect}"
  end    
end
